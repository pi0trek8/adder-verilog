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
  reg [6:0] carry_generate_vector_temp;
  reg [6:0] carry_propagate_vector_temp;
  reg [6:0] g_prim_temp;
  reg [6:0] p_prim_temp;
  reg [6:0] dots_positions [0:6][0:6];
  integer rows;
  integer length = 7;
  reg [2:0] bin_num;
  integer prev_dot;
  integer tempposition;

  always @* begin
    rows = $clog2(length);
    for (integer row_num = 0; row_num < rows; row_num = row_num + 1) begin
      for (integer position = 0; position < length; position = position + 1) begin
        tempposition = position;
        for (integer i = rows - 1; i > -1; i = i - 1) begin
          bin_num[i] = tempposition % 2;
          tempposition = tempposition / 2;
        end
        $display("bin_num = %b", bin_num);
        dots_positions[row_num][position] = bin_num[row_num];
      end
    end
      for (integer row_num = 0; row_num < rows; row_num = row_num + 1) begin
        for (integer position = 0; position < length; position = position + 1) begin
        $display("dots_positions[%0d][%0d] = %0d", row_num, position, dots_positions[row_num][position]);
        end
      end
    carry_generate_vector_temp = carry_generate_vector;
    carry_propagate_vector_temp = carry_propagate_vector;
    g_prim_temp =  g_prim;
    p_prim_temp = p_prim; 
    carry_generate_vector_out = carry_generate_vector;
    carry_propagate_vector_out = carry_propagate_vector;
    g_prim_out =  g_prim;
    p_prim_out = p_prim; 
    for (integer row_num = rows - 1; row_num > -1; row_num = row_num - 1) begin
      for (integer i = length - 1; i >= 0; i = i - 1) begin
        if (dots_positions[row_num][i] == 1) begin
          if (row_num == 2) begin
            carry_propagate_vector_out[i] = carry_propagate_vector_temp[i] & carry_propagate_vector_temp[i + 1];
            carry_generate_vector_out[i] = ((carry_propagate_vector_temp[i] & carry_generate_vector_temp[i + 1]) | carry_generate_vector_temp[i]);
            p_prim_out[i] = p_prim_temp[i] & p_prim_temp[i + 1];
            g_prim_out[i] = (p_prim_temp[i] & g_prim_temp[i + 1]) | g_prim_temp[i];      
            p_prim_temp[i] = p_prim_out[i];
            g_prim_temp[i] = g_prim_out[i];
            carry_propagate_vector_temp[i] = carry_propagate_vector_out[i];
            carry_generate_vector_temp[i] = carry_generate_vector_out[i];
          end 
          else begin
            prev_dot = i - 1;
            while (dots_positions[row_num + 1][prev_dot] != 1) begin
              prev_dot = prev_dot - 1;
            end
            if (prev_dot >= 0) begin
              $display("prev_dot = %0d", prev_dot);
              carry_propagate_vector_out[6 - i] = carry_propagate_vector_temp[6 - i] & carry_propagate_vector_temp[6 - prev_dot];
              carry_generate_vector_out[6 - i] = ((carry_propagate_vector_temp[6 - i] & carry_generate_vector_temp[6 - prev_dot]) | carry_generate_vector_temp[6 - i]);
              p_prim_out[6 - i] = p_prim_temp[6 - i] & p_prim_temp[6 - prev_dot];
              g_prim_out[6 - i] = (p_prim_temp[6 - i] & g_prim_temp[6 - prev_dot]) | g_prim_temp[6 - i];      
              p_prim_temp[6 - i] = p_prim_out[6 - i];
              g_prim_temp[6 - i] = g_prim_out[6 - i];
              carry_propagate_vector_temp[6 - i] = carry_propagate_vector_out[6 - i];
              carry_generate_vector_temp[6 - i] = carry_generate_vector_out[6 - i];
            end
          end
        end
      end
    end
  end

endmodule

