#연산자 *와 len()함수

'''
hours=52
rate=9160
pay=hours*rate
print("총금액:", pay)
x=len("hello")
print(x)
x=0.6
x=3.9*x*(1-x)
print(x) '''


jj=23
kk=jj%5  # %은 나머지
print("kk:", kk)
print(4**3)
print(10/2)
print(99.0/100.0)
print(10//2)
print(9//2)
print(99/100)

age=input("Enter your age")
print(age)
print(type(age))

age=int(input("Enter your age"))
print(age)
print(type(age))
print("나는 더한 값이지렁렁렁:", age+50)

#inpute 앞에 int가 있는 값만 type를 적용했을 떄 int 즉 정수형으로 나옴
#inpute의 기본형은 str, 즉 문자형임