from django.urls import path, include
from . import views

urlpatterns = [
    #path('recommended', .as_view()),
    path('word/', views.WordSearchView.as_view()),
    path('wordbook/', views.WordBookView.as_view()),
]
