from .base import *

DATABASES = {
    'default': {
        'ENGINE': os.environ.get('DJANGO_DB_ENGINE', 'django.db.backends.postgresql'),
        'NAME': os.environ.get('POSTGRES_DB', 'aethradb'),
        'USER': os.environ.get('POSTGRES_USER', 'sellinios'),
        'PASSWORD': os.environ.get('POSTGRES_PASSWORD', 'faidra123!@#'),
        'HOST': os.environ.get('POSTGRES_HOST', 'db'),
        'PORT': os.environ.get('POSTGRES_PORT', '5432'),
    }
}
