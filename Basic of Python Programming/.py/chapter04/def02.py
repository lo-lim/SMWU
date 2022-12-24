#결과값이 없는 함수
'''

def add(a,b):
    print("%d, %d의 합은 %d 입니다." %(a,b,a+b))

a=add(3,4)
print(a) #return 구문이 없기 때문에 print(a)를 하면 None이 나옴


def say():
    print("Hi")
say()
a=say()
print(a)  #return이 없기 때문에 a를 지정해도 None이 나옴

def add(a,b):
    return a+b

result=add(a=3, b=7)
print(result)  '''



