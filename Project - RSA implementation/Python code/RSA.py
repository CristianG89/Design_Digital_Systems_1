#https://www.onlinegdb.com/online_python_compiler

#Inputs are manually introduced (only E is a vector, so checking order inverted)
M = 0b10111010000110111101000101100101
E = [1,0,1,0,0,1,1,1,0,1,1,0,0,1,0,0,0,1,1,1,0,0,1,1,1,0,1,1,1,0,0,0]
N = 0b11111000011001100100111100001011
mx_length = 31

#Intermediate values to generate the output
C = 1
P = M
finish = 0

for i in range(0, mx_length+1):			#RL binary method approach
    if (E[mx_length-i] == 1):           #Inverted order in respect of VHDL
        C = pow(C*P,1,N)				#C = C*P mod N
        #print("Step", i, "C:", hex(C))
    P = pow(P*P,1,N)					#P = P*P mod N
    #print("Step", i, "P:", hex(P))
    
    finish = 0		#If the key E has not more 1s left, the process finishes
    for j in range(i, mx_length+1):     #Inverted order in respect of VHDL
        finish = finish + E[mx_length-j]
    if (finish == 0):
        break

print("FINAL OUTPUT:", hex(C))


# R = 0
# for j in range(32):
#    R = 2*R + C*P(32-j)
#    if (R > N)
#        R = R - N
#    if (R > N)
#        R = R - N