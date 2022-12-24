import random
time= random.randint(1,24)
print("좋은 아침 입니다. 지금 시간은 "+str(time)+"시 입니다.")
sunny=random.choice([True, False])
if sunny:
    print("현재 날씨는 화창 합니다.")
else:
    print("지금 날씨는 화창하지 않습니다.")

i=[6,7,8,9]
if time in i and sunny:
    print("앵무새가 노래를 합니다.")
else:
    print("앵무새가 노래를 하지 않습니다.")