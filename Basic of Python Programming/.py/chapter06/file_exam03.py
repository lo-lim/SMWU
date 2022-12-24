#열기모드(a)
f= open("c:/doit/새파일.txt", "w", encoding='utf-8')
for i in range(1,11):  #11~20
    data=("%d번째 줄입니다.\n" %i)
    f.write(data)
f.close()
