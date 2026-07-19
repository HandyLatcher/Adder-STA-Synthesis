# 1. Define a Virtual Clock (100 MHz -> 10ns Period)
# Clock period is varied during analysis to determine maximum operating frequency for each adder architecture
create_clock -name virtual_clk -period 10

# 2. Define Input Delays
# Setup Check (Max)
set_input_delay -max 2.0 -clock virtual_clk [get_ports A[*]]
set_input_delay -max 2.0 -clock virtual_clk [get_ports B[*]]
set_input_delay -max 2.0 -clock virtual_clk [get_ports Cin]

# Hold Check (Min)
set_input_delay -min 0.5 -clock virtual_clk [get_ports A[*]]
set_input_delay -min 0.5 -clock virtual_clk [get_ports B[*]]
set_input_delay -min 0.5 -clock virtual_clk [get_ports Cin]

# 3. Define Output Delays
# Setup Check (Max)
set_output_delay -max 2.0 -clock virtual_clk [get_ports Sum[*]]
set_output_delay -max 2.0 -clock virtual_clk [get_ports Cout]

# Hold Check (Min)
set_output_delay -min -0.5 -clock virtual_clk [get_ports Sum[*]]
set_output_delay -min -0.5 -clock virtual_clk [get_ports Cout]

# 4. Define Output Load Constraints (ADD THIS HERE)
# Apply capacitive load to the sum output bus and carry-out pin
set_load 0.05 [get_ports Sum[*]]
set_load 0.05 [get_ports Cout]
