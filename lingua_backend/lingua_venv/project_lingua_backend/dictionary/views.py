from django.http            import JsonResponse  
from django.views           import View          
#from django.core.exceptions import ValidationError
#from django.db.models       import Q                                                                                                                
from django.views.decorators.csrf import csrf_exempt

from .models import UserWord, Word
from users.models import User
from .apps import DictionaryConfig
from .nltk_lemmatizer import lemmatizer

import json
import pandas as pd

#로그인
class WordSearchView(View):
     searched_df = pd.DataFrame()
     @csrf_exempt
     def post(self, request):
        data = json.loads(request.body)
        input_word = data['word'].lower()

        try:
            lemmatized_word = lemmatizer(input_word)
            # print(DictionaryConfig.dict_df)
            searched_df = DictionaryConfig.dict_df[DictionaryConfig.dict_df['eng'].str.lower() == \
                                                   lemmatized_word.lower()]
            
            word_list = [{'kor' : row['kor'],
                          'pos' : row['pos'],
                          'meaning': row['meaning'],
                          'example' : row['example'],
                        #   'eng' : row['eng'],
                          'eng_mean' : row['eng_mean'],
                          } for _, row in searched_df.iterrows()]

            # print(lemmatized_word)
            # print(word_list)
            if not searched_df.empty:
                return JsonResponse(word_list, status=200, safe=False)
            else:
                return JsonResponse({"message": f"{lemmatized_word}"}, status=401)
        except: 
            return JsonResponse({"message": "something went wrong"}, status=400)
        
class WordBookView(View):

    @csrf_exempt
    def post(self, request):
        data = json.loads(request.body)
        input_word = data['word'].lower()
        email = data['email']

        try:
            user = User.objects.get(email = email)
            user_id = user.user_id
            if UserWord.objects.filter(user_id = user_id).exists():
                user_word = UserWord.objects.get(email = email)
                new_word = Word(word = input_word)
                user_word.words.append(new_word)
                user_word.save()

                return JsonResponse({"message": "update successful"}, status=200)
            else:
                return JsonResponse({"message": "user not exist"}, status=401)
        except: 
            return JsonResponse({"message": "something went wrong"}, status=400)