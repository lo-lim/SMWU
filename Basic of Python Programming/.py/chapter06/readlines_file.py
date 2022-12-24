#readline() :데이터를 하나씩 읽음
f = open("C:/doit/yesterday.txt",'r')
score = f.readline()
print(score)    #첫번째 데이터

#readlines() : 한줄씩 끝까지 데이터 읽음
f = open("C:/doit/yesterday.txt",'r')
score = f.readlines()
print(score)
f.close()
print()

#read() :한번에 데이터 전부 read
f = open("C:/doit/yesterday.txt",'r')
score = f.read()
print(score,end='')
f.close()
