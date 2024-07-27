# Use the official Python image from the Docker Hub
FROM python:3.12.4-slim

# Install PostgreSQL client libraries and build tools
RUN apt-get update && apt-get install -y \
    libpq-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    DJANGO_SETTINGS_MODULE=backend.settings \
    DJANGO_DEBUG=False \
    DJANGO_ALLOWED_HOSTS="kairos.gr www.kairos.gr localhost 127.0.0.1 10.152.183.0/24"

# Set work directory
WORKDIR /code

# Install dependencies
COPY requirements.txt /code/
RUN pip install --upgrade pip && \
    pip install -r requirements.txt && \
    pip install django-cors-headers gunicorn

# Copy project
COPY . /code/

# Collect static files
RUN python manage.py collectstatic --noinput

# Run the application
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "backend.wsgi:application"]