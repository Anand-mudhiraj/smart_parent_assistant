from django.urls import path
from . import views

urlpatterns = [
    path('analyze/', views.analyze_situation, name='analyze_situation'),
]
