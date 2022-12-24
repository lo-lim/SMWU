#함수에 있어서 return문만 있는 경우
'''
def say_nick(nick):
    if nick=="바보":
        return    #nick이 바보면 아무것도 출력하지 않음. return뒤에 아무것도 없으니까
    print("나의 별명은 %s입니다." %nick)

say_nick('바보')
say_nick('천사')  '''

def say_myself(name, old, man=True):
    print("나의 이름은 %s입니다." %name)
    print("나이는 %d살 입니다." %old)
    if man:
        print("남자 입니다.")
    else:print("여자 입니다.")

say_myself("박응용", 27)
print()
say_myself('박응용', 27, man=True)
print()
say_myself('박응선', 27, man=False)