from calculator import*

user_input= input("사칙연산 프로그램:")
first_val= int(user_input[0])
second_val=int(user_input[2])
fourcal= user_input[1]

if fourcal =="+":
    result= add(first_val, second_val)

elif fourcal =="-":
    result=sub(first_val, second_val)

elif fourcal =="*":
    result=mul(first_val, second_val)

else:
    result=div(first_val, second_val)

print("실행결과:", result)