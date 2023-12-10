// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
// Date        : Wed Nov 10 23:32:18 2021
// Host        : USER-20200107KN running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               e:/workspace/beihang_PE3/proj/PE.srcs/sources_1/ip/tb_ram_WM128/tb_ram_WM128_stub.v
// Design      : tb_ram_WM128
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg400-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2019.2" *)
module tb_ram_WM128(clka, wea, addra, dina, douta, clkb, web, addrb, dinb, 
  doutb)
/* synthesis syn_black_box black_box_pad_pin="clka,wea[15:0],addra[14:0],dina[127:0],douta[127:0],clkb,web[15:0],addrb[14:0],dinb[127:0],doutb[127:0]" */;
  input clka;
  input [15:0]wea;
  input [14:0]addra;
  input [127:0]dina;
  output [127:0]douta;
  input clkb;
  input [15:0]web;
  input [14:0]addrb;
  input [127:0]dinb;
  output [127:0]doutb;
endmodule
