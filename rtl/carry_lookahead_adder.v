// 8-bit Carry Lookahead Adder
// Hierarchy: Top-level 8-bit module containing two 4-bit CLA blocks.
module cla_8bit(
    input [7:0] a, b,
    input cin,
    output [7:0] sum,
    output cout
);
    // (* keep *) forces synthesis to maintain this internal net
    (* keep *) wire c4; 

    cla_4bit cla_low  (.a(a[3:0]), .b(b[3:0]), .cin(cin), .sum(sum[3:0]), .cout(c4));
    cla_4bit cla_high (.a(a[7:4]), .b(b[7:4]), .cin(c4),  .sum(sum[7:4]), .cout(cout));

endmodule

// Core 4-bit CLA logic
module cla_4bit(
    input [3:0] a, b,
    input cin,
    output [3:0] sum,
    output cout
);
    (*keep*) wire [3:0] p, g;
    // (* keep *) ensures the carry chain logic is not re-mapped to a different topology
    (* keep *) wire [3:1] c;

    assign p = a ^ b;
    assign g = a & b;

    assign c[1] = g[0] | (p[0] & cin);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & cin);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & cin);
    
    assign cout = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & cin);

    assign sum[0] = p[0] ^ cin;
    assign sum[1] = p[1] ^ c[1];
    assign sum[2] = p[2] ^ c[2];
    assign sum[3] = p[3] ^ c[3];

endmodule
