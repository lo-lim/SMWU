#조건문 연습

'''
pocket=['paper', 'cellphone']
card=False
if 'money' in pocket:
    print("택시를 타고 가라")
elif card:
        print("택시를 타고 가라")
else:
        print("걸어가라") '''

score=80
if score >=80:
    message= 'success'
else:
    message= 'failure'
print(message)

message= "success" if score >=60 else "failure"  #위에 조건문과 동일, 한줄로 간편하게 표현
print(message)

