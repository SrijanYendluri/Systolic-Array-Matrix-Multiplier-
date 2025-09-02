`define a 0
`define b 1

module systolic_controller(
    input logic clk, st_rst,
    input logic [31:0] A [0:3],
    input logic [31:0] B [0:3],
    output logic completed,
    output logic [15:0] C [0:3][0:3]
  );


  logic [31:0] A_out, B_out; // A_out_cl, B_out_cl;
  //   logic [31:0] A[0:3], B[0:3];
  logic [15:0] C_to_cl [0:3][0:3];
  //logic [15:0] cl_to_C [0:3][0:3];
  enum logic [7:0] {idle, compute, store, fin} state, mac_next_state;
  logic [4:0] count = 0;
  logic st_rst_rf_cf;
  logic done_a, done_b, done_store;

  // assign A[0] = {8'd1, 8'd2, 8'd3, 8'd4};
  // assign A[1] = {8'd5, 8'd6, 8'd7, 8'd8};
  // assign A[2] = {8'd9, 8'd10, 8'd11, 8'd12};
  // assign A[3] = {8'd13, 8'd14, 8'd15, 8'd16};

  // assign B[0] = {8'd17, 8'd18, 8'd19, 8'd20};
  // assign B[1] = {8'd21, 8'd22, 8'd23, 8'd24};
  // assign B[2] = {8'd25, 8'd26, 8'd27, 8'd28};
  // assign B[3] = {8'd29, 8'd30, 8'd31, 8'd32};

  data_aligner col_feeder(
                 .arr_in(A),
                 .clk(clk),
                 .st_rst(st_rst_rf_cf),
                 .a_or_b(0),
                 .done(done_a),
                 .arr_out(A_out)
               );


  data_aligner row_feeder(
                 .arr_in(B),
                 .clk(clk),
                 .st_rst(st_rst_rf_cf),
                 .a_or_b(1),
                 .done(done_b),
                 .arr_out(B_out)
               );

  systolic_array_core sys_arrays (
                        .clk(clk),
                        .rst(st_rst),
                        .B(B_out),
                        .A(A_out),
                        .C(C_to_cl)
                      );

  ///////////////////////////////////////////////////
  always_comb
  begin
    mac_next_state = idle;
    completed = 0;
    st_rst_rf_cf = 1;


    case (state)
      idle :
      begin
        if(st_rst == 0)
        begin
          mac_next_state = compute;
          st_rst_rf_cf = 0;
        end
        else
        begin
          mac_next_state =idle;
        end
      end

      compute :
      begin
        if (done_a && done_b && count > 10)
        begin
          $display("The if statment got triggred %d, %d, %d, the statement ouptus : %d", done_a, done_b, count, done_a && done_b && count);
          st_rst_rf_cf = 1;
          mac_next_state = store;
        end
        else
        begin
          st_rst_rf_cf = 0;
          mac_next_state = compute;
        end
      end

      store :
      begin
        if(done_store)
          mac_next_state = fin;
        else
          mac_next_state = store;
      end


      fin :
      begin
        mac_next_state = fin;
        completed = 1;
      end
      default :
      begin
        mac_next_state = idle;
        completed = 0;
        st_rst_rf_cf = 0;
      end

    endcase
  end
  ////////////////////////////////////////////////////////

  always_ff @(posedge clk)
  begin
    if(st_rst)
    begin
      state <= idle;
      done_store <= 0;
      count <= 0;
      C[0][0] <= '0;
      C[0][1] <= '0;
      C[0][2] <= '0;
      C[0][3] <= '0;
      C[1][0] <= '0;
      C[1][1] <= '0;
      C[1][2] <= '0;
      C[1][3] <= '0;
      C[2][0] <= '0;
      C[2][1] <= '0;
      C[2][2] <= '0;
      C[2][3] <= '0;
      C[3][0] <= '0;
      C[3][1] <= '0;
      C[3][2] <= '0;
      C[3][3] <= '0;

    end
    else
    begin
      state <= mac_next_state;

      case (state)
        idle :
        begin


        end

        store :
        begin
          C <= C_to_cl;
          done_store <= 1;
       
        end

        compute :
          count <= 1 + count;

        //    default : state <= idle;

      endcase
    end




  end





endmodule
