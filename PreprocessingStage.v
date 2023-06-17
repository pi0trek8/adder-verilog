module PreprocessingStage(
  input wire [6:0] a,
  input wire [6:0] b,
  input wire [6:0] k,
  output reg [6:0] carry_generate_vector,
  output reg [6:0] carry_propagate_vector,
  output reg [6:0] half_sum_vector,
  output reg [6:0] g_prim,
  output reg [6:0] p_prim,
  output reg [6:0] h_prim
);
  reg [6:0] g [0:6];
  reg [6:0] p [0:6];
  reg [6:0] h [0:6];
  reg [6:0] a_prim [0:6];
  reg [6:0] b_prim [0:6];

  initial begin
    for (integer k = 6; k >= 0; k = k - 1) begin
      g[k] = 7'b0;
      p[k] = 7'b0;
      h[k] = 7'b0;
      a_prim[k] = 7'b0;
      b_prim[k] = 7'b0;
    end
  end

  always @* begin
    for (integer i = 6; i >= 0; i = i - 1) begin
      g[i] = a[i] & b[i];
      p[i] = a[i] | b[i];
      h[i] = ((~g[i]) & p[i]);

      if (k[i] == 0)
        a_prim[i] = h[i];
      else
        a_prim[i] = ~h[i];

      if (i != 0) begin
        if (k[i] == 1)
          b_prim[i - 1] = p[i];
        else
          b_prim[i - 1] = g[i];
      end
    end
  end

  always @* begin
    for (integer j = 6; j >= 0; j = j - 1) begin
      g_prim[j] = a_prim[j] & b_prim[j];
      p_prim[j] = a_prim[j] | b_prim[j];
      h_prim[j] = (~g_prim[j] & p_prim[j]);
    end
  end

always @* begin
  for (integer i = 0; i < 7; i = i + 1) begin
    carry_generate_vector[i] = g[i];
    carry_propagate_vector[i] = p[i];
    half_sum_vector[i] = h[i];
  end
end

endmodule