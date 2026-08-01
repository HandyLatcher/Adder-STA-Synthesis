`timescale 1ns/1ps

module cla_8bit_tb;

    // Parameters
    parameter WIDTH = 8;
    parameter RANDOM_TESTS = 50;

    // Signals
    reg signed [WIDTH-1:0] a, b;
    reg cin;
    wire signed [WIDTH-1:0] sum;
    wire cout;

    integer pass_count = 0;
    integer fail_count = 0;

    // Golden Model
    wire signed [WIDTH:0] expected_out = a + b + cin;

    // DUT
    cla_8bit uut (
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .cout(cout)
    );

    // Task
    task check_adder(
        input signed [WIDTH-1:0] t_a,
        input signed [WIDTH-1:0] t_b,
        input t_cin
    );
        begin
            a   = t_a;
            b   = t_b;
            cin = t_cin;
            #10;

            if ({cout, sum} !== expected_out) begin
                $display("FAIL @ %0t | a=%d, b=%d, cin=%b | Expected=%d, Got=%d",
                         $time, a, b, cin, expected_out, {cout, sum});
                fail_count = fail_count + 1;
            end
            else begin
                pass_count = pass_count + 1;
            end
        end
    endtask

    // Test Sequence
    initial begin
        $dumpfile("cla.vcd");
        $dumpvars(0, cla_8bit_tb);

        // Edge Cases
        check_adder(8'sd127, 8'sd1, 0);
        check_adder(8'h80, 8'hFF, 0);
        check_adder(8'hAA, 8'h55, 1);

        // Random Tests
        repeat (RANDOM_TESTS) begin
            check_adder($random, $random, $random % 2);
        end

        $display("\n");
        $display("      Simulation Summary"      );
        $display("==============================");
        $display("Total Tests : %0d", pass_count + fail_count);
        $display("Passed      : %0d", pass_count);
        $display("Failed      : %0d", fail_count);
        $display("==============================/n");
        
        $finish;
    end

endmodule
