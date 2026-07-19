# 1. Setup and Elaboration

read_verilog /home/cdesigner/Adder-STA-Synthesis/rtl/carry_lookahead_adder.v
read_liberty -lib /home/cdesigner/sky130RTLDesignAndSynthesisWorkshop/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
hierarchy -check -top cla_8bit

# 2. High-Level Synthesis
synth -top cla_8bit
opt

# 3. ABC Logic Optimization
abc -liberty /home/cdesigner/sky130RTLDesignAndSynthesisWorkshop/lib/sky130_fd_sc_hd__tt_025C_1v80.lib

# 4. Final Cleanup and Checks
clean -purge
check

# 5. Area Reporting
stat -liberty /home/cdesigner/sky130RTLDesignAndSynthesisWorkshop/lib/sky130_fd_sc_hd__tt_025C_1v80.lib

# 6. Output Netlist
write_verilog -noattr netlists/carry_lookahead_adder_synth.v
