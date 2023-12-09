module MM_TOP(
    input clk,
    input arst_n,
    // connect BRAM_FM32
    output [31:0] BRAM_FM32_addr,
    output BRAM_FM32_clk, // clk
    output [31:0] BRAM_FM32_wrdata, // 'b0
    input [31:0] BRAM_FM32_rddata,
    output BRAM_FM32_en, // 1'b1
    output BRAM_FM32_rst, // rst
    output [3:0] BRAM_FM32_we, // 'b0
    // connect BRAM_WM32
    output [31:0] BRAM_WM32_addr,
    output BRAM_WM32_clk, // clk
    output [31:0] BRAM_WM32_wrdata, // 'b0
    input [31:0] BRAM_WM32_rddata,
    output BRAM_WM32_en, // 1'b1
    output BRAM_WM32_rst, // rst
    output [3:0] BRAM_WM32_we, // 'b0
    // connect BRAM_CTRL
    output [31:0] BRAM_CTRL_addr,
    output BRAM_CTRL_clk, // clk
    output [31:0] BRAM_CTRL_wrdata,
    input [31:0] BRAM_CTRL_rddata,
    output BRAM_CTRL_en, // 1'b1
    output BRAM_CTRL_rst, // rst
    output [3:0] BRAM_CTRL_we,
    // connect BRAM_OUT
    output [31:0] BRAM_OUT_addr,
    output BRAM_OUT_clk, // clk
    output [31:0] BRAM_OUT_wrdata,
    input [31:0] BRAM_OUT_rddata,
    output BRAM_OUT_en, // 1'b1
    output BRAM_OUT_rst, // rst
    output [3:0] BRAM_OUT_we
    );

wire rst;

// CTRL
// connect FM_reshape&WM_reshape
wire [15:0] M;
wire [15:0] N;
wire [15:0] P;
wire reshape_start;
wire FM_reshape_finish; // 电平信号
wire WM_reshape_finish; // 电平信号
// connect Multiply_ctrl
wire [7:0] sub_P; // 本次计算子矩阵结果的大小
wire [7:0] sub_M; // 本次计算子矩阵结果的大小
wire [15:0] subFM_addr;
wire [15:0] subFM_incr;
wire [15:0] subWM_addr;
wire [15:0] subWM_incr;
wire submulti_start;
wire submulti_finish; // 脉冲信号
// connect Out_ctrl
wire [15:0] Ma;
wire [15:0] Pa;
wire out_start;
wire out_finish; // 脉冲信号

// FM_reshape
// connect BRAM_FM64
wire [15:0] BRAM_FM64_waddr;
wire [63:0] BRAM_FM64_wrdata;
wire BRAM_FM64_we;

// WM_reshape
// connect BRAM_WM128
wire [15:0] BRAM_WM128_waddr;
wire [127:0] BRAM_WM128_wrdata;
wire BRAM_WM128_we;

// Multiply_ctrl
// connect BRAM_FM64
wire [15:0] BRAM_FM64_raddr;
wire [63:0] BRAM_FM64_rddata;
// connect BRAM_WM128
wire [15:0] BRAM_WM128_raddr;
wire [127:0] BRAM_WM128_rddata;
// connect Input_align
wire [7:0] fvalid;
wire [15:0] wvalid;
wire [63:0] fdata;
wire [127:0] wdata;
// connect Multiply_8x8
wire num_valid;
wire [15:0] num_ori;
// connect Align_fifo
wire [7:0] sub_scale_M1;
wire [7:0] sub_scale_P1;
wire [7:0] sub_scale_M2;
wire [7:0] sub_scale_P2;
wire align_fifo_get_all1;
wire align_fifo_get_all2;

// Align_fifo
// connect Out_ctrl
wire out_ctrl_ready1;
wire out_ctrl_ready2;
wire valid1;
wire [31:0] data1;
wire valid2;
wire [31:0] data2;

wire                  ali_fvalid0_1            ; 
wire    [   7:   0]   ali_fdata0_1             ; 
wire                  ali_fvalid1_1            ; 
wire    [   7:   0]   ali_fdata1_1             ; 
wire                  ali_fvalid2_1            ; 
wire    [   7:   0]   ali_fdata2_1             ; 
wire                  ali_fvalid3_1            ; 
wire    [   7:   0]   ali_fdata3_1             ; 
wire                  ali_fvalid4_1            ; 
wire    [   7:   0]   ali_fdata4_1             ; 
wire                  ali_fvalid5_1            ; 
wire    [   7:   0]   ali_fdata5_1             ; 
wire                  ali_fvalid6_1            ; 
wire    [   7:   0]   ali_fdata6_1             ; 
wire                  ali_fvalid7_1            ; 
wire    [   7:   0]   ali_fdata7_1             ; 
wire                  ali_wvalid0_1            ; 
wire    [   7:   0]   ali_wdata0_1             ; 
wire                  ali_wvalid1_1            ; 
wire    [   7:   0]   ali_wdata1_1             ; 
wire                  ali_wvalid2_1            ; 
wire    [   7:   0]   ali_wdata2_1             ; 
wire                  ali_wvalid3_1            ; 
wire    [   7:   0]   ali_wdata3_1             ; 
wire                  ali_wvalid4_1            ; 
wire    [   7:   0]   ali_wdata4_1             ; 
wire                  ali_wvalid5_1            ; 
wire    [   7:   0]   ali_wdata5_1             ; 
wire                  ali_wvalid6_1            ; 
wire    [   7:   0]   ali_wdata6_1             ; 
wire                  ali_wvalid7_1            ; 
wire    [   7:   0]   ali_wdata7_1             ; 

wire                  ali_fvalid0_2            ; 
wire    [   7:   0]   ali_fdata0_2             ; 
wire                  ali_fvalid1_2            ; 
wire    [   7:   0]   ali_fdata1_2             ; 
wire                  ali_fvalid2_2            ; 
wire    [   7:   0]   ali_fdata2_2             ; 
wire                  ali_fvalid3_2            ; 
wire    [   7:   0]   ali_fdata3_2             ; 
wire                  ali_fvalid4_2            ; 
wire    [   7:   0]   ali_fdata4_2             ; 
wire                  ali_fvalid5_2            ; 
wire    [   7:   0]   ali_fdata5_2             ; 
wire                  ali_fvalid6_2            ; 
wire    [   7:   0]   ali_fdata6_2             ; 
wire                  ali_fvalid7_2            ; 
wire    [   7:   0]   ali_fdata7_2             ; 
wire                  ali_wvalid0_2            ; 
wire    [   7:   0]   ali_wdata0_2             ; 
wire                  ali_wvalid1_2            ; 
wire    [   7:   0]   ali_wdata1_2             ; 
wire                  ali_wvalid2_2            ; 
wire    [   7:   0]   ali_wdata2_2             ; 
wire                  ali_wvalid3_2            ; 
wire    [   7:   0]   ali_wdata3_2             ; 
wire                  ali_wvalid4_2            ; 
wire    [   7:   0]   ali_wdata4_2             ; 
wire                  ali_wvalid5_2            ; 
wire    [   7:   0]   ali_wdata5_2             ; 
wire                  ali_wvalid6_2            ; 
wire    [   7:   0]   ali_wdata6_2             ; 
wire                  ali_wvalid7_2            ; 
wire    [   7:   0]   ali_wdata7_2             ; 

wire                  valid_get0_1             ; 
wire    [  31:   0]   data_get0_1              ; 
wire                  valid_get1_1             ; 
wire    [  31:   0]   data_get1_1              ; 
wire                  valid_get2_1             ; 
wire    [  31:   0]   data_get2_1              ; 
wire                  valid_get3_1             ; 
wire    [  31:   0]   data_get3_1              ; 
wire                  valid_get4_1             ; 
wire    [  31:   0]   data_get4_1              ; 
wire                  valid_get5_1             ; 
wire    [  31:   0]   data_get5_1              ; 
wire                  valid_get6_1             ; 
wire    [  31:   0]   data_get6_1              ; 
wire                  valid_get7_1             ; 
wire    [  31:   0]   data_get7_1              ; 

wire                  valid_get0_2             ; 
wire    [  31:   0]   data_get0_2              ; 
wire                  valid_get1_2             ; 
wire    [  31:   0]   data_get1_2              ; 
wire                  valid_get2_2             ; 
wire    [  31:   0]   data_get2_2              ; 
wire                  valid_get3_2             ; 
wire    [  31:   0]   data_get3_2              ; 
wire                  valid_get4_2             ; 
wire    [  31:   0]   data_get4_2              ; 
wire                  valid_get5_2             ; 
wire    [  31:   0]   data_get5_2              ; 
wire                  valid_get6_2             ; 
wire    [  31:   0]   data_get6_2              ; 
wire                  valid_get7_2             ; 
wire    [  31:   0]   data_get7_2              ; 


arstn2rst U_arstn2rst(
    .clk                  (clk                    ), // Clock
    .arst_n               (arst_n                 ), // Asynchronous reset active low
    .rst                  (rst                    )
);

CTRL U_CTRL(
    .clk                  (clk                    ),
    .rst                  (rst                    ),
    .BRAM_CTRL_addr       (BRAM_CTRL_addr         ),
    .BRAM_CTRL_clk        (BRAM_CTRL_clk          ),
    .BRAM_CTRL_wrdata     (BRAM_CTRL_wrdata       ),
    .BRAM_CTRL_rddata     (BRAM_CTRL_rddata       ),
    .BRAM_CTRL_en         (BRAM_CTRL_en           ),
    .BRAM_CTRL_rst        (BRAM_CTRL_rst          ),
    .BRAM_CTRL_we         (BRAM_CTRL_we           ),
    .M                    (M                      ),
    .N                    (N                      ),
    .P                    (P                      ),
    .reshape_start        (reshape_start          ),
    .FM_reshape_finish    (FM_reshape_finish      ),
    .WM_reshape_finish    (WM_reshape_finish      ),
    .sub_P                (sub_P                  ),
    .sub_M                (sub_M                  ),
    .subFM_addr           (subFM_addr             ),
    .subFM_incr           (subFM_incr             ),
    .subWM_addr           (subWM_addr             ),
    .subWM_incr           (subWM_incr             ),
    .submulti_start       (submulti_start         ),
    .submulti_finish      (submulti_finish        ),
    .Ma                   (Ma                     ),
    .Pa                   (Pa                     ),
    .out_start            (out_start              ),
    .out_finish           (out_finish             )
);

FM_reshape U_FM_reshape(
    .clk                  (clk                    ),
    .rst                  (rst                    ),
    .BRAM_FM32_addr       (BRAM_FM32_addr         ),
    .BRAM_FM32_clk        (BRAM_FM32_clk          ),
    .BRAM_FM32_wrdata     (BRAM_FM32_wrdata       ),
    .BRAM_FM32_rddata     (BRAM_FM32_rddata       ),
    .BRAM_FM32_en         (BRAM_FM32_en           ),
    .BRAM_FM32_rst        (BRAM_FM32_rst          ),
    .BRAM_FM32_we         (BRAM_FM32_we           ),
    .M                    (M                      ),
    .N                    (N                      ),
    .reshape_start        (reshape_start          ),
    .FM_reshape_finish    (FM_reshape_finish      ),
    .BRAM_FM64_waddr      (BRAM_FM64_waddr        ),
    .BRAM_FM64_wrdata     (BRAM_FM64_wrdata       ),
    .BRAM_FM64_we         (BRAM_FM64_we           )
);

WM_reshape U_WM_reshape(
    .clk                  (clk                    ),
    .rst                  (rst                    ),
    .BRAM_WM32_addr       (BRAM_WM32_addr         ),
    .BRAM_WM32_clk        (BRAM_WM32_clk          ),
    .BRAM_WM32_wrdata     (BRAM_WM32_wrdata       ),
    .BRAM_WM32_rddata     (BRAM_WM32_rddata       ),
    .BRAM_WM32_en         (BRAM_WM32_en           ),
    .BRAM_WM32_rst        (BRAM_WM32_rst          ),
    .BRAM_WM32_we         (BRAM_WM32_we           ),
    .P                    (P                      ),
    .N                    (N                      ),
    .reshape_start        (reshape_start          ),
    .WM_reshape_finish    (WM_reshape_finish      ),
    .BRAM_WM128_waddr     (BRAM_WM128_waddr       ),
    .BRAM_WM128_wrdata    (BRAM_WM128_wrdata      ),
    .BRAM_WM128_we        (BRAM_WM128_we          )
);

BRAM_FM_64b U_BRAM_FM_64b(
  .clka(clk),    // input wire clka
  .wea(BRAM_FM64_we),      // input wire [0 : 0] wea
  .addra(BRAM_FM64_waddr[11:0]),  // input wire [11 : 0] addra
  .dina(BRAM_FM64_wrdata),    // input wire [63 : 0] dina
  .clkb(clk),    // input wire clkb
  .addrb(BRAM_FM64_raddr[11:0]),  // input wire [11 : 0] addrb
  .doutb(BRAM_FM64_rddata)  // output wire [63 : 0] doutb
);

BRAM_WM_128b U_BRAM_WM_128b(
  .clka(clk),    // input wire clka
  .wea(BRAM_WM128_we),      // input wire [0 : 0] wea
  .addra(BRAM_WM128_waddr[12:0]),  // input wire [12 : 0] addra
  .dina(BRAM_WM128_wrdata),    // input wire [127 : 0] dina
  .clkb(clk),    // input wire clkb
  .addrb(BRAM_WM128_raddr[12:0]),  // input wire [12 : 0] addrb
  .doutb(BRAM_WM128_rddata)  // output wire [127 : 0] doutb
);

Multiply_ctrl U_Multiply_ctrl(
    .clk                  (clk                    ),
    .rst                  (rst                    ),
    .sub_M                (sub_M                  ),
    .sub_P                (sub_P                  ),
    .N                    (N                      ),
    .subFM_addr           (subFM_addr             ),
    .subFM_incr           (subFM_incr             ),
    .subWM_addr           (subWM_addr             ),
    .subWM_incr           (subWM_incr             ),
    .submulti_start       (submulti_start         ),
    .submulti_finish      (submulti_finish        ),
    .BRAM_FM64_raddr      (BRAM_FM64_raddr        ),
    .BRAM_FM64_rddata     (BRAM_FM64_rddata       ),
    .BRAM_WM128_raddr     (BRAM_WM128_raddr       ),
    .BRAM_WM128_rddata    (BRAM_WM128_rddata      ),
    .fvalid               (fvalid                 ),
    .wvalid               (wvalid                 ),
    .fdata                (fdata                  ),
    .wdata                (wdata                  ),
    .num_valid            (num_valid              ),
    .num_ori              (num_ori                ),
    .sub_scale_M1         (sub_scale_M1           ),
    .sub_scale_P1         (sub_scale_P1           ),
    .sub_scale_M2         (sub_scale_M2           ),
    .sub_scale_P2         (sub_scale_P2           ),
    .align_fifo_get_all1  (align_fifo_get_all1    ),
    .align_fifo_get_all2  (align_fifo_get_all2    )
);

Input_align U_Input_align1(
    .clk                  (clk                    ),
    .rst                  (rst                    ), // input 
    .fvalid0              (fvalid[0]              ), // input 
    .fdata0               (fdata[7:0]             ), // input [7:0] 
    .fvalid1              (fvalid[1]              ), // input 
    .fdata1               (fdata[15:8]            ), // input [7:0] 
    .fvalid2              (fvalid[2]              ), // input 
    .fdata2               (fdata[23:16]           ), // input [7:0] 
    .fvalid3              (fvalid[3]              ), // input 
    .fdata3               (fdata[31:24]           ), // input [7:0] 
    .fvalid4              (fvalid[4]              ), // input 
    .fdata4               (fdata[39:32]           ), // input [7:0] 
    .fvalid5              (fvalid[5]              ), // input 
    .fdata5               (fdata[47:40]           ), // input [7:0] 
    .fvalid6              (fvalid[6]              ), // input 
    .fdata6               (fdata[55:48]           ), // input [7:0] 
    .fvalid7              (fvalid[7]              ), // input 
    .fdata7               (fdata[63:56]           ), // input [7:0] 
    .wvalid0              (wvalid[0]              ), // input 
    .wdata0               (wdata[7:0]             ), // input [7:0] 
    .wvalid1              (wvalid[1]              ), // input 
    .wdata1               (wdata[15:8]            ), // input [7:0] 
    .wvalid2              (wvalid[2]              ), // input 
    .wdata2               (wdata[23:16]           ), // input [7:0] 
    .wvalid3              (wvalid[3]              ), // input 
    .wdata3               (wdata[31:24]           ), // input [7:0] 
    .wvalid4              (wvalid[4]              ), // input 
    .wdata4               (wdata[39:32]           ), // input [7:0] 
    .wvalid5              (wvalid[5]              ), // input 
    .wdata5               (wdata[47:40]           ), // input [7:0] 
    .wvalid6              (wvalid[6]              ), // input 
    .wdata6               (wdata[55:48]           ), // input [7:0] 
    .wvalid7              (wvalid[7]              ), // input 
    .wdata7               (wdata[63:56]           ), // input [7:0] 
    .ali_fvalid0          (ali_fvalid0_1          ), // output 
    .ali_fdata0           (ali_fdata0_1           ), // output [7:0] 
    .ali_fvalid1          (ali_fvalid1_1          ), // output 
    .ali_fdata1           (ali_fdata1_1           ), // output [7:0] 
    .ali_fvalid2          (ali_fvalid2_1          ), // output 
    .ali_fdata2           (ali_fdata2_1           ), // output [7:0] 
    .ali_fvalid3          (ali_fvalid3_1          ), // output 
    .ali_fdata3           (ali_fdata3_1           ), // output [7:0] 
    .ali_fvalid4          (ali_fvalid4_1          ), // output 
    .ali_fdata4           (ali_fdata4_1           ), // output [7:0] 
    .ali_fvalid5          (ali_fvalid5_1          ), // output 
    .ali_fdata5           (ali_fdata5_1           ), // output [7:0] 
    .ali_fvalid6          (ali_fvalid6_1          ), // output 
    .ali_fdata6           (ali_fdata6_1           ), // output [7:0] 
    .ali_fvalid7          (ali_fvalid7_1          ), // output 
    .ali_fdata7           (ali_fdata7_1           ), // output [7:0] 
    .ali_wvalid0          (ali_wvalid0_1          ), // output 
    .ali_wdata0           (ali_wdata0_1           ), // output [7:0] 
    .ali_wvalid1          (ali_wvalid1_1          ), // output 
    .ali_wdata1           (ali_wdata1_1           ), // output [7:0] 
    .ali_wvalid2          (ali_wvalid2_1          ), // output 
    .ali_wdata2           (ali_wdata2_1           ), // output [7:0] 
    .ali_wvalid3          (ali_wvalid3_1          ), // output 
    .ali_wdata3           (ali_wdata3_1           ), // output [7:0] 
    .ali_wvalid4          (ali_wvalid4_1          ), // output 
    .ali_wdata4           (ali_wdata4_1           ), // output [7:0] 
    .ali_wvalid5          (ali_wvalid5_1          ), // output 
    .ali_wdata5           (ali_wdata5_1           ), // output [7:0] 
    .ali_wvalid6          (ali_wvalid6_1          ), // output 
    .ali_wdata6           (ali_wdata6_1           ), // output [7:0] 
    .ali_wvalid7          (ali_wvalid7_1          ), // output 
    .ali_wdata7           (ali_wdata7_1           )  // output [7:0]
);

Input_align U_Input_align2(
    .clk                  (clk                    ),
    .rst                  (rst                    ), // input 
    .fvalid0              (fvalid[0]              ), // input 
    .fdata0               (fdata[7:0]             ), // input [7:0] 
    .fvalid1              (fvalid[1]              ), // input 
    .fdata1               (fdata[15:8]            ), // input [7:0] 
    .fvalid2              (fvalid[2]              ), // input 
    .fdata2               (fdata[23:16]           ), // input [7:0] 
    .fvalid3              (fvalid[3]              ), // input 
    .fdata3               (fdata[31:24]           ), // input [7:0] 
    .fvalid4              (fvalid[4]              ), // input 
    .fdata4               (fdata[39:32]           ), // input [7:0] 
    .fvalid5              (fvalid[5]              ), // input 
    .fdata5               (fdata[47:40]           ), // input [7:0] 
    .fvalid6              (fvalid[6]              ), // input 
    .fdata6               (fdata[55:48]           ), // input [7:0] 
    .fvalid7              (fvalid[7]              ), // input 
    .fdata7               (fdata[63:56]           ), // input [7:0] 
    .wvalid0              (wvalid[0]              ), // input 
    .wdata0               (wdata[71:64]           ), // input [7:0] 
    .wvalid1              (wvalid[1]              ), // input 
    .wdata1               (wdata[79:72]           ), // input [7:0] 
    .wvalid2              (wvalid[2]              ), // input 
    .wdata2               (wdata[87:80]           ), // input [7:0] 
    .wvalid3              (wvalid[3]              ), // input 
    .wdata3               (wdata[95:88]           ), // input [7:0] 
    .wvalid4              (wvalid[4]              ), // input 
    .wdata4               (wdata[103:96]          ), // input [7:0] 
    .wvalid5              (wvalid[5]              ), // input 
    .wdata5               (wdata[111:104]         ), // input [7:0] 
    .wvalid6              (wvalid[6]              ), // input 
    .wdata6               (wdata[119:112]         ), // input [7:0] 
    .wvalid7              (wvalid[7]              ), // input 
    .wdata7               (wdata[127:120]         ), // input [7:0] 
    .ali_fvalid0          (ali_fvalid0_2          ), // output 
    .ali_fdata0           (ali_fdata0_2           ), // output [7:0] 
    .ali_fvalid1          (ali_fvalid1_2          ), // output 
    .ali_fdata1           (ali_fdata1_2           ), // output [7:0] 
    .ali_fvalid2          (ali_fvalid2_2          ), // output 
    .ali_fdata2           (ali_fdata2_2           ), // output [7:0] 
    .ali_fvalid3          (ali_fvalid3_2          ), // output 
    .ali_fdata3           (ali_fdata3_2           ), // output [7:0] 
    .ali_fvalid4          (ali_fvalid4_2          ), // output 
    .ali_fdata4           (ali_fdata4_2           ), // output [7:0] 
    .ali_fvalid5          (ali_fvalid5_2          ), // output 
    .ali_fdata5           (ali_fdata5_2           ), // output [7:0] 
    .ali_fvalid6          (ali_fvalid6_2          ), // output 
    .ali_fdata6           (ali_fdata6_2           ), // output [7:0] 
    .ali_fvalid7          (ali_fvalid7_2          ), // output 
    .ali_fdata7           (ali_fdata7_2           ), // output [7:0] 
    .ali_wvalid0          (ali_wvalid0_2          ), // output 
    .ali_wdata0           (ali_wdata0_2           ), // output [7:0] 
    .ali_wvalid1          (ali_wvalid1_2          ), // output 
    .ali_wdata1           (ali_wdata1_2           ), // output [7:0] 
    .ali_wvalid2          (ali_wvalid2_2          ), // output 
    .ali_wdata2           (ali_wdata2_2           ), // output [7:0] 
    .ali_wvalid3          (ali_wvalid3_2          ), // output 
    .ali_wdata3           (ali_wdata3_2           ), // output [7:0] 
    .ali_wvalid4          (ali_wvalid4_2          ), // output 
    .ali_wdata4           (ali_wdata4_2           ), // output [7:0] 
    .ali_wvalid5          (ali_wvalid5_2          ), // output 
    .ali_wdata5           (ali_wdata5_2           ), // output [7:0] 
    .ali_wvalid6          (ali_wvalid6_2          ), // output 
    .ali_wdata6           (ali_wdata6_2           ), // output [7:0] 
    .ali_wvalid7          (ali_wvalid7_2          ), // output 
    .ali_wdata7           (ali_wdata7_2           )  // output [7:0]
);

Multiply_8x8 U_Multiply_8x8_1(
    .clk                  (clk                    ), // input 
    .rst                  (rst                    ), // input 
    .fvalid0              (ali_fvalid0_1          ), // input 
    .fdata0               (ali_fdata0_1           ), // input signed [7:0] 
    .fvalid1              (ali_fvalid1_1          ), // input 
    .fdata1               (ali_fdata1_1           ), // input signed [7:0] 
    .fvalid2              (ali_fvalid2_1          ), // input 
    .fdata2               (ali_fdata2_1           ), // input signed [7:0] 
    .fvalid3              (ali_fvalid3_1          ), // input 
    .fdata3               (ali_fdata3_1           ), // input signed [7:0] 
    .fvalid4              (ali_fvalid4_1          ), // input 
    .fdata4               (ali_fdata4_1           ), // input signed [7:0] 
    .fvalid5              (ali_fvalid5_1          ), // input 
    .fdata5               (ali_fdata5_1           ), // input signed [7:0] 
    .fvalid6              (ali_fvalid6_1          ), // input 
    .fdata6               (ali_fdata6_1           ), // input signed [7:0] 
    .fvalid7              (ali_fvalid7_1          ), // input 
    .fdata7               (ali_fdata7_1           ), // input signed [7:0] 
    .wvalid0              (ali_wvalid0_1          ), // input 
    .wdata0               (ali_wdata0_1           ), // input signed [7:0] 
    .wvalid1              (ali_wvalid1_1          ), // input 
    .wdata1               (ali_wdata1_1           ), // input signed [7:0] 
    .wvalid2              (ali_wvalid2_1          ), // input 
    .wdata2               (ali_wdata2_1           ), // input signed [7:0] 
    .wvalid3              (ali_wvalid3_1          ), // input 
    .wdata3               (ali_wdata3_1           ), // input signed [7:0] 
    .wvalid4              (ali_wvalid4_1          ), // input 
    .wdata4               (ali_wdata4_1           ), // input signed [7:0] 
    .wvalid5              (ali_wvalid5_1          ), // input 
    .wdata5               (ali_wdata5_1           ), // input signed [7:0] 
    .wvalid6              (ali_wvalid6_1          ), // input 
    .wdata6               (ali_wdata6_1           ), // input signed [7:0] 
    .wvalid7              (ali_wvalid7_1          ), // input 
    .wdata7               (ali_wdata7_1           ), // input signed [7:0] 
    .num_valid_ori        (num_valid              ), // input 
    .num_ori              ({16'b0,num_ori}        ), // input [31:0] 
    .valid_o0             (valid_get0_1           ), // output 
    .data_o0              (data_get0_1            ), // output signed [31:0] 
    .valid_o1             (valid_get1_1           ), // output 
    .data_o1              (data_get1_1            ), // output signed [31:0] 
    .valid_o2             (valid_get2_1           ), // output 
    .data_o2              (data_get2_1            ), // output signed [31:0] 
    .valid_o3             (valid_get3_1           ), // output 
    .data_o3              (data_get3_1            ), // output signed [31:0] 
    .valid_o4             (valid_get4_1           ), // output 
    .data_o4              (data_get4_1            ), // output signed [31:0] 
    .valid_o5             (valid_get5_1           ), // output 
    .data_o5              (data_get5_1            ), // output signed [31:0] 
    .valid_o6             (valid_get6_1           ), // output 
    .data_o6              (data_get6_1            ), // output signed [31:0] 
    .valid_o7             (valid_get7_1           ), // output 
    .data_o7              (data_get7_1            )  // output signed [31:0]
);

Multiply_8x8 U_Multiply_8x8_2(
    .clk                  (clk                    ), // input 
    .rst                  (rst                    ), // input 
    .fvalid0              (ali_fvalid0_2          ), // input 
    .fdata0               (ali_fdata0_2           ), // input signed [7:0] 
    .fvalid1              (ali_fvalid1_2          ), // input 
    .fdata1               (ali_fdata1_2           ), // input signed [7:0] 
    .fvalid2              (ali_fvalid2_2          ), // input 
    .fdata2               (ali_fdata2_2           ), // input signed [7:0] 
    .fvalid3              (ali_fvalid3_2          ), // input 
    .fdata3               (ali_fdata3_2           ), // input signed [7:0] 
    .fvalid4              (ali_fvalid4_2          ), // input 
    .fdata4               (ali_fdata4_2           ), // input signed [7:0] 
    .fvalid5              (ali_fvalid5_2          ), // input 
    .fdata5               (ali_fdata5_2           ), // input signed [7:0] 
    .fvalid6              (ali_fvalid6_2          ), // input 
    .fdata6               (ali_fdata6_2           ), // input signed [7:0] 
    .fvalid7              (ali_fvalid7_2          ), // input 
    .fdata7               (ali_fdata7_2           ), // input signed [7:0] 
    .wvalid0              (ali_wvalid0_2          ), // input 
    .wdata0               (ali_wdata0_2           ), // input signed [7:0] 
    .wvalid1              (ali_wvalid1_2          ), // input 
    .wdata1               (ali_wdata1_2           ), // input signed [7:0] 
    .wvalid2              (ali_wvalid2_2          ), // input 
    .wdata2               (ali_wdata2_2           ), // input signed [7:0] 
    .wvalid3              (ali_wvalid3_2          ), // input 
    .wdata3               (ali_wdata3_2           ), // input signed [7:0] 
    .wvalid4              (ali_wvalid4_2          ), // input 
    .wdata4               (ali_wdata4_2           ), // input signed [7:0] 
    .wvalid5              (ali_wvalid5_2          ), // input 
    .wdata5               (ali_wdata5_2           ), // input signed [7:0] 
    .wvalid6              (ali_wvalid6_2          ), // input 
    .wdata6               (ali_wdata6_2           ), // input signed [7:0] 
    .wvalid7              (ali_wvalid7_2          ), // input 
    .wdata7               (ali_wdata7_2           ), // input signed [7:0] 
    .num_valid_ori        (num_valid              ), // input 
    .num_ori              ({16'b0,num_ori}        ), // input [31:0] 
    .valid_o0             (valid_get0_2           ), // output 
    .data_o0              (data_get0_2            ), // output signed [31:0] 
    .valid_o1             (valid_get1_2           ), // output 
    .data_o1              (data_get1_2            ), // output signed [31:0] 
    .valid_o2             (valid_get2_2           ), // output 
    .data_o2              (data_get2_2            ), // output signed [31:0] 
    .valid_o3             (valid_get3_2           ), // output 
    .data_o3              (data_get3_2            ), // output signed [31:0] 
    .valid_o4             (valid_get4_2           ), // output 
    .data_o4              (data_get4_2            ), // output signed [31:0] 
    .valid_o5             (valid_get5_2           ), // output 
    .data_o5              (data_get5_2            ), // output signed [31:0] 
    .valid_o6             (valid_get6_2           ), // output 
    .data_o6              (data_get6_2            ), // output signed [31:0] 
    .valid_o7             (valid_get7_2           ), // output 
    .data_o7              (data_get7_2            )  // output signed [31:0]
);

Align_fifo U_Align_fifo_1(
    .clk                  (clk                    ),
    .rst                  (rst                    ),
    .valid_get0           (valid_get0_1           ),
    .data_get0            (data_get0_1            ),
    .valid_get1           (valid_get1_1           ),
    .data_get1            (data_get1_1            ),
    .valid_get2           (valid_get2_1           ),
    .data_get2            (data_get2_1            ),
    .valid_get3           (valid_get3_1           ),
    .data_get3            (data_get3_1            ),
    .valid_get4           (valid_get4_1           ),
    .data_get4            (data_get4_1            ),
    .valid_get5           (valid_get5_1           ),
    .data_get5            (data_get5_1            ),
    .valid_get6           (valid_get6_1           ),
    .data_get6            (data_get6_1            ),
    .valid_get7           (valid_get7_1           ),
    .data_get7            (data_get7_1            ),
    .sub_scale_M          (sub_scale_M1           ),
    .sub_scale_P          (sub_scale_P1           ),
    .align_fifo_get_all   (align_fifo_get_all1    ),
    .out_ctrl_ready       (out_ctrl_ready1        ),
    .valid                (valid1                 ),
    .data                 (data1                  )
);

Align_fifo U_Align_fifo_2(
    .clk                  (clk                    ),
    .rst                  (rst                    ),
    .valid_get0           (valid_get0_2           ),
    .data_get0            (data_get0_2            ),
    .valid_get1           (valid_get1_2           ),
    .data_get1            (data_get1_2            ),
    .valid_get2           (valid_get2_2           ),
    .data_get2            (data_get2_2            ),
    .valid_get3           (valid_get3_2           ),
    .data_get3            (data_get3_2            ),
    .valid_get4           (valid_get4_2           ),
    .data_get4            (data_get4_2            ),
    .valid_get5           (valid_get5_2           ),
    .data_get5            (data_get5_2            ),
    .valid_get6           (valid_get6_2           ),
    .data_get6            (data_get6_2            ),
    .valid_get7           (valid_get7_2           ),
    .data_get7            (data_get7_2            ),
    .sub_scale_M          (sub_scale_M2           ),
    .sub_scale_P          (sub_scale_P2           ),
    .align_fifo_get_all   (align_fifo_get_all2    ),
    .out_ctrl_ready       (out_ctrl_ready2        ),
    .valid                (valid2                 ),
    .data                 (data2                  )
);

Out_ctrl U_Out_ctrl(
    .clk                  (clk                    ),
    .rst                  (rst                    ),
    .BRAM_OUT_addr        (BRAM_OUT_addr          ),
    .BRAM_OUT_clk         (BRAM_OUT_clk           ),
    .BRAM_OUT_wrdata      (BRAM_OUT_wrdata        ),
    .BRAM_OUT_rddata      (BRAM_OUT_rddata        ),
    .BRAM_OUT_en          (BRAM_OUT_en            ),
    .BRAM_OUT_rst         (BRAM_OUT_rst           ),
    .BRAM_OUT_we          (BRAM_OUT_we            ),
    .P                    (P                      ),
    .Ma                   (Ma                     ),
    .Pa                   (Pa                     ),
    .sub_P                (sub_P                  ),
    .sub_M                (sub_M                  ),
    .out_start            (out_start              ),
    .out_finish           (out_finish             ),
    .out_ctrl_ready1      (out_ctrl_ready1        ),
    .out_ctrl_ready2      (out_ctrl_ready2        ),
    .valid1               (valid1                 ),
    .data1                (data1                  ),
    .valid2               (valid2                 ),
    .data2                (data2                  )
);

endmodule
