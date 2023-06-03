module PreprocessingStage (
  input [6:0] a,
  input [6:0] b,
  input [6:0] k,
  output [6:0] g,
  output [6:0] p,
  output [6:0] h,
  output [6:0] g_prim,
  output [6:0] p_prim,
  output [6:0] h_prim
);
  reg [6:0] g_temp, p_temp, h_temp;
  reg [6:0] g_prim_temp, p_prim_temp, h_prim_temp;
  reg [6:0] a_prim_temp, b_prim_temp;
  integer i;

  assign g = g_temp;
  assign p = p_temp;
  assign h = h_temp;
  assign g_prim = g_prim_temp;
  assign p_prim = p_prim_temp;
  assign h_prim = h_prim_temp;

  always @(*) begin
    for (i = 0; i < 7; i = i + 1) begin
      g_temp[i] = a[i] & b[i];
      p_temp[i] = a[i] | b[i];
      h_temp[i] = ~(g_temp[i] & p_temp[i]);

      if (k[i] == 1) begin
        a_prim_temp[i] = ~h_temp[i];
      end else begin
        a_prim_temp[i] = h_temp[i];
      end

      if (i != 6) begin
        b_prim_temp[i + 1] = (k[i] == 1) ? p_temp[i] : g_temp[i];
      end
    end
  end

  always @(*) begin
    for (i = 0; i < 7; i = i + 1) begin
      g_prim_temp[i] = a_prim_temp[i] & b_prim_temp[i];
      p_prim_temp[i] = a_prim_temp[i] | b_prim_temp[i];
      h_prim_temp[i] = ~(g_prim_temp[i] & p_prim_temp[i]);
    end
  end
endmodule