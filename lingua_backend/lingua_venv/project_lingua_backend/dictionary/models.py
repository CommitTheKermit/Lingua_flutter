from django.db import models
from djongo import models as djongo_models
from users.models import User

class Word(models.Model):
    word = models.CharField(max_length=64)

    class Meta:
        abstract = True

class UserWord(models.Model):
    user_id = models.ForeignKey(User, on_delete=models.CASCADE)
    words = djongo_models.ArrayField(model_container=Word)
    timestamp = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        db_table = "WordBook"