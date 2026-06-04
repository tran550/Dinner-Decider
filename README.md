# Dinner Decider

Dinner Decider is a Flask-based recipe generator web application that creates unique dinner ideas based on cuisine, difficulty, and prep time. It includes a polished UI, a handy "Choose for me" randomizer, and Docker support for easy deployment.

## Features

- **Recipe generation** — Generate recipes from user inputs or use the built-in randomizer.
- **Choose for me** — One click fills hidden random values and returns a new dinner idea without changing the visible form values.
- **Custom cuisine support** — Select a cuisine or enter your own custom type.
- **Interactive UI** — Modern landing experience with a hero section, styled form panel, and result card.
- **Docker-ready** — Build and run in a container with minimal setup.

## Prerequisites

- Python 3.8+
- Google GenAI API key
- Docker (optional)

## Installation

### Local Setup

1. Open a terminal and go to the project folder:
   ```bash
   cd dinner_decider
   ```

2. Create and activate a virtual environment:
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

4. Create a `.env` file in the project root and add your API key:
   ```bash
   GEMINI_API_KEY=your_google_genai_api_key_here
   ```

5. Start the app:
   ```bash
   python app.py
   ```

6. Open `http://localhost:5000` in your browser.

## Docker Deployment

### Build

```bash
docker build -t dinner-decider .
```

### Run

```bash
docker run -e GEMINI_API_KEY="your_api_key_here" -p 5000:5000 dinner-decider
```

Then visit `http://localhost:5000`.

### Cleanup

```bash
docker rmi dinner-decider
docker container prune
```

## Usage

1. Visit `http://localhost:5000`
2. Choose a cuisine or type a custom cuisine
3. Pick a difficulty level
4. Use the prep time slider to set your desired cook time
5. Click **Generate Dinner Idea** to see the recipe
6. Or click **Choose for me** to generate a random dinner idea instantly

## Project Structure

```
dinner_decider/
├── app.py                  # Flask application and recipe generation logic
├── requirements.txt        # Python dependencies
├── Dockerfile              # Container configuration
├── .env                    # Environment variables (not committed)
├── recipes.json            # Sample recipe data file
├── static/
│   └── styles.css          # Application styling
└── templates/
    └── index.html          # Main page template
```

## File Overview

| File | Purpose |
|------|---------|
| `app.py` | Flask routes and recipe generation code |
| `templates/index.html` | Front-end form, homepage layout, and recipe output |
| `static/styles.css` | UI styling for the hero section, form, and recipe card |
| `Dockerfile` | Docker image build instructions |
| `requirements.txt` | Required Python packages |

## Dependencies

- **Flask** — Web framework
- **google-genai** — Google GenAI client library
- **python-dotenv** — Loads environment variables from `.env`

## Environment Variables

| Variable | Description |
|----------|-------------|
| `GEMINI_API_KEY` | Google GenAI API key for recipe generation |

## Notes

- The app currently generates recipes using the Google GenAI API.
- Use the hidden `Choose for me` randomizer to request a random dinner idea without changing the visible form values.
- If you want to swap AI image generation for image search later, you can integrate Unsplash or another image provider.

## Troubleshooting

### Flask not reachable in Docker
- Confirm `app.py` runs with `host="0.0.0.0"`
- Use `docker run -p 5000:5000 dinner-decider`

### API key issues
- Set `GEMINI_API_KEY` in `.env` or pass it with `-e` when running Docker
- Verify the key is valid and active

## License

Open source for personal and educational use.

## Author

Brandon Tran
