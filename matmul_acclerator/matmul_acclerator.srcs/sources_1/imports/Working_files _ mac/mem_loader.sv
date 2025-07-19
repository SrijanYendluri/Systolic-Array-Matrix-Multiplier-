module mem_loader (
    input  logic clk,
    input  logic rst,
    input  logic [7:0] data_in,
    input  logic data_valid,
    input  logic [1:0] load_sel,  // 00=idle, 01=load A, 10=load B
    input  logic load_start,
    output logic load_done_a,
    output logic load_done_b,
    output logic [31:0] mem_a [0:3],
    output logic [31:0] mem_b [0:3]
);

    logic [3:0] byte_count;
    logic [1:0] word_sel;
    
    always_ff @(posedge clk) begin
        if (rst || !load_start) begin
            byte_count <= 0;
            load_done_a <= 0;
            load_done_b <= 0;
            word_sel <= 0;
        end else if (load_start && data_valid && load_sel != 2'b00) begin
            case (load_sel)
                2'b01: begin  // Loading A
                    case (byte_count[1:0])
                        2'b00: mem_a[word_sel][31:24] <= data_in;
                        2'b01: mem_a[word_sel][23:16] <= data_in;
                        2'b10: mem_a[word_sel][15:8] <= data_in;
                        2'b11: mem_a[word_sel][7:0] <= data_in;
                    endcase
                end
                
                2'b10: begin  // Loading B
                    case (byte_count[1:0])
                        2'b00: mem_b[word_sel][31:24] <= data_in;
                        2'b01: mem_b[word_sel][23:16] <= data_in;
                        2'b10: mem_b[word_sel][15:8] <= data_in;
                        2'b11: mem_b[word_sel][7:0] <= data_in;
                    endcase
                end
            endcase
            
            // Update counters
            if (byte_count[1:0] == 2'b11) begin
                if (word_sel == 2'b11 && load_sel == 2'b01 ) begin
                    load_done_a <= 1;
                    word_sel <= 0;
                    byte_count <= 0;
                end else if (word_sel == 2'b11 && load_sel == 2'b10 ) begin
                    load_done_b <= 1;
                    word_sel <= 0;
                    byte_count <= 0;
                end else begin
                    word_sel <= word_sel + 1;
                end
            end
            
            byte_count <= byte_count + 1;
        end
    end
endmodule