module gate (
  input first_signal,
  input second_signal,
  output logic gate_output
);
  always @(*) begin
    gate_output = first_signal | second_signal;
  end
endmodule

module or_gate (
  input first_signal,
  input second_signal,
  output logic gate_output
);
  always @(*) begin
    gate_output = first_signal | second_signal;
  end
endmodule

module and_gate (
  input first_signal,
  input second_signal,
  output logic gate_output
);
  always @(*) begin
    gate_output = first_signal & second_signal;
  end
endmodule

module xor_gate (
  input first_signal,
  input second_signal,
  output logic gate_output
);
  always @(*) begin
    gate_output = first_signal ^ second_signal;
  end
endmodule

module buffer (
  input first_signal,
  input second_signal,
  input enable_signal,
  output logic buffer_output
);
  always @(*) begin
    buffer_output = enable_signal ? second_signal : first_signal;
  end
endmodule

module parallel_prefix_double_node (
  input pi,
  input gi,
  input pi_prev,
  input gi_prev,
  input pi_prim,
  input gi_prim,
  input pi_prim_prev,
  input gi_prim_prev,
  output logic pi_new,
  output logic gi_new,
  output logic pi_prim_new,
  output logic gi_prim_new
);
  always @(*) begin
    {pi_new, gi_new} = {pi & pi_prev, (pi & gi_prev) | gi};
    {pi_prim_new, gi_prim_new} = {pi_prim & pi_prim_prev, (pi_prim & gi_prim_prev) | gi_prim};
  end
endmodule
