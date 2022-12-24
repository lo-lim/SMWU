#with문 사용하기

with open("c:/doit/foo.txt", 'w') as f:
    data=("Life is too short, You need Python")
    f.write(data)

#with문을 쓰면 f.close()가 필요없음, 뒤에 as f: 필수