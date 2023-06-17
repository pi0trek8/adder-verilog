module ParallelPrefixStage(
  input wire [6:0] carry_generate_vector,
  input wire [6:0] carry_propagate_vector,
  input wire [6:0] g_prim,
  input wire [6:0] p_prim,
  output reg [6:0] carry_generate_vector_out,
  output reg [6:0] carry_propagate_vector_out,
  output reg [6:0] g_prim_out,
  output reg [6:0] p_prim_out
);

  reg [6:0] dots_positions [0:6][0:6];
  integer rows = $clog2(7);
  integer length = 7;
  reg [6:0] bin_num;
  integer prev_dot;
  initial begin
    for (integer row_num = 0; row_num < rows; row_num = row_num + 1) begin
      for (integer position = 0; position < length; position = position + 1) begin

        for (integer i = 0; i < rows; i = i + 1) begin
          if (i == position % rows)
            bin_num[i] = 1;
          else
            bin_num[i] = 0;
        end
        dots_positions[row_num][position] = bin_num[row_num];
      end
    end

    for (integer row_num = 0; row_num < rows; row_num = row_num + 1) begin
      for (integer i = length - 1; i >= 0; i = i - 1) begin
        if (row_num == 0) begin
          if (dots_positions[row_num][i] == 1) begin

            prev_dot = i - 1;
            while (prev_dot >= 0 && dots_positions[row_num][prev_dot] != 1) begin
              prev_dot = prev_dot - 1;
            end
            if (prev_dot >= 0) begin
              g_prim_out[i] = g_prim[i] & g_prim[prev_dot];
              p_prim_out[i] = p_prim[i] | p_prim[prev_dot];
            end
          end
        end else begin
          if (dots_positions[row_num][i] == 1) begin
            prev_dot = i - 1;
            while (prev_dot >= 0 && dots_positions[row_num][prev_dot] != 1) begin
              prev_dot = prev_dot - 1;
            end
            if (prev_dot >= 0) begin
              g_prim_out[i] = g_prim[i] & g_prim[prev_dot];
              p_prim_out[i] = p_prim[i] | p_prim[prev_dot];
            end
          end
        end
      end
    end
  end

  always @* begin
    carry_generate_vector_out = carry_generate_vector;
    carry_propagate_vector_out = carry_propagate_vector;
    g_prim_out = g_prim;
    p_prim_out = p_prim;
  end

endmodule
