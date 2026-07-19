# 1. Setup and Elaboration
read_verilog /home/cdesigner/Adder-STA-Synthesis/rtl/ripple_adder.v
#change path for rtl file
read_liberty -lib /home/cdesigner/sky130RTLDesignAndSynthesisWorkshop/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
hierarchy -check -top ripple_adder

# 2. High-Level Synthesis
synth -top ripple_adder
opt

# 3. ABC Logic Optimization
abc -liberty /home/cdesigner/sky130RTLDesignAndSynthesisWorkshop/lib/sky130_fd_sc_hd__tt_025C_1v80.lib

# 4. Final Cleanup and Checks
clean -purge
check

# 5. Area Reporting
stat -liberty /home/cdesigner/sky130RTLDesignAndSynthesisWorkshop/lib/sky130_fd_sc_hd__tt_025C_1v80.lib

# 6. Output Netlist
write_verilog -noattr netlists/ripple_adder_synth.v
