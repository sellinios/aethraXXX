# api/urls.py

from django.urls import path
from . import views

urlpatterns = [
    path('', views.index),  # This should not conflict with the admin path
    # Add other paths here
]
