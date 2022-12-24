score_list=[5,10,15,20,25,30]
sum_of_score=0
i=0
while i <len(score_list):
    if i%2==0:
        sum_of_score+=score_list[i]
    i+=1
print(sum_of_score)

