#!/usr/bin/env python
"""Django's command-line utility for administrative tasks."""
import os
import sys

def main():
    """Run administrative tasks."""
    # Set default settings module, which can be overridden by environment variable
    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'backend.settings.local')

    # Override the settings module with an environment variable if set
    settings_module = os.environ.get('DJANGO_SETTINGS_MODULE')
    if settings_module:
        os.environ['DJANGO_SETTINGS_MODULE'] = settings_module

    try:
        from django.core.management import execute_from_command_line
    except ImportError as exc:
        # Exception handling code...
        raise exc
    execute_from_command_line(sys.argv)

if __name__ == '__main__':
    main()
