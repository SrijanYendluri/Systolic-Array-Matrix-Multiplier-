import struct
import serial
import time
from random import randint
import numpy as np


class open_mtx ():
    def __init__(self, comport ='COM4' , baud = 9600 , timeout = 5, byte_delay = 0.002):
        
        self.baud = baud
        self.comport = comport
        self.timeout = timeout
        self.byte_delay = byte_delay

    
    def flatten(self, matrix):
            try :
                return [val for row in matrix for val in row]
            except:
                return matrix


    def mtx_mul (self, matrix_a, matrix_b):

        matrix_a = self.flatten(matrix_a)
        matrix_b = self.flatten(matrix_b)
    
        if any(not (0 <= v <= 2**(8-1)) for v in matrix_a + matrix_b):
             raise ValueError("Values in matrix Overflowing")
        else: 
            if len(matrix_a) != 16 or len(matrix_b) != 16:
                pass
                # Future Update add code to perform tiling divide and conquor technique to solve it 
            else : 
                payload = bytes(matrix_a + matrix_b)
                # print("bytes written(hex)", " ".join(f"{b:02X}" for b in payload), "\n")
                
                ser = serial.Serial(self.comport, self.baud, timeout=1)
                # time.sleep(0.1) 

                for b in payload:
                    ser.write(bytes([b]))
                    time.sleep(self.byte_delay)


                ser.timeout = 0.1
                buffer = bytearray()
                start = time.time()
                expected_bytes = 32
                while len(buffer) < expected_bytes:
                            if ser.in_waiting:
                                buffer.extend(ser.read(ser.in_waiting))
                            else:
                                time.sleep(0.005) 

                            if time.time() - start > self.timeout:
                                break

                if len(buffer) >= expected_bytes:
                    # print("Raw received bytes (hex):")
                    # print("  ", " ".join(f"{b:02X}" for b in buffer[:expected_bytes]))
                    result_values = list(struct.unpack('<16H', buffer[:32]))
                    result_matrix = [result_values[i:i+4] for i in range(0, 16, 4)]
                else:
                    # print(f"Timeout or incomplete response: received {len(buffer)} of 32 bytes.")
                    # print("Raw received bytes (hex):", " ".join(f"{b:02X}" for b in buffer))
                    result_matrix = None

                ser.close()

                return result_matrix






        

