from django.db import models
from users.models import User

# Create your models here.
class Translated(models.Model):
    user_id = models.ForeignKey(User, on_delete=models.CASCADE)
    translations = models.JSONField()
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def add_translation(self, original_text, translated_text):
        if not self.translations:
            self.translations = []

        self.translations.append({
            "original": original_text,
            "translated": translated_text
        })
        self.save()

    class Meta:
        db_table = 'Translated'