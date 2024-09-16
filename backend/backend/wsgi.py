# backend/backend/wsgi.py

import os
from django.core.wsgi import get_wsgi_application

# Set the default settings module based on an environment variable, defaulting to production
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'backend.settings.production')

application = get_wsgi_application()
