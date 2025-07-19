from fpga_frimware import open_mtx
from random import randint
import numpy as np



# Creating a function to make it easier to generate matrices
def rand_mtx_gen(size, value = 1):
    mtx = []

    if value == 0:

        for i in range (0,size):
            t = []
            for j in range(0,size):
                t.append(0)
            mtx.append(t)
        return mtx
    else  :       
        for i in range (0,size):
            t = []
            for j in range(0,size):
                t.append(randint(0, 128))
            mtx.append(t)
        return mtx
    




# generating random matrices A and B
A = rand_mtx_gen(4)
B = rand_mtx_gen(4)


# initializing and using the FPGA
#Please change the inputs accordingly. 
c = open_mtx(comport ='COM4' , baud = 9600 , timeout = 5, byte_delay = 0.002)
c = c.mtx_mul(A,B)

# checking the answer of the FPGA w.r.t to numpy answer. 
A_np = np.array(A)
B_np = np.array(B)
C_np = np.array(c)


print(f'Matrix A : {A_np} \n')
print(f'Matrix B : {B_np} \n')
print(f'Matrix C : {c} \n')
print(f'ANSWER VERIFICATION : {C_np == np.matmul(A_np, B_np)}')  

