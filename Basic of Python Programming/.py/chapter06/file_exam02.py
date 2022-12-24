#파일 읽기 모드
'''
f= open("c:/doit/새파일.txt", "r", encoding='utf-8')
while True:
    line=f.readline()
    if not line:
        break
    print(line.strip('\n'))   #print는 아예 띄어쓰기를 하고 출력하니까 줄 바꿈을 빼줘야 함
f.close()

f= open("c:/doit/새파일.txt", "r", encoding='utf-8')
data=f.readlines()
print(data)
for line in data:
    print(line.strip('\n'))  '''

f= open("c:/doit/새파일.txt", "r", encoding='utf-8')
data=f.read()
print(data)