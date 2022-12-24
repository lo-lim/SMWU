#파일 읽고 쓰기

'''
f= open("c:/doit/새파일.txt", "w", encoding='utf-8')
for i in range(1,11):  #1~10
    data=("%d번째 줄입니다.\n" %i)
    f.write(data)
f.close()
'''

f= open("c:/doit/we_will_rock.txt", "w", encoding='utf-8')

data= "Buddy, you're a boy, make a big noise"\
      "Playing in the street, gonna be a big man' somwday"
"You got mud on your face, you big disgrace"
"Kicking your can all over the place, singin"
"We will, we will rock you"
"We will, we will rock you"

f.write(data)
f.close()

name= input("입력할 파일이름:")
f= open(name, "r")
while True:
    data=f.readline()
    data=data.upper()
    if not data:
        break
    print(data.strip('\n'))

f.close()