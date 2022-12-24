#class 변수 이해

class Family:
    lastname='김'

print(Family.lastname)
a=Family()
b=Family()
print(a.lastname)
print(b.lastname)
print("-"*50)

print(id(Family.lastname))
print(id(a.lastname))
print(id(b.lastname))
#주소가 셋다 동일하게 나옴, 주소 확인하는 것은 id함수
print("-"*50)

Family.lastname='박'
print(Family.lastname)
print(id(Family.lastname))
print(a.lastname)
print(id(a.lastname))

