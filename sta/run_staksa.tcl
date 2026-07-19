# Read technology library
read_liberty /home/cdesigner/sky130RTLDesignAndSynthesisWorkshop/lib/sky130_fd_sc_hd__tt_025C_1v80.lib

# Read synthesized netlist
read_verilog /home/cdesigner/Adder-STA-Synthesis/netlists/kogge_stone_synth.v

# Link design
link_design kogge_stone_adder

# Read timing constraints
read_sdc /home/cdesigner/Adder-STA-Synthesis/constraints/constraints.sdc

# Timing reports
report_checks -path_delay max -fields {cap input}
report_checks -path_delay min -fields {cap input}

# Slack reports
report_worst_slack
report_wns
report_tns
