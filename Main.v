`include "PreprocessingStage.v"
`include "SumComputationStage.v"
`include "ParallelPrefixStage.v"

module main;
  reg [6:0] first_number_a;
  reg [6:0] second_number_b;
  reg [6:0] modulo_controller;

  wire [6:0] carry_generate_vector;
  wire [6:0] carry_propagate_vector;
  wire [6:0] half_sum_vector;
  wire [6:0] g_prim;
  wire [6:0] p_prim;
  wire [6:0] h_prim;
  wire [6:0] sum_vector;
  
  PreprocessingStage preprocessingStage(
    .a(first_number_a),
    .b(second_number_b),
    .k(modulo_controller),
    .carry_generate_vector(carry_generate_vector),
    .carry_propagate_vector(carry_propagate_vector),
    .half_sum_vector(half_sum_vector),
    .g_prim(g_prim),
    .p_prim(p_prim),
    .h_prim(h_prim)
  );
  //   ParallelPrefixStage ParallelPrefixStage(
  //   .carry_generate_vector(carry_generate_vector),
  //   .carry_propagate_vector(carry_propagate_vector),
  //   .g_prim(g_prim),
  //   .p_prim(p_prim),
  //   .carry_generate_vector_out(carry_generate_vector),
  //   .carry_propagate_vector_out(carry_propagate_vector),
  //   .g_prim_out(g_prim),
  //   .p_prim_out(p_prim)
  // );

  SumComputationStage sumComputationStage(
    .half_sum_vector(half_sum_vector),
    .h_prim(h_prim),
    .carry_generate_vector(carry_generate_vector),
    .g_prim(g_prim),
    .sum_vector_out(sum_vector)
  );

   initial begin
    first_number_a = 7'b1010101;
    second_number_b = 7'b1010101;
    modulo_controller = 7'b0000000;
    #100; // Wait for some time for the computation to finish
    $display("a = %b", first_number_a);
    $display("b = %b", second_number_b);
    $display("k = %b", modulo_controller);
    $display();
    $display("half sum vector (h) = %b", half_sum_vector);
    $display("carry propagate vector (p) = %b", carry_propagate_vector);
    $display("carry generate vector (g) = %b", carry_generate_vector);
    $display();
    $display("half sum from enveloped cells (h`) = %b", h_prim);
    $display("carry propagate vector from enveloped cells (p`) = %b", p_prim);
    $display("carry generate vector from enveloped cells (g`) = %b", g_prim);
    $display();
    $display("sum vector = %b", sum_vector);
  end
endmodule

