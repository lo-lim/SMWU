print("두 정수를 입력하시오.")
a=int(input())
b=int(input())

if a%b==0:
    print("%d는(은) %d의 배수 입니다." %(a,b))
else:
    print("%d는(은) %d의 배수가 아닙니다." % (a,b))