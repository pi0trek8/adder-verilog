module ParrarelPrefixStage (
  input wire clk,
  input wire reset,
  input wire [N-1:0] g,
  input wire [N-1:0] p,
  input wire [N-1:0] g_prim,
  input wire [N-1:0] p_prim,
  output reg [N-1:0] g_out,
  output reg [N-1:0] p_out,
  output reg [N-1:0] g_prim_out,
  output reg [N-1:0] p_prim_out
);
  parameter N = 7;
  
  reg [N-1:0] g_reg, p_reg, g_prim_reg, p_prim_reg;
  
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      g_reg <= 0;
      p_reg <= 0;
      g_prim_reg <= 0;
      p_prim_reg <= 0;
    end else begin
      g_reg <= g;
      p_reg <= p;
      g_prim_reg <= g_prim;
      p_prim_reg <= p_prim;
    end
  end
  
  generate
    genvar i;
    for (i = 0; i < N; i = i + 1) begin : PARALLEL_PREFIX_LOOP
      always @(posedge clk or posedge reset) begin
        if (reset) begin
          if (i == 0) begin
            g_out[i] <= 0;
            p_out[i] <= 0;
            g_prim_out[i] <= 0;
            p_prim_out[i] <= 0;
          end else begin
            g_out[i] <= g_out[i-1];
            p_out[i] <= p_out[i-1];
            g_prim_out[i] <= g_prim_out[i-1];
            p_prim_out[i] <= p_prim_out[i-1];
          end
        end else begin
          if (i > 0) begin
            g_out[i] <= g_reg[i] ? p_out[i-1] : g_out[i-1];
            p_out[i] <= g_reg[i] | p_out[i-1];
            g_prim_out[i] <= g_prim_reg[i] ? p_prim_out[i-1] : g_prim_out[i-1];
            p_prim_out[i] <= g_prim_reg[i] | p_prim_out[i-1];
          end else begin
            g_out[i] <= g_reg[i];
            p_out[i] <= p_reg[i];
            g_prim_out[i] <= g_prim_reg[i];
            p_prim_out[i] <= p_prim_reg[i];
          end
        end
      end
    end
  endgenerate

endmodule
