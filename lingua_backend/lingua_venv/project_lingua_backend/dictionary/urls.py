from django.urls import path, include
from . import views

urlpatterns = [
    #path('recommended', .as_view()),
    path('word/', views.SingleWordView.as_view()),
]
