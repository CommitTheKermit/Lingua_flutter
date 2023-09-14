from django.shortcuts import render
from django.http            import HttpResponseBadRequest, JsonResponse, HttpResponse
from django.views           import View          
from django.core.serializers import serialize
#from django.core.exceptions import ValidationError
#from django.db.models       import Q                                                                                                                

from .models                import Translated, User

import random
import json
import bcrypt

# Create your views here.

class AddTextView(View):
    def post(self, request):
        try:
            data = json.loads(request.body)
            email = data['email']


            # 입력 데이터 검증
            if not all(key in data for key in ["original", "machine_translated", "translated"]):
                return HttpResponseBadRequest("Invalid data")

            user = User.objects.get(email = email)
            

            if Translated.objects.filter(user_id = user).exists():
                translation_instance = Translated.objects.get(user_id = user)
                for translation in translation_instance.translations:
                    # print(translation)
                    if translation['original'] == data['original']:
                        translation['translated'] = data['translated']
                        translation_instance.save()
                        return JsonResponse({"message": "UPDATE SUCCESS"}, status =200)
                    
                translation_instance.add_translation(
                    data['sentence_index'],
                    data["original"],
                    data["machine_translated"],
                    data["translated"]
                )
                return JsonResponse({"message": "EXSISTED TRANSLATED UPDATE SUCCESS"}, status =200)


            else:
                translation_instance = Translated(user_id=user)
                translation_instance.add_translation(
                    data['sentence_index'],
                    data["original"],
                    data["machine_translated"],
                    data["translated"]
                )
                return JsonResponse({"message": "NEW ADD SUCCESS"}, status =200)

        except Exception as e:
            return JsonResponse({ "message": f'SOMETHING WENT WRONG\n{str(e)}'}, status=400)
        
class JSONTransferView(View):
    def post(self, request):
        try:
            data = json.loads(request.body)
            email = data['email']


            # 입력 데이터 검증

            user = User.objects.get(email = email)
            

            if Translated.objects.filter(user_id = user).exists():
                translation_instance = Translated.objects.get(user_id = user)
                print(translation_instance)
                
                data = serialize('json', [translation_instance])
                print(data)
                return HttpResponse(data, content_type='application/json', status=200)
                # for translation in translation_instance.translations:
                #     print(translation)
                #     if translation['original'] == data['original']:
                #         return JsonResponse({"message" : "EXIST", 'translated' : translation['translated'],}, status =200)
                    
                # return JsonResponse({"message": "NONEXIST"}, status =400)

            else:
                return JsonResponse({"message": "NONEXIST"}, status =400)

        except Exception as e:
            return JsonResponse({ "message": f'SOMETHING WENT WRONG\n{str(e)}'}, status=400)

