#문자열 인덱싱, 슬라이싱

a= "Life is too short, you need python"
print(a[3])   #파이썬에서 인덱싱을 할 때 처음 값의 인덱싱 값은 무조건 0이다. 1이 아닌 0부터 시작

b= a[0]+a[1]+a[2]+a[3]
print(b)

print(a[0:4])
print(a[0:2])
print(a[:17])
print(a[19:])
print(a[:])   #처음부터 끝까지 출력
print(a[19:-7])