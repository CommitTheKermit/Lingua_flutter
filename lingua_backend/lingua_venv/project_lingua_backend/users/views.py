from django.http            import JsonResponse  
from django.views           import View          
#from django.core.exceptions import ValidationError
#from django.db.models       import Q                                                                                                                
from django.views.decorators.csrf import csrf_exempt

from .models                import EmailCode, User
from .serializer import UserSerializer
from .email_verification import email_validate

import random
import json
import bcrypt

#로그인
class LoginView(View):
     @csrf_exempt
     def post(self, request):
        data = json.loads(request.body)

        try:
            email = data['email']
            password = data['password']
            customer = User.objects.filter(email = email)
            if customer.exists():
                customer = customer[0]

                #chekpw 메소드를 이용해 사용자가 입력한 패스워드의 해시 값과 데이터 베이스에 저장된 해시 값을 비교
                if bcrypt.checkpw(password.encode('utf-8'), customer.password.encode('utf-8')):
                    # serialzer_user = UserSerializer(customer)

                    return JsonResponse({'message': "LOGIN_SUCCESS",}, status=200)
                else:
                    return JsonResponse({"message": "INVALID_PASSWORD"}, status=401)

            # email 틀렸을시 return    
            return JsonResponse({"message": "USER_NOT_FOUND"}, status=404)
        except: 
            return JsonResponse({"message": "INVALID_KEYS"}, status=400)
        
#회원가입
class SignUpView(View):
    # post방식으로 요청할 경우 회원가입한다.
    def post(self, request):
        data = json.loads(request.body)

        #비밀번호를 bcrypt 해싱 기법으로 해시 후 데이터 베이스에 저장
        hashed_password = bcrypt.hashpw(data['password'].encode('utf-8'), bcrypt.gensalt())
        decoded_hashed_pw = hashed_password.decode('utf-8')
        
        if User.objects.filter(email = data['email']).exists():
            return JsonResponse({'message' : "EMAIL_EXISTS"},status =409) 
        
        try :    
            User(
                email    = data['email'],
                password    = decoded_hashed_pw,
                phone_no = data['phone_no'],
            ).save()
            
            return JsonResponse({'message':'SIGNUP_SUCCESS'}, status=200)
        except:
            return JsonResponse({'message' : "SIGNUP_FAILED"},status =400) 

    # 조회 get id값으로 !get_all 보내면 전체 조회, 특정 아이디 보내면 해당 아이디 정보 반환
    def get(self, request):
        reqString = request.GET.get('email', None)
        # if reqString == "!get_all":
        #     user_data = Customer.objects.values()
        #     return JsonResponse({'users':list(user_data)}, status=20)
        
        if User.objects.filter(email = reqString).exists():
            account = User.objects.get(email = reqString)
            # serializer = User_basic_serializer(account)
            return JsonResponse({"email" : "exist"}, status= 200)
        else:
            return JsonResponse({'message' : "INVALID_KEYS"},status=400)

#이메일 찾기   
class FindEmailView(View):
    #조회 get id값으로 !get_all 보내면 전체 조회 특정 아이디 보내면 해당 아이디 정보 반환
    def post(self, request):
        data = json.loads(request.body)

        if User.objects.filter(phone_no = data['phone_no']).exists():
            user_data = User.objects.get(phone_no = data['phone_no'])
            return JsonResponse({'message': "EMAIL_FOUND_SUCCESS",
                                 'email': user_data.email}, status=200)
        
        else:
            return JsonResponse({'message' : "USER_NOT_FOUND"},status=404) 
        
#비번 찾기
class FindPwView(View):
    # 이메일 전화번호 전달받아 해당 이메일, 전화번호를 가진 유저의 비밀번호 변경
    def post(self, request):
        data = json.loads(request.body)

        if User.objects.filter(email = data['email'], phone_no = data['phone_no']).exists():

            return JsonResponse({'message': "PASSWORD_FIND_SUCCESS"}, status=200)
        else:
            return JsonResponse({'message' : "USER_NOT_FOUND"},status =404)

class ChangePwView(View):
    def post(self, request):
        data = json.loads(request.body)

        if User.objects.filter(email = data['email'], phone_no = data['phone_no']).exists():
            user_data = User.objects.get(email = data['email'],  phone_no = data['phone_no'])

            # Update fields from request
            hashed_password = bcrypt.hashpw(data['password'].encode('utf-8'), bcrypt.gensalt())
            pw = hashed_password.decode('utf-8')
            setattr(user_data, 'password', pw)
            # print(user_data.password)
            # Save the updated instance
            user_data.save()
            return JsonResponse({'message': "PASSWORD_CHANGE_SUCCESS"}, status=200)
        else:
            return JsonResponse({'message' : "USER_NOT_FOUND"},status =400)
        
class EmailSendView(View):
    def post(self, request):
        data = json.loads(request.body)
        code = random.sample(range(10), 6)
        code = ''.join(map(str,code))
        
        existFlag = EmailCode.objects.filter(user_email = data['email']).exists()

        if not existFlag:
            EmailCode(
                user_email    = data['email'],
                user_code     = code
            ).save()
            
            try:
                email_validate(data['email'], code)
                return JsonResponse({'message':"EMAIL_SENT_SUCCESS"}, status=200)
            except:
                return JsonResponse({'message' : "EMAIL_SENDING_FAILED"},status =400) 
        
        elif existFlag:
            email_code = EmailCode.objects.get(user_email = data["email"])
            print(email_code.user_email)
            email_code.delete()

            EmailCode(
                user_email    = data['email'],
                user_code     = code
            ).save()
            try:
                email_validate(data['email'], code)
                return JsonResponse({'message':"EMAIL_RESENT_SUCCESS"}, status=200)
            except:
                return JsonResponse({'message' : "EMAIL_SENDING_FAILED"},status =400) 
    
        
class EmailVerifyView(View):
    def post(self, request):
        data = json.loads(request.body)

        if EmailCode.objects.filter(user_email = data["email"]).exists():
            email_code = EmailCode.objects.get(user_email = data["email"])
            try:
                if email_code.user_code == data["user_code"]:
                    email_code.delete()
                    return JsonResponse({'message':"EMAIL_VERIFICATION_SUCCESS"}, status=200)
                else:
                    return JsonResponse({'message' : "INCORRECT_EMAIL_VERIFICATION"},status =400) 
            except:
                return JsonResponse({'message' : "EMAIL_VERIFICATION_FAILED"},status =400) 
