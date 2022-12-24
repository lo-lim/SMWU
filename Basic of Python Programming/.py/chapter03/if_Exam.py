#조건문 (if)

'''
money=2000
if money>=3000:
    print("택시를 타고 가라")
else:
    print("걸어가라")

#쉬어가기

import random

print("동전 던지기 게임을 합니다.")
coin=random.randrange(2)  #랜덤으로 0,1중에서 반복해서 나옴
print(coin)
if coin==0:
    print("앞면 입니다.")
else:
    print("뒷면 입니다.")

print("게임이 종료되었습니다.")'''


money=2000
card=1  #True는 1임
if money>=3000 or card:
    print("택시를 타고 가라")
else:
    print("걸어가라")



