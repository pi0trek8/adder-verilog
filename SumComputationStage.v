module SumComputationStage(
  input wire [6:0] half_sum_vector,
  input wire [6:0] h_prim,
  input wire [6:0] carry_generate_vector,
  input wire [6:0] g_prim,
  output reg [6:0] sum_vector_out
);
  reg [6:0] _sum;
  reg c_out;
  integer i;
  reg c_prev;
  reg h_prev;
  reg [6:0] buffer_result;

  always @* begin
    _sum = 7'b0;
    c_out = carry_generate_vector[0] | g_prim[0];

    for (i = 6; i >= 0; i = i - 1) begin
      if (i == 6) begin
        buffer_result = buffer(half_sum_vector[i], h_prim[i], c_out);
        _sum[i] = buffer_result;
      end else begin
        buffer_result = buffer(carry_generate_vector[i+1], g_prim[i+1], c_out);
        c_prev = buffer_result;
        buffer_result = buffer(half_sum_vector[i], h_prim[i], c_out);
        h_prev = buffer_result;
        _sum[i] = h_prev ^ c_prev;
      end
    end

    sum_vector_out = _sum;
  end

  function integer buffer;
    input integer first_signal;
    input integer second_signal;
    input integer enable_signal;
    begin
      if (enable_signal == 0)
        buffer = first_signal;
      else
        buffer = second_signal;
    end
  endfunction

endmodule
