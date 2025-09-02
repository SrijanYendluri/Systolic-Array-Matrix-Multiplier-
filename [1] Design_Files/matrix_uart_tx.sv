`define baud 10416
module matrix_uart_tx (
    input logic clk, rst, data_valid,
    output logic tx, done,
    input logic [15:0] C [0:3][0:3]

  );

  logic [15:0] bucket [0:31];
  logic [6:0] bucket_numb;
  logic [4:0] bit_frm_bucket;
  logic [16:0] data_hold;

  enum {idle, start, data, stop} state;
  int i;

  always_ff @ (posedge clk)
  begin
    if(rst)
      state <= idle;

    case(state)
      idle :
      begin
        for(i = 0; i < 32; i++)
          bucket[i] <= '0;
        bucket_numb <= '0;
        bit_frm_bucket <= '0;
        data_hold <= '0;
        done <= 0;
        tx = 1;

        if (data_valid && done != 1)
        begin
          bucket[0] <= C[0][0][7:0];
          bucket[1] <= C[0][0][15:8];
          // C[0][1]< split into two bytes
          bucket[2] <= C[0][1][7:0];
          bucket[3] <= C[0][1][15:8];
          // C[0][2]< split into two bytes
          bucket[4] <= C[0][2][7:0];
          bucket[5] <= C[0][2][15:8];
          // C[0][3]< split into two bytes
          bucket[6] <= C[0][3][7:0];
          bucket[7] <= C[0][3][15:8];
          // C[1][0]< split into two bytes
          bucket[8] <= C[1][0][7:0];
          bucket[9] <= C[1][0][15:8];
          // C[1][1] <split into two bytes
          bucket[10] <= C[1][1][7:0];
          bucket[11] <= C[1][1][15:8];
          // C[1][2] <split into two bytes
          bucket[12] <= C[1][2][7:0];
          bucket[13] <= C[1][2][15:8];
          // C[1][3] <split into two bytes
          bucket[14] <= C[1][3][7:0];
          bucket[15] <= C[1][3][15:8];
          // C[2][0] <split into two bytes
          bucket[16] <= C[2][0][7:0];
          bucket[17] <= C[2][0][15:8];
          // C[2][1] <split into two bytes
          bucket[18] <= C[2][1][7:0];
          bucket[19] <= C[2][1][15:8];
          // C[2][2] <split into two bytes
          bucket[20] <= C[2][2][7:0];
          bucket[21] <= C[2][2][15:8];
          // C[2][3] <split into two bytes
          bucket[22] <= C[2][3][7:0];
          bucket[23] <= C[2][3][15:8];
          // C[3][0] <split into two bytes
          bucket[24] <= C[3][0][7:0];
          bucket[25] <= C[3][0][15:8];
          // C[3][1] <split into two bytes
          bucket[26] <= C[3][1][7:0];
          bucket[27] <= C[3][1][15:8];
          // C[3][2] <split into two bytes
          bucket[28] <= C[3][2][7:0];
          bucket[29] <= C[3][2][15:8];
          // C[3][3] <split into two bytes
          bucket[30] <= C[3][3][7:0];
          bucket[31] <= C[3][3][15:8];
          state <= start;
        end
        else
          state <= idle;
      end // Idle state end
      //////////////////////////////////////////////////
      start :
      begin
        tx = 0;
        if (data_hold == `baud)
        begin
          state <= data;
          data_hold <= 0;
        end
        else
          data_hold <= data_hold + 1;
      end // start state end

      data :
      begin
        tx = bucket[bucket_numb][bit_frm_bucket];
        data_hold <= data_hold + 1;
        if (bit_frm_bucket == 8)
        begin
          data_hold <= '0;
          state <= stop;
        end
        else
        begin
          if(data_hold == `baud)
          begin
            data_hold <= 0;
            bit_frm_bucket <= bit_frm_bucket + 1;
          end
          else
          begin

          end

        end
      end // data state end

      stop :
      begin
        tx = 1;

        data_hold <= data_hold + 1;
        if (data_hold == `baud)
        begin
          if(bucket_numb == 31)
          begin
            data_hold <= 0;
            state <= idle;
            done <= 1;
          end
          else
          begin

            data_hold <= 0;
            state <= start;
            bucket_numb <= bucket_numb + 1;
            bit_frm_bucket <= 0;
          end
        end
      end // stop state

    endcase


  end // always @  end
endmodule
