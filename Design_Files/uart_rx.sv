module uart_rx (
    input  logic clk,
    input  logic rst,
    input  logic rx,
    output logic [7:0] data,
    output logic valid
  );


  localparam BAUD_PERIOD = 10416;
  localparam BAUD_COUNT_WIDTH = $clog2(BAUD_PERIOD);

  typedef enum {IDLE, START, DATA, STOP} state_t;
  state_t state;

  logic [BAUD_COUNT_WIDTH-1:0] counter;
  logic [2:0] bit_count;
  logic [7:0] shift_reg;

  always_ff @(posedge clk)
  begin
    if (rst)
    begin
      state <= IDLE;
      valid <= 0;
      counter <= 0;
      bit_count <= 0;
      data <= 0;
    end
    else
    begin
      valid <= 0;

      case (state)
        IDLE:
        begin

          if (!rx)
          begin  // Start bit detection
            state <= START;
            counter <= BAUD_PERIOD / 2 - 1;  // Sample at midpoint
          end else begin 
            valid <= 0;
            counter <= 0;
            bit_count <= 0;
            data <= 0;  
            shift_reg <= 0;
            end
        end

        START:
        begin
          if (counter == 0)
          begin
            if (!rx)
            begin  // Confirm valid start bit
              state <= DATA;
              counter <= BAUD_PERIOD - 1;
              bit_count <= 0;
            
            end
            else
            begin
              state <= IDLE;
            end
          end
          else
          begin
            counter <= counter - 1;
          end
        end

        DATA:
        begin
          if (counter == 0)
          begin
            shift_reg[bit_count] <= rx;  // LSB first
            counter <= BAUD_PERIOD - 1;

            if (bit_count == 7)
            begin
              state <= STOP;
            end
            else
            begin
              bit_count <= bit_count + 1;
            end
          end
          else
          begin
            counter <= counter - 1;
          end
        end

        STOP:
        begin
          if (counter == 0)
          begin
            data <= shift_reg;
            valid <= 1;
            state <= IDLE;
          end
          else
          begin
            counter <= counter - 1;
          end
        end
      endcase
    end
  end
endmodule
