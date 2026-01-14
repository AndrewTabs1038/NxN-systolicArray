import numpy as np
def genMatrixOutput(min, max, N):
    # C = A * B
    A = np.random.randint(min,max, size=(N,N))
    B = np.random.randint(min,max, size=(N,N))

    C = np.matmul(A,B)
    print(A)
    print(B)
    print(C)

    B = B.T #Systolic Array expectes B in coloumn major order


    Afile = open("A.mem", "w")
    Bfile = open("B.mem", "w")
    Cfile = open("C.mem", "w")
    for i in range(N):
        a = ""
        b = ""
        c = ""
        for j in range(N):
            a = a + hex(A[i][j])[2:] + "\n" 
            b = b + hex(B[i][j])[2:] + "\n" 
            c = c + hex(C[i][j])[2:] + "\n"

            Afile.write(a)
            Bfile.write(b)
            Cfile.write(c)

            a = ""
            b = ""
            c = ""       
    print("Test Vectors Generated")   
    return C
    


if __name__ == "__main__":
    genMatrixOutput(0,100,32)