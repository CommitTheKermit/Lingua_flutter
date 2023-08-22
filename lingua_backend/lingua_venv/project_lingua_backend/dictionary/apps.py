from django.apps import AppConfig
from django.conf import settings
from .nltk_lemmatizer import download_necessaries
import pandas as pd
import os

class DictionaryConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'dictionary'
    dict_df = pd.DataFrame()

    def ready(self):
        # from .nltk_lemmatizer import download_necessaries
        download_necessaries()
        file_path = os.path.join(settings.BASE_DIR, 'dictionary', 'expanded_dict_eng_irr.csv')
        DictionaryConfig.dict_df = pd.read_csv(file_path)
        # self.dict_df = pd.read_csv('dict.csv')
        print('readied')