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
