from django.db import models
from users.models import User

# Create your models here.
class Translated(models.Model):
    user_id = models.ForeignKey(User, on_delete=models.CASCADE)
    # machine_translations = models.JSONField()
    translations = models.JSONField()

    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def add_translation(self, sentence_index,original_text, machine_translated_text, translated_text):
        if not self.translations or not isinstance(self.translations, list):
            self.translations = []

        self.translations.append({
           'sentence_index' : sentence_index,
            "original": original_text,
            "machine_translated": machine_translated_text,
            "translated": translated_text
        })

        self.save()

    class Meta:
        db_table = 'Translated'