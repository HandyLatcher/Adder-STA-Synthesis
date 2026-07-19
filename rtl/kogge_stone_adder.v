`timescale 1ns/1ps

module kogge_stone_adder (
    input  [7:0] A,
    input  [7:0] B,
    input        Cin,
    output [7:0] Sum,
    output       Cout
);

    // Bitwise Propagate and Generate
    // Pi = Ai XOR Bi
    // Gi = Ai AND Bi
 (*keep*) wire [7:0] p0, g0;

    assign p0 = A ^ B;   // propagate
    assign g0 = A & B;   // generate


    // PREFIX STAGE 1 (distance = 1)
    (*keep*) wire [7:0] p1, g1;

    assign p1[0] = p0[0];
    assign g1[0] = g0[0];

    genvar i;
    generate
        for (i = 1; i < 8; i = i + 1) begin
            assign p1[i] = p0[i] & p0[i-1];
            assign g1[i] = g0[i] | (p0[i] & g0[i-1]);
        end
    endgenerate


    // PREFIX STAGE 2 (distance = 2)
    // Combines 2-bit groups
    wire [7:0] p2, g2;

    assign p2[1:0] = p1[1:0];
    assign g2[1:0] = g1[1:0];

    generate
        for (i = 2; i < 8; i = i + 1) begin
            assign p2[i] = p1[i] & p1[i-2];
            assign g2[i] = g1[i] | (p1[i] & g1[i-2]);
        end
    endgenerate


    // PREFIX STAGE 3 (distance = 4)
    // Combines 4-bit groups
    (*keep*)  wire [7:0] p3, g3;

    assign p3[3:0] = p2[3:0];
    assign g3[3:0] = g2[3:0];

    generate
        for (i = 4; i < 8; i = i + 1) begin
            assign p3[i] = p2[i] & p2[i-4];
            assign g3[i] = g2[i] | (p2[i] & g2[i-4]);
        end
    endgenerate


    // CARRY GENERATION (GRAY CELL LOGIC)
    (*keep*) wire [8:0] C;

    assign C[0] = Cin;

    assign C[1] = g0[0] | (p0[0] & C[0]);  // C1
    assign C[2] = g1[1] | (p1[1] & C[0]);  // C2
    assign C[3] = g2[2] | (p2[2] & C[0]); //  C3  
    
   generate
    for(i=4;i<9;i=i+1)begin
	assign C[i] = g3[i-1] | (p3[i-1] & C[0]);
    end
   endgenerate 
   
  //   assign C[4] = g3[3] | (p3[3] & C[0]);   C4
  //   assign C[5] = g3[4] | (p3[4] & C[0]);   C5
  //   assign C[6] = g3[5] | (p3[5] & C[0]);   C6
  //   assign C[7] = g3[6] | (p3[6] & C[0]);   C7
  //   assign C[8] = g3[7] | (p3[7] & C[0]);   Cout
  //   The for loop performs the same function as the commented carries

    // SUM
    // Si = Pi XOR Ci
    assign Sum = p0 ^ C[7:0];

    assign Cout = C[8];

endmodule

