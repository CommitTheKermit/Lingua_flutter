from django.urls import path
from .views import AddTextView,JSONTransferView

urlpatterns = [
    path('addtext', AddTextView.as_view()),
    path('gettext', JSONTransferView.as_view()),
]