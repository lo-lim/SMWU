#문자열 함수

a= "python is the best choice"
print(a.find('b'))  #.find()함수를 통해서 'b'가 a문자열에서 몇 번째 인덱스에 있는지
print(a.index('b'))
print(a.find('k'))
# print(a.index('k'))

#.find()는 함수는 찾는 문자가 문자열에 없으면 -1을 반환하지만
#.index()함수는 찾는 문자가 문자열에 없으면 오류가 발생한다.

#.join()
print(','.join('abcd'))  #abcd사이에 ','을 붙여준다.
print('#'.join('abcd'))

#strip()함수
a="          hi"
print(a.lstrip())  #a문자열에서 즉 hi 왼쪽에 있는 공백을 지워줌
a="   hi     "
print(a.rstrip())  #a문자열에서 즉 hi 오른쪽에 있는 공백을 지워줌
print(a.strip())   #a문자열제서 즉 hi 왼쪽과 오른쪽에 있는 모든 공백을 지워줌

#replace()
a= "Life is too short"
print(a.replace("Life", "your leg"))

print(a.split()) #split()함수는 공백을 기준으로 문자열을 리스트로 분리
print(len(a))
b=a.split()
print(len(b))  #b는 a를 공백을 기준으로 쪼개서 리스트로 된 형태기에 리스트 안에 원소 4개


a= "a:b:c:d"
print(a.split(':'))
b= "a#b#c#d"
print(b.split('#'))
#각각의 기준이 되는 인자로 구분할 수도 있다. : or #

#대문자--->소문자 lower()
a="HI"
print(a)
print(a.lower())

#소문자--->대문자 upper()
b="hi"
print(b)
print(b.upper())

