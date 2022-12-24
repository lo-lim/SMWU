#lambda()함수

def add(a,b):
    return a+b
result=add(3,4)
print("add", result)

add=lambda a,b:a+b
result=add(3,4)
print("lambda", result)
#lambda함수는 def함수와 다르게 return을 하지 않아도 됨
