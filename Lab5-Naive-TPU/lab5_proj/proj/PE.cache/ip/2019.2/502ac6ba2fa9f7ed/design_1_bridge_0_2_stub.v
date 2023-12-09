// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
// Date        : Tue Aug 24 13:30:28 2021
// Host        : USER-20200107KN running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ design_1_bridge_0_2_stub.v
// Design      : design_1_bridge_0_2
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg400-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "bridge,Vivado 2019.2" *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix(clk, rst, f0_addr, f0_clk, f0_wrdata, f0_rddata, 
  f0_en, f0_rst, f0_we, f1_addr, f1_clk, f1_wrdata, f1_rddata, f1_en, f1_rst, f1_we, w0_addr, w0_clk, 
  w0_wrdata, w0_rddata, w0_en, w0_rst, w0_we, w1_addr, w1_clk, w1_wrdata, w1_rddata, w1_en, w1_rst, 
  w1_we, ot_addr, ot_clk, ot_wrdata, ot_rddata, ot_en, ot_rst, ot_we, com_addr, com_clk, com_wrdata, 
  com_rddata, com_en, com_rst, com_we)
/* synthesis syn_black_box black_box_pad_pin="clk,rst,f0_addr[31:0],f0_clk,f0_wrdata[31:0],f0_rddata[31:0],f0_en,f0_rst,f0_we[3:0],f1_addr[31:0],f1_clk,f1_wrdata[31:0],f1_rddata[31:0],f1_en,f1_rst,f1_we[3:0],w0_addr[31:0],w0_clk,w0_wrdata[31:0],w0_rddata[31:0],w0_en,w0_rst,w0_we[3:0],w1_addr[31:0],w1_clk,w1_wrdata[31:0],w1_rddata[31:0],w1_en,w1_rst,w1_we[3:0],ot_addr[31:0],ot_clk,ot_wrdata[31:0],ot_rddata[31:0],ot_en,ot_rst,ot_we[3:0],com_addr[31:0],com_clk,com_wrdata[31:0],com_rddata[31:0],com_en,com_rst,com_we[3:0]" */;
  input clk;
  input rst;
  output [31:0]f0_addr;
  output f0_clk;
  output [31:0]f0_wrdata;
  input [31:0]f0_rddata;
  output f0_en;
  output f0_rst;
  output [3:0]f0_we;
  output [31:0]f1_addr;
  output f1_clk;
  output [31:0]f1_wrdata;
  input [31:0]f1_rddata;
  output f1_en;
  output f1_rst;
  output [3:0]f1_we;
  output [31:0]w0_addr;
  output w0_clk;
  output [31:0]w0_wrdata;
  input [31:0]w0_rddata;
  output w0_en;
  output w0_rst;
  output [3:0]w0_we;
  output [31:0]w1_addr;
  output w1_clk;
  output [31:0]w1_wrdata;
  input [31:0]w1_rddata;
  output w1_en;
  output w1_rst;
  output [3:0]w1_we;
  output [31:0]ot_addr;
  output ot_clk;
  output [31:0]ot_wrdata;
  input [31:0]ot_rddata;
  output ot_en;
  output ot_rst;
  output [3:0]ot_we;
  output [31:0]com_addr;
  output com_clk;
  output [31:0]com_wrdata;
  input [31:0]com_rddata;
  output com_en;
  output com_rst;
  output [3:0]com_we;
endmodule
