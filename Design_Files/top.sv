//// this is the one 
module top (
    input  logic clk,
    input  logic rst,
    input  logic rx,
    output logic tx,
    output logic [5:0] state_led
);

    // Control Signals
    logic [1:0]  load_sel;
    logic        load_start;
    logic        load_done_a, load_done_b;
    logic        mac_start;
    logic        mac_done;
    logic        tx_start;
    logic        tx_done;
    logic rst_mem;
    logic rst_rx;
    // Data Pat
    logic [7:0]  uart_rx_data;
    logic        uart_rx_valid;
    logic [31:0] mem_a [0:3];
    logic [31:0] mem_b [0:3];
    logic [15:0] mac_result [0:3][0:3];
    

    uart_rx receiver (
        .clk(clk),
        .rst(rst),
        .rx(rx),
        .data(uart_rx_data),
        .valid(uart_rx_valid)
    );
    
    // Memory Loader Controller
    mem_loader loader (
        .clk(clk),
        .rst(rst || rst_mem),
        .data_in(uart_rx_data),
        .data_valid(uart_rx_valid),
        .load_sel(load_sel),
        .load_start(load_start),
        .load_done_a(load_done_a),
        .load_done_b(load_done_b),
        .mem_a(mem_a),
        .mem_b(mem_b)
    );
    
    // MAC Processing Unit
    systolic_controller processor (
        .clk(clk),
        .st_rst(rst || ~mac_start),
        .A(mem_a),
        .B(mem_b),
        .completed(mac_done),
        .C(mac_result)
    );
    
    // UART Transmitter (115200 baud @ 125MHz)
    matrix_uart_tx transmitter (
        .clk(clk),
        .rst(rst),
        .data_valid(tx_start),
        .C(mac_result),
        .tx(tx),
        .done(tx_done)
    );
    
    // Main State Machine
    main_controller controller (
        .clk(clk),
        .rst(rst),
        .rx(rx),
        .load_done_a(load_done_a),
        .load_done_b(load_done_b),
        .mac_done(mac_done),
        .tx_done(tx_done),
        .load_sel(load_sel),
        .load_start(load_start),
        .mac_start(mac_start),
        .tx_start(tx_start),
        .state_led(state_led),
        .rst_mem(rst_mem)
            );

endmodule


module main_controller (
    input  logic clk,
    input  logic rst,
    input  logic load_done_a, load_done_b,
    input  logic mac_done,
    input  logic tx_done,
    input  logic rx,
    output logic [1:0] load_sel,
    output logic load_start,
    output logic mac_start,
    output logic tx_start,
    output logic [5:0] state_led,
    output logic rst_mem,
    output logic rst_rx
);

   enum {
        INIT,
        IDLE,
        LOAD_A,
        LOAD_B,
        PROCESS,
        TRANSMIT,
        COMPLETE
    }  current_state, next_state;
    
    // State register
    always_ff @(posedge clk) begin
        if (rst) current_state <= INIT;
        else current_state <= next_state;
    end
    
    // State transitions
    always_comb begin
        next_state = current_state;
        
        case (current_state)
            INIT: next_state = IDLE;

            
            IDLE: 
                if (load_start || ~rx) begin              
                    next_state = LOAD_A;
                end
                
            LOAD_A:
                if (load_done_a)begin  
              
                next_state = LOAD_B;
                end
                
            LOAD_B:
                if (load_done_b) next_state = PROCESS;
                
            PROCESS:
                if (mac_done) next_state = TRANSMIT;
                
            TRANSMIT:
                if (tx_done) next_state = COMPLETE;
                
            COMPLETE:
                next_state = INIT;
        endcase
    end
    
    // Output logic
    always_comb begin
        // Default outputs
        load_sel = 2'b00;
        load_start = 0;
        mac_start = 0;
        tx_start = 0;
        state_led = 6'b000001;
        rst_mem = 0;
        rst_rx = 0;
        
        case (current_state)
        
            INIT : begin 
                rst_mem = 1;
                 rst_rx = 1;
            end
        
            IDLE: begin
                state_led = 6'b000001;
                load_start = 0;
                 rst_rx = 0;
            end
            
            LOAD_A: begin
                state_led = 6'b000010;
                load_sel = 2'b01;
                load_start = 1;
                 rst_rx = 0;
            end
            
            LOAD_B: begin
                state_led = 6'b000100;
                load_sel = 2'b10;
                load_start = 1;
                 rst_rx = 0;
            end
            
            PROCESS: begin
                load_sel = 2'b00;
                state_led = 6'b001000;
                mac_start = 1;
                 rst_rx = 0;
            end
            
            TRANSMIT: begin
                state_led = 6'b010000;
                tx_start = 1;
                 rst_rx = 0;
            end
            
            COMPLETE: begin
                state_led = 6'b100000;
                rst_rx = 1;
                
            end
        endcase
    end
endmodule