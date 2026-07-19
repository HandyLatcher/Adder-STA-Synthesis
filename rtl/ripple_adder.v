// Flat architecture: All logic contained within a single module.
module ripple_adder #(
    parameter WIDTH = 8 // Default value
)(
    input  [WIDTH-1:0] A,
    input  [WIDTH-1:0] B,
    input              Cin,
    output [WIDTH-1:0] Sum,
    output             Cout
);

    // The carry bus must be WIDTH + 1 to accommodate the final Cout
    wire [WIDTH:0] c;
    assign c[0] = Cin;

    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin
            assign Sum[i] = A[i] ^ B[i] ^ c[i];
            assign c[i+1] = (A[i] & B[i]) | (B[i] & c[i]) | (A[i] & c[i]);
        end
    endgenerate

    assign Cout = c[WIDTH]; // Takes the last carry bit

endmodule
