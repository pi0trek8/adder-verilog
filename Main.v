`include "PreprocessingStage.v"
`include "SumComputationStage.v"
`include "ParrarelPrefixStage.v"

module Main;

  // Declarations of signals
  reg [6:0] a, b, k;
  wire [6:0] g, p, h, a_prim, b_prim;
  wire [6:0] g_prim, p_prim, h_prim;
  wire [6:0] s;
  reg clk;
  reg reset;

  // Instantiate modules
  PreprocessingStage preprocessingStage (
    .a(a),
    .b(b),
    .k(k),
    .g(g),
    .p(p),
    .h(h),
    .g_prim(g_prim),
    .p_prim(p_prim),
    .h_prim(h_prim)
  );

  // ParrarelPrefixStage parrarelPrefixStage(
  //     .clk(clk),
  //     .reset(reset),
  //     .g(g),
  //     .p(p),
  //     .g_prim(g_prim),
  //     .p_prim(p_prim),
  //     .g_out(g),
  //     .p_out(p),
  //     .g_prim_out(g_prim),
  //     .p_prim_out(p_prim)
  //   );

  // SumComputationStage sumComputationStage (
  //   .h(h),
  //   .h_prim(h_prim),
  //   .c(g),
  //   .c_prim(g_prim),
  //   .s(s)
  // );

  initial begin
    // Initialize data
    a = 7'b0111000;
    b = 7'b0111011;
    k = 7'b1101000;

    // Display initial values
    $display("a=%b", a);
    $display("b=%b", b);
    $display("k=%b", k);

    // Perform computations
    #1; // Delay for one time unit

    // Display results
    // $display("a_prim=%b", a_prim);
    // $display("b_prim=%b", b_prim);
    $display("p=%b", p);
    $display("g=%b", g);
    $display("h=%b", h);
    $display("p`=%b", p_prim);
    $display("g`=%b", g_prim);
    $display("h`=%b", h_prim);

    // Perform additional computations
    #1; // Delay for one time unit

    // Display final result
    $display("s=%b", s);
  end

endmodule
