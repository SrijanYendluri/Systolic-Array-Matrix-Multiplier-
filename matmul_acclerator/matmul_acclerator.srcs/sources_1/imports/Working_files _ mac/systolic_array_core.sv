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
