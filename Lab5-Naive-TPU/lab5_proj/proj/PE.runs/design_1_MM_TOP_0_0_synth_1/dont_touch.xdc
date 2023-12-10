# This file is automatically generated.
# It contains project source information necessary for synthesis and implementation.

# IP: C:/Architecture/Intelligent-Architecture/Lab5-Naive-TPU/lab5_proj/proj/PE.srcs/sources_1/bd/design_1/ip/design_1_MM_TOP_0_0/design_1_MM_TOP_0_0.xci
# IP: The module: 'design_1_MM_TOP_0_0' is the root of the design. Do not add the DONT_TOUCH constraint.

# IP: C:/Architecture/Intelligent-Architecture/Lab5-Naive-TPU/lab5_proj/proj/PE.srcs/sources_1/ip/out_align_fifo/out_align_fifo.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==out_align_fifo || ORIG_REF_NAME==out_align_fifo} -quiet] -quiet

# IP: C:/Architecture/Intelligent-Architecture/Lab5-Naive-TPU/lab5_proj/proj/PE.srcs/sources_1/ip/BRAM_WM_128b/BRAM_WM_128b.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==BRAM_WM_128b || ORIG_REF_NAME==BRAM_WM_128b} -quiet] -quiet

# IP: C:/Architecture/Intelligent-Architecture/Lab5-Naive-TPU/lab5_proj/proj/PE.srcs/sources_1/ip/BRAM_FM_64b/BRAM_FM_64b.xci
set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==BRAM_FM_64b || ORIG_REF_NAME==BRAM_FM_64b} -quiet] -quiet

# XDC: c:/Architecture/Intelligent-Architecture/Lab5-Naive-TPU/lab5_proj/proj/PE.srcs/sources_1/ip/out_align_fifo/out_align_fifo.xdc
set_property DONT_TOUCH TRUE [get_cells [split [join [get_cells -hier -filter {REF_NAME==out_align_fifo || ORIG_REF_NAME==out_align_fifo} -quiet] {/U0 } ]/U0 ] -quiet] -quiet

# XDC: c:/Architecture/Intelligent-Architecture/Lab5-Naive-TPU/lab5_proj/proj/PE.srcs/sources_1/ip/BRAM_WM_128b/BRAM_WM_128b_ooc.xdc

# XDC: c:/Architecture/Intelligent-Architecture/Lab5-Naive-TPU/lab5_proj/proj/PE.srcs/sources_1/ip/BRAM_FM_64b/BRAM_FM_64b_ooc.xdc

# XDC: c:/Architecture/Intelligent-Architecture/Lab5-Naive-TPU/lab5_proj/proj/PE.srcs/sources_1/bd/design_1/ip/design_1_MM_TOP_0_0/design_1_MM_TOP_0_0_ooc.xdc
# XDC: The top module name and the constraint reference have the same name: 'design_1_MM_TOP_0_0'. Do not add the DONT_TOUCH constraint.
set_property DONT_TOUCH TRUE [get_cells inst -quiet] -quiet

# IP: C:/Architecture/Intelligent-Architecture/Lab5-Naive-TPU/lab5_proj/proj/PE.srcs/sources_1/bd/design_1/ip/design_1_MM_TOP_0_0/design_1_MM_TOP_0_0.xci
# IP: The module: 'design_1_MM_TOP_0_0' is the root of the design. Do not add the DONT_TOUCH constraint.

# IP: C:/Architecture/Intelligent-Architecture/Lab5-Naive-TPU/lab5_proj/proj/PE.srcs/sources_1/ip/out_align_fifo/out_align_fifo.xci
#dup# set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==out_align_fifo || ORIG_REF_NAME==out_align_fifo} -quiet] -quiet

# IP: C:/Architecture/Intelligent-Architecture/Lab5-Naive-TPU/lab5_proj/proj/PE.srcs/sources_1/ip/BRAM_WM_128b/BRAM_WM_128b.xci
#dup# set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==BRAM_WM_128b || ORIG_REF_NAME==BRAM_WM_128b} -quiet] -quiet

# IP: C:/Architecture/Intelligent-Architecture/Lab5-Naive-TPU/lab5_proj/proj/PE.srcs/sources_1/ip/BRAM_FM_64b/BRAM_FM_64b.xci
#dup# set_property DONT_TOUCH TRUE [get_cells -hier -filter {REF_NAME==BRAM_FM_64b || ORIG_REF_NAME==BRAM_FM_64b} -quiet] -quiet

# XDC: c:/Architecture/Intelligent-Architecture/Lab5-Naive-TPU/lab5_proj/proj/PE.srcs/sources_1/ip/out_align_fifo/out_align_fifo.xdc
#dup# set_property DONT_TOUCH TRUE [get_cells [split [join [get_cells -hier -filter {REF_NAME==out_align_fifo || ORIG_REF_NAME==out_align_fifo} -quiet] {/U0 } ]/U0 ] -quiet] -quiet

# XDC: c:/Architecture/Intelligent-Architecture/Lab5-Naive-TPU/lab5_proj/proj/PE.srcs/sources_1/ip/BRAM_WM_128b/BRAM_WM_128b_ooc.xdc

# XDC: c:/Architecture/Intelligent-Architecture/Lab5-Naive-TPU/lab5_proj/proj/PE.srcs/sources_1/ip/BRAM_FM_64b/BRAM_FM_64b_ooc.xdc

# XDC: c:/Architecture/Intelligent-Architecture/Lab5-Naive-TPU/lab5_proj/proj/PE.srcs/sources_1/bd/design_1/ip/design_1_MM_TOP_0_0/design_1_MM_TOP_0_0_ooc.xdc
# XDC: The top module name and the constraint reference have the same name: 'design_1_MM_TOP_0_0'. Do not add the DONT_TOUCH constraint.
#dup# set_property DONT_TOUCH TRUE [get_cells inst -quiet] -quiet
