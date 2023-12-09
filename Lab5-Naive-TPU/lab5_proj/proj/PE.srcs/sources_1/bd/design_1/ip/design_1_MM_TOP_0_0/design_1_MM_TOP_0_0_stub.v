// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
// Date        : Sat Nov 27 13:00:35 2021
// Host        : USER-20200107KN running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               E:/workspace/beihang_PE2/proj/PE.srcs/sources_1/bd/design_1/ip/design_1_MM_TOP_0_0/design_1_MM_TOP_0_0_stub.v
// Design      : design_1_MM_TOP_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg400-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "MM_TOP,Vivado 2019.2" *)
module design_1_MM_TOP_0_0(clk, arst_n, BRAM_FM32_addr, BRAM_FM32_clk, 
  BRAM_FM32_wrdata, BRAM_FM32_rddata, BRAM_FM32_en, BRAM_FM32_rst, BRAM_FM32_we, 
  BRAM_WM32_addr, BRAM_WM32_clk, BRAM_WM32_wrdata, BRAM_WM32_rddata, BRAM_WM32_en, 
  BRAM_WM32_rst, BRAM_WM32_we, BRAM_CTRL_addr, BRAM_CTRL_clk, BRAM_CTRL_wrdata, 
  BRAM_CTRL_rddata, BRAM_CTRL_en, BRAM_CTRL_rst, BRAM_CTRL_we, BRAM_OUT_addr, BRAM_OUT_clk, 
  BRAM_OUT_wrdata, BRAM_OUT_rddata, BRAM_OUT_en, BRAM_OUT_rst, BRAM_OUT_we)
/* synthesis syn_black_box black_box_pad_pin="clk,arst_n,BRAM_FM32_addr[31:0],BRAM_FM32_clk,BRAM_FM32_wrdata[31:0],BRAM_FM32_rddata[31:0],BRAM_FM32_en,BRAM_FM32_rst,BRAM_FM32_we[3:0],BRAM_WM32_addr[31:0],BRAM_WM32_clk,BRAM_WM32_wrdata[31:0],BRAM_WM32_rddata[31:0],BRAM_WM32_en,BRAM_WM32_rst,BRAM_WM32_we[3:0],BRAM_CTRL_addr[31:0],BRAM_CTRL_clk,BRAM_CTRL_wrdata[31:0],BRAM_CTRL_rddata[31:0],BRAM_CTRL_en,BRAM_CTRL_rst,BRAM_CTRL_we[3:0],BRAM_OUT_addr[31:0],BRAM_OUT_clk,BRAM_OUT_wrdata[31:0],BRAM_OUT_rddata[31:0],BRAM_OUT_en,BRAM_OUT_rst,BRAM_OUT_we[3:0]" */;
  input clk;
  input arst_n;
  output [31:0]BRAM_FM32_addr;
  output BRAM_FM32_clk;
  output [31:0]BRAM_FM32_wrdata;
  input [31:0]BRAM_FM32_rddata;
  output BRAM_FM32_en;
  output BRAM_FM32_rst;
  output [3:0]BRAM_FM32_we;
  output [31:0]BRAM_WM32_addr;
  output BRAM_WM32_clk;
  output [31:0]BRAM_WM32_wrdata;
  input [31:0]BRAM_WM32_rddata;
  output BRAM_WM32_en;
  output BRAM_WM32_rst;
  output [3:0]BRAM_WM32_we;
  output [31:0]BRAM_CTRL_addr;
  output BRAM_CTRL_clk;
  output [31:0]BRAM_CTRL_wrdata;
  input [31:0]BRAM_CTRL_rddata;
  output BRAM_CTRL_en;
  output BRAM_CTRL_rst;
  output [3:0]BRAM_CTRL_we;
  output [31:0]BRAM_OUT_addr;
  output BRAM_OUT_clk;
  output [31:0]BRAM_OUT_wrdata;
  input [31:0]BRAM_OUT_rddata;
  output BRAM_OUT_en;
  output BRAM_OUT_rst;
  output [3:0]BRAM_OUT_we;
endmodule
