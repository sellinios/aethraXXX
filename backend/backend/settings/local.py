# backend/backend/settings/local.py

from .base import *

# Override database settings for local development
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / 'db.sqlite3',
    }
}

# Set DEBUG to True explicitly for local development
DEBUG = True

# Add localhost to ALLOWED_HOSTS
ALLOWED_HOSTS = ['localhost', '127.0.0.1']

# CORS settings for local development
CORS_ALLOWED_ORIGINS = [
    'http://localhost:3000',  # If your React app runs on port 3000
]

CSRF_TRUSTED_ORIGINS = [
    'http://localhost:3000',
]

# Other local settings can go here
