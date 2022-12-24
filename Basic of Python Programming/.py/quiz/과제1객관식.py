#문제 1

num1 = (12, 22, 37, 41, 58)
num2 = (1, 2, 3, [11, 12, 13], 5, 6)
print(num1[-1] + num2[3][2] + num1[2])

#문제 2
s1 ='Simple is better than complex.'
print(s1.split())  #.split()는 ()안에 들어있는 기호를 기준으로 분리하여 리스트 형태로 만듦

#문제 4
mylist=['sookmyung', 'seoul']
del mylist[1]
mylist.insert(0, 'python')
print(mylist)

#문제 5
a=[1,2,3]
b=[4,5,6]
b.extend(a)
print(b)

#문제 6
mylist=[200, 300, 100, 50]
mylist.reverse()
print(mylist)
mylist.reverse()
print(mylist)
mylist.sort()
print(mylist)

#문제 7
str= "I love you"
str.replace('you', 'U')
print(str)

#문제 8
a = {'name':'Paul', 3:[1, 2, 3], 2:'b', 1:'a'}
del a[3]
print(a)

#문제 9
a=[1,2,3]
a.insert(0,4)
print(a)
a.insert(3,5)
print(a)

#문제 10
s1=set([1,2,3])
s1.add(4)
print(s1)
s1.update([5,6,7])
print(s1)
s1.remove(4)
print(s1)

#문제 11
a="a:b:c:d"
b=a.replace(":", "#")
print(b)

#문제 12
s1 = [1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5, 6, 7, 7]
s2= set(s1)  #집합 형태로 변경해서 중복되는 요소를 없애고
print(s2)
s3=list(s2) #다시 list 형태로 변환
print(s3)

#문제 13
a=["apple", "banana", [1,2, ["@", "%"]]]
print(a[2][2][1])
print(a[-1][-1][-1])

#문제 14
a="SookNyung"
print(a[:4]+"M"+a[5:])

#문제 15
a=["Life", "is", "too", "short"]
result=" ".join(a)
print(result)

#문제 16
a=[1,2,3,5]
b=['a', 'b', 'c', 'd', 'e']
a.append('g')
b.append(6)
print('g' in b, len(b))

#문제 17
menu = {"커피":7, "펜":3, "종이컵":2, "우유":1, "콜라":4, "빵":5}
name=input("물건 이름 입력:")
print("재고:", menu[name])

#문제 18
partA= set(["Park", "Kim", "Lee"])
partB= set(["Park", "Choi", "Nam"])
print("2개의 파티에 참석한 사람은 다음과 같습니다.")
print(partA.intersection(partB))

#문제 19
student_no=1912168
name="이호림"
SM_ID=str(student_no)+name
print(SM_ID)
print(SM_ID*3)

#문제 20
d={'name':'홍길동', 'age':30}
print(f'나의 이름은 {d["name"]}입니다. 나이는 {d["age"]}입니다.')





