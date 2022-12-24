kor=int(input("국어점수(kor):"))
eng=int(input("영어점수(eng):"))
mat=int(input("수학점수(mat):"))
sum=kor+eng+mat
avg="%.1f" %(sum/3)

print("눈송이 학생의 총점은 sum=", sum, "이며 평균은 avg=",avg, "입니다.")