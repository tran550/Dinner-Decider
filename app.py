from flask import Flask, render_template, request
from google import genai
from dotenv import load_dotenv
import json
import os
import re
import urllib.parse
import requests

load_dotenv()

client = genai.Client()

app = Flask(__name__)

client = genai.Client(api_key=os.environ.get("GEMINI_API_KEY"))
MODEL_ID = "gemini-3.1-flash-lite"

@app.route("/")
def home():
    return render_template("index.html")


@app.route("/generate")
def generate():
    cuisine = request.args.get("cuisine")
    difficulty = request.args.get("difficulty")
    prep_time = request.args.get("prep time")

    recipe = generate_recipe(cuisine, difficulty, prep_time)
    recipe_image = get_unsplash_image(recipe["recipe_name"])

    return render_template("index.html", recipe=recipe, recipe_image=recipe_image)

def generate_recipe(cuisine, difficulty, prep_time):
    
    prompt = f"""
    You are a generator that MUST return valid JSON only. DO NOT include any explanation,
    no markdown, no backticks, and no extra text before or after the JSON. Use double quotes
    for strings and no trailing commas. The JSON object must exactly match this schema:

    {{
        "recipe_name": "string",
        "prep_time": "string",
        "ingredients": ["string", ...],
        "instructions": ["string", ...]
    }}

    Now produce a unique dinner recipe using:
    Cuisine: {cuisine}
    Difficulty: {difficulty}
    Prep Time: {prep_time}

    Return the JSON object only.
    """

    response = client.models.generate_content(
        model="gemini-3.1-flash-lite",
        contents=prompt,
        config={"response_mime_type": "application/json"}
    )

    text = response.text
    try:
        return json.loads(text)
    except json.JSONDecodeError as e:
        print("JSON parse error:", e)
        print("Full model output:", text)
        m = re.search(r'(\{[\s\S]*\})', text)
        if m:
            try:
                return json.loads(m.group(1))
            except json.JSONDecodeError:
                pass
        raise RuntimeError("Model did not return valid JSON. See server logs for model output.")

def get_unsplash_image(recipe_name):
    query = urllib.parse.quote(f"{recipe_name} food")
    url = f"https://api.unsplash.com/search/photos?query={query}&per_page=1"
    key = os.environ.get('UNSPLASH_KEY')
    if not key:
        return "https://source.unsplash.com/featured/800x600/?food"

    headers = {"Authorization": f"Client-ID {key}"}

    try:
        r = requests.get(url, headers=headers, timeout=10)
        r.raise_for_status()
        data = r.json()
        results = data.get("results") or []
        if results:
            first = results[0]
            # preferred: object with 'urls' dict
            if isinstance(first, dict):
                urls = first.get("urls") or {}
                # prefer common sizes in order
                for key_name in ("regular", "full", "small", "thumb"):
                    if urls.get(key_name):
                        return urls[key_name]
                # if urls exists but keys missing, try any value
                if urls:
                    for v in urls.values():
                        return v
            # if API returned a plain string or unexpected structure, coerce to string
            if isinstance(first, str):
                return first
            return str(first)
    except requests.RequestException as e:
        print("Unsplash request failed:", e)

    # Fallback when no image is found or API fails
    return "https://source.unsplash.com/featured/800x600/?food"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)