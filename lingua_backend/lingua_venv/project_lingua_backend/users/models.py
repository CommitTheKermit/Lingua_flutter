from django.db import models



class User(models.Model):
    
    user_id = models.AutoField(primary_key=True)
    email = models.EmailField(max_length=255, default='none')
    password = models.CharField(max_length=60, default='none')
    # nickname = models.CharField(max_length=15)
    phone_no = models.CharField(max_length=20, default='none')
    registration_date = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        db_table = 'User'

class UserCallLimit(models.Model):
    user_id = models.ForeignKey(User, on_delete=models.CASCADE)
    call_limit = models.SmallIntegerField(default=0)
    
    class Meta:
            db_table = 'CallLimit'

class EmailCode(models.Model):
    user_email = models.EmailField(max_length=255, default='none')
    user_code = models.CharField(max_length=6)

    class Meta:
        db_table = 'EmailCode'