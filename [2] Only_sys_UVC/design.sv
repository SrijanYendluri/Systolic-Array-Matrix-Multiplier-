interface sc_if;

  logic clk;
  logic st_rst;
  logic [31:0] A [0:3];
  logic [31:0] B [0:3];
  logic [15:0] C [0:3][0:3];
  logic completed;
  
//   modport tb_dut (input clk, st_rst, A,B, output C, completed);
  
endinterface


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
    			 .a_or_b(1'b0),
                 .done(done_a),
                 .arr_out(A_out)
               );


  data_aligner row_feeder(
                 .arr_in(B),
                 .clk(clk),
                 .st_rst(st_rst_rf_cf),
    			 .a_or_b(1'b1),
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
          //$display("The if statment got triggred %d, %d, %d, the statement ouptus : %d", done_a, done_b, count, done_a && done_b && count);
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


module systolic_array_core (
    input logic clk,
    input logic rst,
    input logic [31:0] B, A,
    output logic [15:0] C [0:3][0:3]
  );

  logic [7:0] right [0:11];
  logic [7:0] down [0:11];
  wire [7:0]gnd = '0;


  mac_cell ins11 (
             .clk(clk),
             .rst(rst),
             .datain_a(A[31:24]),
             .datain_b(B[31:24]),
             .datanext_right(right[0]), //output
             .datanext_down(down[0]), //output
             .data_mac(C[0][0])
           );

  mac_cell ins12 (
             .clk(clk),
             .rst(rst),
             .datain_a(right[0]),
             .datain_b(B[23:16]),
             .datanext_right(right[1]), //output
             .datanext_down(down[3]), //output
             .data_mac(C[0][1])
           );

  mac_cell ins13 (
             .clk(clk),
             .rst(rst),
             .datain_a(right[1]),
             .datain_b(B[15:8]),
             .datanext_right(right[2]), //output
             .datanext_down(down[6]), //output
             .data_mac(C[0][2])
           );


  mac_cell ins14 (
             .clk(clk),
             .rst(rst),
             .datain_a(right[2]),
             .datain_b(B[7:0]),
             .datanext_right(gnd ), //output
             .datanext_down(down[9]), //output
             .data_mac(C[0][3])
           );

  mac_cell ins21 (
             .clk(clk),
             .rst(rst),
             .datain_a(A[23:16]),
             .datain_b(down[0]),
             .datanext_right(right[3]), //output
             .datanext_down(down[1]), //output
             .data_mac(C[1][0])
           );

  mac_cell ins22 (
             .clk(clk),
             .rst(rst),
             .datain_a(right[3]),
             .datain_b(down[3]),
             .datanext_right(right[4]), //output
             .datanext_down(down[4]), //output
             .data_mac(C[1][1])
           );

  mac_cell ins23 (
             .clk(clk),
             .rst(rst),
             .datain_a(right[4]),
             .datain_b(down[6]),
             .datanext_right(right[5]), //output
             .datanext_down(down[7]), //output
             .data_mac(C[1][2])
           );


  mac_cell ins24 (
             .clk(clk),
             .rst(rst),
             .datain_a(right[5]),
             .datain_b(down[9]),
             .datanext_right(gnd ), //output
             .datanext_down(down[10]), //output
             .data_mac(C[1][3])
           );

  mac_cell ins31 (
             .clk(clk),
             .rst(rst),
             .datain_a(A[15:8]),
             .datain_b(down[1]),
             .datanext_right(right[6]), //output
             .datanext_down(down[2]), //output
             .data_mac(C[2][0])
           );

  mac_cell ins32 (
             .clk(clk),
             .rst(rst),
             .datain_a(right[6]),
             .datain_b(down[4]),
             .datanext_right(right[7]), //output
             .datanext_down(down[5]), //output
             .data_mac(C[2][1])
           );

  mac_cell ins33 (
             .clk(clk),
             .rst(rst),
             .datain_a(right[7]),
             .datain_b(down[7]),
             .datanext_right(right[8]), //output
             .datanext_down(down[8]), //output
             .data_mac(C[2][2])
           );


  mac_cell ins34 (
             .clk(clk),
             .rst(rst),
             .datain_a(right[8]),
             .datain_b(down[10]),
             .datanext_right(gnd ), //output
             .datanext_down(down[11]), //output
             .data_mac(C[2][3])
           );


  mac_cell ins41 (
             .clk(clk),
             .rst(rst),
             .datain_a(A[7:0]),
             .datain_b(down[2]),
             .datanext_right(right[9]), //output
             .datanext_down(gnd ), //output
             .data_mac(C[3][0])
           );

  mac_cell ins42 (
             .clk(clk),
             .rst(rst),
             .datain_a(right[9]),
             .datain_b(down[5]),
             .datanext_right(right[10]), //output
             .datanext_down(gnd ), //output
             .data_mac(C[3][1])
           );

  mac_cell ins43 (
             .clk(clk),
             .rst(rst),
             .datain_a(right[10]),
             .datain_b(down[8]),
             .datanext_right(right[11]), //output
             .datanext_down(gnd ), //output
             .data_mac(C[3][2])
           );


  mac_cell ins44 (
             .clk(clk),
             .rst(rst),
             .datain_a(right[11]),
             .datain_b(down[11]),
             .datanext_right(gnd ), //output
             .datanext_down(gnd ), //output
             .data_mac(C[3][3])
           );



endmodule

module mac_cell(
    input logic clk,
    input logic rst,
    input logic [7:0] datain_a, datain_b,
    output logic [7:0] datanext_right, datanext_down,
    output logic [15:0] data_mac
  );

  logic [15:0] acc_memory = '0;
  logic [7:0] passdata_a = '0, passdata_b = '0;

  logic [7:0] next_right, next_down;
  logic [15:0] result;

  always_ff @(posedge clk)
  begin
    if (rst)
    begin
      passdata_a <= '0;
      passdata_b <= '0;
      acc_memory <= '0;
    end
    else
    begin
      passdata_a <= datain_a;
      passdata_b <= datain_b;
      acc_memory <= acc_memory + (datain_a * datain_b);
    end
  end

  assign datanext_right = passdata_a;
  assign datanext_down  = passdata_b;
  assign data_mac       = acc_memory;

endmodule


module data_aligner(
    input  logic [31:0] arr_in[0:3],
    input  logic clk, st_rst,
    input  logic a_or_b, ///0 _> a and 1->b
    output logic [31:0] arr_out,
    output logic done
  );


  logic [2:0] count= 0;
  logic [31:0] temp_internal_arr_in [0:6];
  logic store_done;
  enum {idle, store, send, stop} state, next_state;





  always_ff @(posedge clk)
  begin
    if(st_rst)
    begin
      state <= idle;
      count <= 6;
      store_done <= 0;
      // done <= '0;
      // arr_out <= '0;
      temp_internal_arr_in[0] <= 1'b0;
      temp_internal_arr_in[1] <= 1'b0;
      temp_internal_arr_in[2] <= 1'b0;
      temp_internal_arr_in[3] <= 1'b0;
      temp_internal_arr_in[4] <= 1'b0;
      temp_internal_arr_in[5] <= 1'b0;
      temp_internal_arr_in[6] <= 1'b0;

    end
    else
    begin
      state <= next_state;

      case(state)

        idle :
        begin
          temp_internal_arr_in[0] <= 1'b0;
          temp_internal_arr_in[1] <= 1'b0;
          temp_internal_arr_in[2] <= 1'b0;
          temp_internal_arr_in[3] <= 1'b0;
          temp_internal_arr_in[4] <= 1'b0;
          temp_internal_arr_in[5] <= 1'b0;
          temp_internal_arr_in[6] <= 1'b0;
          // done <= '0;
          // state <= store;
        end

        store :

        begin
          case (a_or_b)
            1'b1:
            begin
              temp_internal_arr_in[0] <= {8'd0, 8'd0, 8'd0, arr_in[0][7:0]};
              temp_internal_arr_in[1] <= {8'd0,8'd0, arr_in[0][15:8], arr_in[1][7:0]};
              temp_internal_arr_in[2] <= {8'd0, arr_in[0][23:16], arr_in[1][15:8], arr_in[2][7:0]};
              temp_internal_arr_in[3] <= {arr_in[0][31:24], arr_in[1][23:16], arr_in[2][15:8], arr_in[3][7:0]};
              temp_internal_arr_in[4] <= {arr_in[1][31:24], arr_in[2][23:16], arr_in[3][15:8], 8'd0 };
              temp_internal_arr_in[5] <= {arr_in[2][31:24], arr_in[3][23:16], 8'd0,8'd0};
              temp_internal_arr_in[6] <= {arr_in[3][31:24], 8'd0, 8'd0,8'd0};
            end

            1'b0 :
            begin
              temp_internal_arr_in[0] = {8'd0, 8'd0, 8'd0, arr_in[3][31:24]};
              temp_internal_arr_in[1] = {8'd0,8'd0, arr_in[2][31:24], arr_in[3][23:16]};
              temp_internal_arr_in[2] = {8'd0, arr_in[1][31:24], arr_in[2][23:16], arr_in[3][15:8]};
              temp_internal_arr_in[3] = {arr_in[0][31:24], arr_in[1][23:16], arr_in[2][15:8], arr_in[3][7:0]};
              temp_internal_arr_in[4] = {arr_in[0][23:16], arr_in[1][15:8], arr_in[2][7:0], 8'd0 };
              temp_internal_arr_in[5] = {arr_in[0][15:8], arr_in[1][7:0], 8'd0,8'd0};
              temp_internal_arr_in[6] = {arr_in[0][7:0], 8'd0, 8'd0,8'd0};
            end
          endcase
          // state <= send;
          store_done <= 1;

        end

        send :
        begin
          // if (count == 7)state <= stop;
          // else begin
          // arr_out <= temp_internal_arr_in[count];
          count <= count  - 1;
          // end

        end

        stop :
        begin
          // done <= 1;
          temp_internal_arr_in[0] <= 1'b0;
          temp_internal_arr_in[1] <= 1'b0;
          temp_internal_arr_in[2] <= 1'b0;
          temp_internal_arr_in[3] <= 1'b0;
          temp_internal_arr_in[4] <= 1'b0;
          temp_internal_arr_in[5] <= 1'b0;
          temp_internal_arr_in[6] <= 1'b0;
          // arr_out <= '0;

        end

        default :
        begin
          state <= idle;
        end
      endcase
    end
  end




  always_comb
  begin
    // Default assignments to prevent latches
    next_state = idle;
    arr_out = '0;
    done = 0;

    case (state)
      idle:
      begin
        next_state = store;
        arr_out = '0;
        done = 0;
      end

      store:
      begin
        if(store_done ==1)
        begin
          next_state = send;
          arr_out = '0;
          done = 0;
        end
        else
        begin
          next_state = store;
          arr_out = '0;
          done = 0;
        end
      end

      send:
      begin
        if (count == 7)
        begin
          next_state = stop;
          arr_out = '0;
          done = 0;
        end
        else
        begin
          next_state = send;
          arr_out = temp_internal_arr_in[count];
          done = 0;
        end
        // next_state already defaults to state
      end

      stop:
      begin
        next_state = stop;
        arr_out = '0;
        done = 1;
      end

      default:
      begin
        next_state = idle;
        arr_out = '0;
        done = 0;
      end
    endcase
  end

  //  logic [15:0] state_count;
  // always_ff @(posedge clk)
  // begin
  //   if(rst)
  //     state_count <= '0;
  //   else
  //   begin
  //     if(next_state != state)
  //       state_count <= '0;
  //     else
  //       state_count <= state_count + 1;
  //   end
  // end
endmodule