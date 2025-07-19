
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

// module inparngA(
//     input bit [31:0] A [0:3],
//     input  logic clk,rst,stop,
//     output logic [31:0] A_out
//   );


//   logic [2:0] count= 0;
//   logic [31:0] a [0:6];
//   enum logic [1:0] {Idle, send, fin} state, next_state;

//   assign temp_internal_arr_in[0] = {8'd0, 8'd0, 8'd0, A[3][31:24]};
//   assign a[1] = {8'd0,8'd0, A[2][31:24], A[3][23:16]};
//   assign a[2] = {8'd0, A[1][31:24], A[2][23:16], A[3][15:8]};
//   assign a[3] = {A[0][31:24], A[1][23:16], A[2][15:8], A[3][7:0]};
//   assign a[4] = {A[0][23:16], A[1][15:8], A[2][7:0], 8'd0 };
//   assign a[5] = {A[0][15:8], A[1][7:0], 8'd0,8'd0};
//   assign a[6] = {A[0][7:0], 8'd0, 8'd0,8'd0};

//   always @(posedge clk)
//   begin
//     if (rst)
//     begin
//       state <= Idle;
//     end
//     else
//     begin
//       next_state <= state;
//       case (state)

//         Idle :
//         begin
//           count <= 6;
//           if (stop == 1)
//             state <= Idle;
//           else
//             state <= send;
//         end


//         send :
//         begin

//           if (count != 0)
//           begin
//             count <= count - 1;
//           end
//           else
//           begin
//             state <= fin;
//           end
//         end



//         fin :
//         begin

//           if (stop == 1)
//             state <= Idle;
//           else
//             state <= fin;
//         end

//       endcase
//     end
//   end


//   always @(*)
//   begin

//     case (state)

//       Idle:
//         A_out = {8'd0, 8'd0, 8'd0, 8'd0} ;
//       send:
//         A_out = a[count];
//       fin:
//         A_out = {8'd0, 8'd0, 8'd0, 8'd0};

//     endcase
//   end


// endmodule






