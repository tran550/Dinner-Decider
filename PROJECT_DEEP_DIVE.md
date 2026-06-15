# Dinner-Decider Deep Dive

## Project Overview

Dinner-Decider is a cloud-hosted AI-powered web application that generates recipes based on user-selected cooking preferences or a random recipe option.

The application is built with Flask and runs inside a Docker container hosted on an AWS EC2 instance. Infrastructure is provisioned using Terraform, and deployments are automated through GitHub Actions CI/CD.

When a user submits their preferences, the Flask application sends a request to the Gemini API to generate a recipe. Once the recipe is generated, the application extracts the recipe name and sends a second request to the Unsplash API to retrieve a relevant image. The recipe and image are then rendered together and returned to the user through the web interface.

## Architecture

Infrastructure Diagram

![Infrastructure Diagram](/diagrams/Dinner_decider_infra.drawio.png)



Deployment Diagram

![Deployment Diagram](/diagrams/Dinner_Decider_Deployment.drawio.png)

## Request Flow

![Application Request Diagram](diagrams/Application_Request_Flow.drawio.png)

1. User generates recipe request from preference inputs or random generation
2. Flask receives request
3. Gemini API called
4. Response returns recipe JSON
5. Unsplash API called
6. Image URL of recipe returned
7. Flask App renders recipe and image of recipe to User

## AWS Infrastructure

### EC2
Purpose

### Security Groups
Purpose

## Docker

### Dockerfile

FROM python:3.11
Why?

COPY .
Why?

etc.

## GitHub Actions

Step 1:
Purpose

Step 2:
Purpose

## Terraform

main.tf

What it creates

variables.tf

Purpose

outputs.tf

Purpose

## Lessons Learned

Challenges encountered