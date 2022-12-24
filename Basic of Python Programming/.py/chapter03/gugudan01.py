#구구--> 이중 for문 사용

for i in range(2,10): #2~9
    for j in range(1,10): #1~9
        print(i*j, end=" ")
    print('')

#구구단 2 유형
for i in range(2,10): #2~9
    for j in range(1,10): #1~9
        print(i, "x", j, "=", i*j, end=" ")
    print('')

#구구단 1 유형
for i in range(2,10): #2~9
    for j in range(1,10): #1~9
        print(i, "x", j, "=", i*j)
    print('')

#구구단 3 유형
for j in range(1,10): #1~9
    for i in range(1,10): #1~9
        print(i, "x", j, "=", i*j, end=" ")
    print('')