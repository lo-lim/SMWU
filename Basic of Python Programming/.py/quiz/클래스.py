class Sookmyung:
    pass

school=Sookmyung()

print(isinstance(school, Sookmyung))


import random

def getNumber():
    return random.randint(1,45)

lotto=[]
num=0

print("** 로또 번호를 추천 합니다. **")
while True:
    num= getNumber()

    if lotto.count(num)==0:
        lotto.append(num)

    if len(lotto) >=6:
        break

print("추천된 로또번호==>", end="")
lotto.sort()
for i in range(0,6):
    print("%d" %lotto[i], end=" ")
