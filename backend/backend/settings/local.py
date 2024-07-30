from .base import *

# Override database settings for local development
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / 'db.sqlite3',
    }
}

# Other local settings can go here

# For example, you might want to set DEBUG to True explicitly in local settings
DEBUG = True

# Optionally, you can also add other settings specific to your local environment
