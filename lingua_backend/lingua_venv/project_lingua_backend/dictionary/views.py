from django.http            import JsonResponse  
from django.views           import View          
#from django.core.exceptions import ValidationError
#from django.db.models       import Q                                                                                                                
from django.views.decorators.csrf import csrf_exempt


from .apps import DictionaryConfig
from .nltk_lemmatizer import lemmatizer

import json
import pandas as pd

#로그인
class SingleWordView(View):
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
            
            # for idx in searched_df.index:
            #     word_mean = (
            #         searched_df
            #     )
            # searched_df = pd.DataFrame()
            print(lemmatized_word)
            print(word_list)
            if not searched_df.empty:
                return JsonResponse(word_list, status=200, safe=False)
            else:
                return JsonResponse({"message": f"{lemmatized_word}"}, status=401)
        except: 
            return JsonResponse({"message": "something went wrong"}, status=400)