'''
multiline= "Life is too short \nYou need python"
print(multiline)

multiline= """Life is too short
you need python. """
print(multiline)


print('c:\windows\no1SMU\test')     #\n을 기준 앞뒤로 줄 바꿈이 되고 \t을 기준으로 tab이 됨
print('c:\windows\\no1SMU\\test')   #따라서 위처럼 인식되는 걸 막기 위해서 앞에 \를 더 붙임
print(r'c:\windows\no1SMU\test')    #앞에 r을 붙이면 이스케이프 문자로 인식하지 말라는 의미 '''


print('''세상을 바꾸는 부드러운 힘, \n숙명''')
print('''세상을 바꾸는 부드러운 힘, 
숙명''')
print("""세상을 바꾸는 부드러운 힘, 
숙명""")

print("\\\\\\역슬래쉬 세 개 출력")


