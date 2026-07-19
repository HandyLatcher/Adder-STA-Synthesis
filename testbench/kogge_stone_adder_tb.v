`timescale 1ns/1ps

module kogge_stone_adder_tb;

    // Parameters
    parameter RANDOM_TESTS = 50;

    // Signals
    reg signed [7:0] A, B;
    reg Cin;
    wire signed [7:0] Sum;
    wire Cout;

    integer pass_count = 0;
    integer fail_count = 0;

    // Reference Model
    wire signed [8:0] expected_out = A + B + Cin;

    // DUT
    kogge_stone_adder uut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Sum(Sum),
        .Cout(Cout)
    );

    // Task
    task check_adder(
        input signed [7:0] t_a,
        input signed [7:0] t_b,
        input t_cin
    );
        begin
            A = t_a;
            B = t_b;
            Cin = t_cin;
            #10;

            if ({Cout, Sum} !== expected_out) begin
                $display("FAIL @ %0t | A=%d, B=%d, Cin=%b | Expected=%d, Got=%d",
                         $time, A, B, Cin, expected_out, {Cout, Sum});
                fail_count++;
            end
            else begin
                pass_count++;
            end
        end
    endtask

    // Execution
    initial begin
        $dumpfile("kogge_stone_adder.vcd");
        $dumpvars(0, kogge_stone_adder_tb);

        // Edge Cases
        check_adder(8'sd127, 8'sd1, 0);
        check_adder(8'h80, 8'hFF, 0);
        check_adder(8'hAA, 8'h55, 1);

        // Random Stress Tests
        repeat (RANDOM_TESTS) begin
            check_adder($random, $random, $random % 2);
        end

        // Simulation Summary
        $display("\n==============================");
        $display("      Simulation Summary      ");
        $display("==============================");
        $display("Total Tests : %0d", pass_count + fail_count);
        $display("Passed      : %0d", pass_count);
        $display("Failed      : %0d", fail_count);
        $display("==============================\n");

        $finish;
    end

endmodule
