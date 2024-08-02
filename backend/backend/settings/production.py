from .base import *

# Production-specific settings can be added here if needed.
# For now, we're inheriting everything from base.py

# You might want to set DEBUG to False here, although it's already set in docker-stack.yml
DEBUG = False

# You can also add any production-specific settings here, such as:
# SECURE_SSL_REDIRECT = True
# SESSION_COOKIE_SECURE = True
# CSRF_COOKIE_SECURE = True