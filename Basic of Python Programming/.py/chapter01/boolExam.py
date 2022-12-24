
#논리연산자
# and : 논리곱, or : 논리합, & : 논리곱(비트연산자), | : 논리합 (비트연산자)
print("#1")
print(True or True, True or False, False or True, False or False)
print(True | True, True | False, False | True, False | False)
print(True and True, True and False, False and True, False and False)
print(True & True, True & False, False & True, False & False)
print("#2")
print(not True, not False)
print(int(True), int(False), float(True), float(False))
print("#3")
print(bool(0), bool(1), bool(-3.14))
print(bool(""), bool(" "), bool("False"))
print("#4")
print(False + False, True + False, True + True, False * True, True * True)
print("#5")
x = True or False & True
y = True or True and False   #and를 먼저하고 or 즉 False가 나오고 True or False해서 True로 출력
print(x, y)
print("#6")
x = (True or False) and True
y = (True or True) and False
print(x,y)
print("#7")
print(not False and False)  #False
print(not False & False)    #True
print(True and (not True))
