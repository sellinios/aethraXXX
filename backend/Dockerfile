# Use the official Python image from the Docker Hub
FROM python:3.12.4-slim

# Install PostgreSQL client libraries and build tools
RUN apt-get update && apt-get install -y \
    libpq-dev \
    gcc

# Set environment variables
ENV PYTHONUNBUFFERED 1

# Set work directory
WORKDIR /code

# Install dependencies
COPY requirements.txt /code/
RUN pip install --upgrade pip && pip install -r requirements.txt
RUN pip install django-cors-headers  # Add this line

# Copy project
COPY . /code/

# Collect static files
RUN python manage.py collectstatic --noinput

# Run the application
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "backend.wsgi:application"]
