import time
import struct
import numpy as np
import serial
from random import randint

class matrix_mul_tb:
    def __init__(self, number_of_test, comport ='COM4' , baud = 9600 , timeout = 5, byte_delay = 0.00, tb_dut = 1):
        self.number_of_test = number_of_test
        self.baud = baud
        self.comport = comport
        self.timeout = timeout
        self.byte_delay = byte_delay
        self.tb_dut = tb_dut
        self.mbx_drv_scb_ans  = 0
        self.mbx_drv_scb_mtx =  0
        self.passed = 0
        self.failed = 0
     
    def matrix_builder(self, mtx_size = 16, bit_size = 8):
        l = []
        if self.tb_dut == 1:
            l = []
            for i in range(1,mtx_size+1):
                l.append(i)
            return l
        else:
            l = []
            for i in range(0,mtx_size):
                l.append(randint(0,(2**(bit_size-1))))
            return l

    def transaction(self):

        matrix_A = self.matrix_builder(16,8)
        matrix_B = self.matrix_builder(16,8)
        if len(matrix_A) != 16 or len(matrix_B) != 16:
            print("[DRV] The matrixes are not of the right size")
        else:
            payload = bytes(matrix_A + matrix_B)
            print(f'[TRN] Matrix Gegnerated A: {matrix_A}')
            print(f'[TRN] Matrix Gegnerated B: {matrix_B}')
            print(f'[TRN] Payload: {payload}')
            self.mbx_drv_scb_mtx = [matrix_A, matrix_B]
            return payload

    def sequence(self):
        pass

    def driver(self):
        payload = self.transaction()
       
            
    
        ser = serial.Serial(self.comport, self.baud, timeout=1)
        time.sleep(0.1)
        print('[DRV] Driving Data') 

        for bit in payload:
            ser.write(bytes([bit]))
            # print(f'[DRV] Bytes writen to FPGA :  {bit}')
            time.sleep(self.byte_delay)

        
        print('[DRV] Done Driving Data') 

        buffer = bytearray()
        start = time.time()

        while time.time() - start < self.timeout:
            if ser.in_waiting:
                buffer.extend(ser.read(ser.in_waiting))
            if len(buffer) >= 32:
                break
            time.sleep(0.01)
        ser.close()

        return buffer

       
   
    
    def monitor(self):
        

        if len(self.mbx_drv_scb_ans) < 32:
            print(f"[MON] Timeout or incomplete response: received {len(self.mbx_drv_scb_ans)} of 32 bytes.")
            print(f"[MON] Raw received bytes (hex):", " ".join(f"{b:02X}" for b in self.mbx_drv_scb_ans))
            return None
        else:
            print(f"[MON] Raw received bytes (hex):", " ".join(f"{b:02X}" for b in self.mbx_drv_scb_ans))
            print(f"[MON] :", list(struct.unpack('<16H', self.mbx_drv_scb_ans[:32])))
        pass

    def scoreboard(self):
        
        try: 
            main_mtx  = self.mbx_drv_scb_mtx
            print(f'[SCB] Mat A : {main_mtx[0]}')
            print(f'[SCB] Mat B : {main_mtx[1]}')
            MAT_A = np.array(main_mtx[0]).reshape(4,4)
            MAT_B = np.array(main_mtx[1]).reshape(4,4)
            MAT_C = list(struct.unpack('<16H', self.mbx_drv_scb_ans[:32]))
            print(f'[SCB] Mat C : {MAT_C}')
            MAT_C = np.array(MAT_C).reshape(4,4)
            EXPECTED_C = np.matmul(MAT_A, MAT_B)

            if np.array_equal(EXPECTED_C, MAT_C):
                passed = 1
                failed = 0
                print(f'[SCB] Test case passed')
                return passed, failed

            else:
                failed = 1
                passed = 0
                print(f'[SCB] Testcase failed \n')
                print(f'[SCB] Received : \n{MAT_C}')
                print(f'[SCB] Expected : \n{EXPECTED_C}')
                print(f'[SCB] Locations : \n{EXPECTED_C == MAT_C}')
                return passed, failed

           
        except: 
            print("[SCB] No data recieved, Device is off or rst is enabled")
            print("[SCB] TB closed") 
            return 0,1


    def agent (self):
        buffer = self.driver()
        self.mbx_drv_scb_ans = buffer
        self.monitor()
 

    def env(self):
        self.agent()
        passed, failed = self.scoreboard()
      
        return passed, failed

    def top (self):
        test_case  = 0
        t_passed = 0
        t_failed = 0
        for i in range(0,self.number_of_test):
            print(f'============================TEST CASE : {test_case}=================================')
            tb = matrix_mul_tb(1, self.comport, self.baud, self.timeout, 0.002, self.tb_dut)
            p, f = tb.env()
            test_case += 1
            t_passed += p
            t_failed += f
            time.sleep(1) # MADE SLOW FOR SIMULATION can be commented out.
            print(f'====================================================================================')
        pass
        print(f'[TOP] Number of test Cases : {test_case}')
        print(f'[TOP] Number of FAIL       : {t_failed}')
        print(f'[TOP] Number of PASS       : {t_passed}')
        print(f'\n')
        print(f'\n')
        print(f'\n')

        print(f'\n')
        print(f'\n')
        print(f'\n')
        print(f'\n')
        print(f'\n')

        print(f'\n')


tb1 = matrix_mul_tb(10, 'COM4', 9600, 5, 0.002, 0)
tb1.top()