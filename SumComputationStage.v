module SumComputationStage (
  input wire clk,
  input wire reset,
  input wire [N-1:0] h,
  input wire [N-1:0] h_prim,
  input wire [N-1:0] c,
  input wire [N-1:0] c_prim,
  output wire [N-1:0] s
);
  parameter N = 7;
  
  reg [N-1:0] s_reg;
  reg c_out;
  integer i;
  
  function integer or_gate;
    input integer first_signal;
    input integer second_signal;
    begin
      or_gate = (first_signal || second_signal) ? 1 : 0;
    end
  endfunction
  
  function integer and_gate;
    input integer first_signal;
    input integer second_signal;
    begin
      and_gate = (first_signal && second_signal) ? 1 : 0;
    end
  endfunction
  
  function integer xor_gate;
    input integer first_signal;
    input integer second_signal;
    begin
      xor_gate = first_signal ^ second_signal;
    end
  endfunction
  
  function integer buffer;
    input integer first_signal;
    input integer second_signal;
    input integer enable_signal;
    begin
      buffer = enable_signal ? second_signal : first_signal;
    end
  endfunction
  
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      s_reg <= 0;
      c_out <= 0;
    end else begin
      c_out <= c[N-1];
      
      for (i = 0; i < N; i = i + 1) begin : loop
        reg c_prev, h_prev;
        
        if (i == 0) begin
          c_prev = buffer(c[i], c_prim[i], c_out);
          h_prev = buffer(h[i], h_prim[i], c_out);
          s_reg[i] = buffer(h_prev, c_prev, c_out);
        end else begin
          c_prev = buffer(c[i-1], c_prim[i-1], c_out);
          h_prev = buffer(h[i], h_prim[i], c_out);
          s_reg[i] = xor_gate(h_prev, c_prev);
        end
      end
    end
  end
  
  assign s = s_reg;

endmodule
