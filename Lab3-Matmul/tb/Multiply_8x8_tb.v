`timescale 1ns/1ps

module Multiply_8x8_tb();

reg clk;
reg rst;
reg fvalid0;
reg signed [7:0] fdata0;
reg fvalid1;
reg signed [7:0] fdata1;
reg fvalid2;
reg signed [7:0] fdata2;
reg fvalid3;
reg signed [7:0] fdata3;
reg fvalid4;
reg signed [7:0] fdata4;
reg fvalid5;
reg signed [7:0] fdata5;
reg fvalid6;
reg signed [7:0] fdata6;
reg fvalid7;
reg signed [7:0] fdata7;
reg wvalid0;
reg signed [7:0] wdata0;
reg wvalid1;
reg signed [7:0] wdata1;
reg wvalid2;
reg signed [7:0] wdata2;
reg wvalid3;
reg signed [7:0] wdata3;
reg wvalid4;
reg signed [7:0] wdata4;
reg wvalid5;
reg signed [7:0] wdata5;
reg wvalid6;
reg signed [7:0] wdata6;
reg wvalid7;
reg signed [7:0] wdata7;
reg num_valid_ori;
reg [31:0] num_ori;
wire valid_o0;
wire signed [31:0] data_o0;
wire valid_o1;
wire signed [31:0] data_o1;
wire valid_o2;
wire signed [31:0] data_o2;
wire valid_o3;
wire signed [31:0] data_o3;
wire valid_o4;
wire signed [31:0] data_o4;
wire valid_o5;
wire signed [31:0] data_o5;
wire valid_o6;
wire signed [31:0] data_o6;
wire valid_o7;
wire signed [31:0] data_o7;

initial begin
    clk = 1'b0;
    rst = 1'b1;
    # 10;
    rst = 1'b0;
    fvalid0 = 'b0;
    fdata0 = 'b0;
    fvalid1 = 'b0;
    fdata1 = 'b0;
    fvalid2 = 'b0;
    fdata2 = 'b0;
    fvalid3 = 'b0;
    fdata3 = 'b0;
    fvalid4 = 'b0;
    fdata4 = 'b0;
    fvalid5 = 'b0;
    fdata5 = 'b0;
    fvalid6 = 'b0;
    fdata6 = 'b0;
    fvalid7 = 'b0;
    fdata7 = 'b0;
    wvalid0 = 'b0;
    wdata0 = 'b0;
    wvalid1 = 'b0;
    wdata1 = 'b0;
    wvalid2 = 'b0;
    wdata2 = 'b0;
    wvalid3 = 'b0;
    wdata3 = 'b0;
    wvalid4 = 'b0;
    wdata4 = 'b0;
    wvalid5 = 'b0;
    wdata5 = 'b0;
    wvalid6 = 'b0;
    wdata6 = 'b0;
    wvalid7 = 'b0;
    wdata7 = 'b0;
    num_valid_ori = 'b0;
    num_ori = 'b0;
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    num_valid_ori = 'b1;
    num_ori = 'd9;
    @(posedge clk);
    num_valid_ori = 'b0;
end

always #5 clk = ~clk;

task setf;
input th_fvalid0;
input th_fvalid1;
input th_fvalid2;
input th_fvalid3;
input th_fvalid4;
input th_fvalid5;
input th_fvalid6;
input th_fvalid7;
input signed [7:0] th_fdata0;
input signed [7:0] th_fdata1;
input signed [7:0] th_fdata2;
input signed [7:0] th_fdata3;
input signed [7:0] th_fdata4;
input signed [7:0] th_fdata5;
input signed [7:0] th_fdata6;
input signed [7:0] th_fdata7;
begin
    @(posedge clk);
    fvalid0 = th_fvalid0;
    fdata0 = th_fdata0;
    fvalid1 = th_fvalid1;
    fdata1 = th_fdata1;
    fvalid2 = th_fvalid2;
    fdata2 = th_fdata2;
    fvalid3 = th_fvalid3;
    fdata3 = th_fdata3;
    fvalid4 = th_fvalid4;
    fdata4 = th_fdata4;
    fvalid5 = th_fvalid5;
    fdata5 = th_fdata5;
    fvalid6 = th_fvalid6;
    fdata6 = th_fdata6;
    fvalid7 = th_fvalid7;
    fdata7 = th_fdata7;
end
endtask
task setw;
input th_wvalid0;
input th_wvalid1;
input th_wvalid2;
input th_wvalid3;
input th_wvalid4;
input th_wvalid5;
input th_wvalid6;
input th_wvalid7;
input signed [7:0] th_wdata0;
input signed [7:0] th_wdata1;
input signed [7:0] th_wdata2;
input signed [7:0] th_wdata3;
input signed [7:0] th_wdata4;
input signed [7:0] th_wdata5;
input signed [7:0] th_wdata6;
input signed [7:0] th_wdata7;
begin
    @(posedge clk);
    wvalid0 = th_wvalid0;
    wdata0 = th_wdata0;
    wvalid1 = th_wvalid1;
    wdata1 = th_wdata1;
    wvalid2 = th_wvalid2;
    wdata2 = th_wdata2;
    wvalid3 = th_wvalid3;
    wdata3 = th_wdata3;
    wvalid4 = th_wvalid4;
    wdata4 = th_wdata4;
    wvalid5 = th_wvalid5;
    wdata5 = th_wdata5;
    wvalid6 = th_wvalid6;
    wdata6 = th_wdata6;
    wvalid7 = th_wvalid7;
    wdata7 = th_wdata7;
end
endtask

initial begin
    # 1000;
    @(posedge clk);
    setf(1,0,0,0,0,0,0,0, 111,   0,   0,   0,   0,   0,   0,   0);
    setf(1,1,0,0,0,0,0,0,  25,  63,   0,   0,   0,   0,   0,   0);
    setf(1,1,1,0,0,0,0,0,  32,  90,  39,   0,   0,   0,   0,   0);
    setf(1,1,1,1,0,0,0,0,  66, 102,  79,  18,   0,   0,   0,   0);
    setf(1,1,1,1,1,0,0,0,  12,  40,  12, 103,  52,   0,   0,   0);
    setf(1,1,1,1,1,1,0,0,  99,  73,  83,  86,  12,  50,   0,   0);
    setf(1,1,1,1,1,1,1,0,  28,  16, 112,  51,  52, 123,  12,   0);
    setf(1,1,1,1,1,1,1,1,  16,  53,  59, 104,   1,  90,  94,  74);
    setf(1,1,1,1,1,1,1,1,  95,  33,  34,  36,  95,  74,  55, 105);
    setf(0,1,1,1,1,1,1,1,   0,  27,  49, 105, 123,  99,  14, 111);
    setf(0,0,1,1,1,1,1,1,   0,   0,  57, 112,  34, 100, 115,  43);
    setf(0,0,0,1,1,1,1,1,   0,   0,   0,  58,  89,  95,  84,  63);
    setf(0,0,0,0,1,1,1,1,   0,   0,   0,   0,  11,  12, 110, 107);
    setf(0,0,0,0,0,1,1,1,   0,   0,   0,   0,   0,  97,  64, 111);
    setf(0,0,0,0,0,0,1,1,   0,   0,   0,   0,   0,   0,  18,  56);
    setf(0,0,0,0,0,0,0,1,   0,   0,   0,   0,   0,   0,   0,  15);
    setf(0,0,0,0,0,0,0,0,   0,   0,   0,   0,   0,   0,   0,   0);
    @(posedge clk);
    setf(1,0,0,0,0,0,0,0, 111,   0,   0,   0,   0,   0,   0,   0);
    setf(1,1,0,0,0,0,0,0,  25,  63,   0,   0,   0,   0,   0,   0);
    setf(1,1,1,0,0,0,0,0,  32, -90, -39,   0,   0,   0,   0,   0);
    setf(1,1,1,1,0,0,0,0,  66,-102, -79, -18,   0,   0,   0,   0);
    setf(1,1,1,1,1,0,0,0, -12,  40, -12, 103,  52,   0,   0,   0);
    setf(1,1,1,1,1,1,0,0, -99,  73, -83, -86, -12,  50,   0,   0);
    setf(1,1,1,1,1,1,1,0, -28,  16,-112, -51, -52, 123,  12,   0);
    setf(1,1,1,1,1,1,1,1,  16, -53,  59,-104,   1,  90, -94,  74);
    setf(1,1,1,1,1,1,1,1, -95, -33,  34,  36, -95, -74,  55,-105);
    setf(0,1,1,1,1,1,1,1,   0, -27, -49,-105,-123,  99, -14,-111);
    setf(0,0,1,1,1,1,1,1,   0,   0, -57, 112,  34, 100, 115, -43);
    setf(0,0,0,1,1,1,1,1,   0,   0,   0,  58, -89,  95,  84,  63);
    setf(0,0,0,0,1,1,1,1,   0,   0,   0,   0,  11, -12,-110, 107);
    setf(0,0,0,0,0,1,1,1,   0,   0,   0,   0,   0, -97,  64, 111);
    setf(0,0,0,0,0,0,1,1,   0,   0,   0,   0,   0,   0,  18,  56);
    setf(0,0,0,0,0,0,0,1,   0,   0,   0,   0,   0,   0,   0, -15);
    setf(0,0,0,0,0,0,0,0,   0,   0,   0,   0,   0,   0,   0,   0);
end

initial begin
    # 1000;
    @(posedge clk);
    setw(1,0,0,0,0,0,0,0,-116,   0,   0,   0,   0,   0,   0,   0);
    setw(1,1,0,0,0,0,0,0,  -2,  47,   0,   0,   0,   0,   0,   0);
    setw(1,1,1,0,0,0,0,0, -19,-109,  89,   0,   0,   0,   0,   0);
    setw(1,1,1,1,0,0,0,0,  20,-124,-103, -42,   0,   0,   0,   0);
    setw(1,1,1,1,1,0,0,0,-100,   4, 120, 114, -82,   0,   0,   0);
    setw(1,1,1,1,1,1,0,0,-103,-122, 108, -27, -47, -50,   0,   0);
    setw(1,1,1,1,1,1,1,0,  56,-110, -83,-118,  56,  29,  56,   0);
    setw(1,1,1,1,1,1,1,1, -68, -17,  34,  69, -24,  -6, -38,  35);
    setw(1,1,1,1,1,1,1,1,  78, -91, 109, -84, -38,  82,  46,  96);
    setw(0,1,1,1,1,1,1,1,   0,   5,  12, 103, -86,  38, -17,  85);
    setw(0,0,1,1,1,1,1,1,   0,   0, -53,-120, -50,  85, 124,  61);
    setw(0,0,0,1,1,1,1,1,   0,   0,   0,   7,  94, -20, -34,  98);
    setw(0,0,0,0,1,1,1,1,   0,   0,   0,   0,  37, -50, -56, -53);
    setw(0,0,0,0,0,1,1,1,   0,   0,   0,   0,   0, -75,  65,-117);
    setw(0,0,0,0,0,0,1,1,   0,   0,   0,   0,   0,   0,-102,-112);
    setw(0,0,0,0,0,0,0,1,   0,   0,   0,   0,   0,   0,   0, -60);
    setw(0,0,0,0,0,0,0,0,   0,   0,   0,   0,   0,   0,   0,   0);
    @(posedge clk);
    setw(1,0,0,0,0,0,0,0,-116,   0,   0,   0,   0,   0,   0,   0);
    setw(1,1,0,0,0,0,0,0,  -2,  47,   0,   0,   0,   0,   0,   0);
    setw(1,1,1,0,0,0,0,0, -19,-109,  89,   0,   0,   0,   0,   0);
    setw(1,1,1,1,0,0,0,0,  20,-124,-103, -42,   0,   0,   0,   0);
    setw(1,1,1,1,1,0,0,0,-100,   4, 120, 114, -82,   0,   0,   0);
    setw(1,1,1,1,1,1,0,0,-103,-122, 108, -27, -47, -50,   0,   0);
    setw(1,1,1,1,1,1,1,0,  56,-110, -83,-118,  56,  29,  56,   0);
    setw(1,1,1,1,1,1,1,1, -68, -17,  34,  69, -24,  -6, -38,  35);
    setw(1,1,1,1,1,1,1,1,  78, -91, 109, -84, -38,  82,  46,  96);
    setw(0,1,1,1,1,1,1,1,   0,   5,  12, 103, -86,  38, -17,  85);
    setw(0,0,1,1,1,1,1,1,   0,   0, -53,-120, -50,  85, 124,  61);
    setw(0,0,0,1,1,1,1,1,   0,   0,   0,   7,  94, -20, -34,  98);
    setw(0,0,0,0,1,1,1,1,   0,   0,   0,   0,  37, -50, -56, -53);
    setw(0,0,0,0,0,1,1,1,   0,   0,   0,   0,   0, -75,  65,-117);
    setw(0,0,0,0,0,0,1,1,   0,   0,   0,   0,   0,   0,-102,-112);
    setw(0,0,0,0,0,0,0,1,   0,   0,   0,   0,   0,   0,   0, -60);
    setw(0,0,0,0,0,0,0,0,   0,   0,   0,   0,   0,   0,   0,   0);
end


// [[ 111   25   32   66   12   99   28   16   95]
//  [  63   90  102   40   73   16   53   33   27]
//  [  39   79   12   83  112   59   34   49   57]
//  [  18  103   86   51  104   36  105  112   58]
//  [  52   12   52    1   95  123   34   89   11]
//  [  50  123   90   74   99  100   95   12   97]
//  [  12   94   55   14  115   84  110   64   18]
//  [  74  105  111   43   63  107  111   56   15]]
// [[-116   47   89  -42  -82  -50   56   35]
//  [  -2 -109 -103  114  -47   29  -38   96]
//  [ -19 -124  120  -27   56   -6   46   85]
//  [  20    4  108 -118  -24   82  -17   61]
//  [-100 -122  -83   69  -38   38  124   98]
//  [-103 -110   34  -84  -86   85  -34  -53]
//  [  56  -17  109  103  -50  -20  -56 -117]
//  [ -68  -91   12 -120   94  -50   65 -112]
//  [  78    5  -53    7   37  -75 -102  -60]]

// [[-15721 -15023  18851 -16323 -15420    781  -6480  -1808]
//  [-14744 -33772  12124   5521  -7343   1527   9051  16744]
//  [-17509 -32840   -279  -1957 -12546   8941   5672   9995]
//  [-14228 -49176   9128   4579  -2349    715   7339    914]
//  [-32483 -39050  10228 -13216  -9055   5628  15188  -4362]
//  [-14406 -47221  11114   8215 -19012   9082  -4550  11845]
//  [-19285 -47320   4613  11730 -13070   7704   6960    673]
//  [-23786 -47923  24120    968 -17146   7549   4597   5072]]




// [[ 111   25   32   66  -12  -99  -28   16  -95]
//  [  63  -90 -102   40   73   16  -53  -33  -27]
//  [ -39  -79  -12  -83 -112   59   34  -49  -57]
//  [ -18  103  -86  -51 -104   36 -105  112   58]
//  [  52  -12  -52    1  -95 -123   34  -89   11]
//  [  50  123   90  -74   99  100   95  -12  -97]
//  [  12  -94   55  -14  115   84 -110   64   18]
//  [  74 -105 -111  -43   63  107  111   56  -15]]
// [[-116   47   89  -42  -82  -50   56   35]
//  [  -2 -109 -103  114  -47   29  -38   96]
//  [ -19 -124  120  -27   56   -6   46   85]
//  [  20    4  108 -118  -24   82  -17   61]
//  [-100 -122  -83   69  -38   38  124   98]
//  [-103 -110   34  -84  -86   85  -34  -53]
//  [  56  -17  109  103  -50  -20  -56 -117]
//  [ -68  -91   12 -120   94  -50   65 -112]
//  [  78    5  -53    7   37  -75 -102  -60]]

// [[-10883   9687  18077  -8445  -1710  -1591  19792  24286]
//  [-16168  18682  -3300 -12867 -13209   7001  13661   5158]
//  [  9163  18704  11703   -951  -1002   -271 -13492 -24205]
//  [   216  -1002 -31358 -13211  11823  -8521 -14887 -17002]
//  [ 25983  42900   5490  15770  -2107 -13674 -15450  -1152]
//  [-30866 -46599   5124  27201 -24894  12696  16194  17145]
//  [-31789 -23200  -3027 -29058   7438   4356  26900   6657]
//  [-23208   2001  11412  -7040 -18754  -2011   6887 -37404]]


Multiply_8x8 U_Multiply_8x8(
    .clk                  (clk                    ), // input 
    .rst                  (rst                    ), // input 
    .fvalid0              (fvalid0                ), // input 
    .fdata0               (fdata0                 ), // input signed [7:0] 
    .fvalid1              (fvalid1                ), // input 
    .fdata1               (fdata1                 ), // input signed [7:0] 
    .fvalid2              (fvalid2                ), // input 
    .fdata2               (fdata2                 ), // input signed [7:0] 
    .fvalid3              (fvalid3                ), // input 
    .fdata3               (fdata3                 ), // input signed [7:0] 
    .fvalid4              (fvalid4                ), // input 
    .fdata4               (fdata4                 ), // input signed [7:0] 
    .fvalid5              (fvalid5                ), // input 
    .fdata5               (fdata5                 ), // input signed [7:0] 
    .fvalid6              (fvalid6                ), // input 
    .fdata6               (fdata6                 ), // input signed [7:0] 
    .fvalid7              (fvalid7                ), // input 
    .fdata7               (fdata7                 ), // input signed [7:0] 
    .wvalid0              (wvalid0                ), // input 
    .wdata0               (wdata0                 ), // input signed [7:0] 
    .wvalid1              (wvalid1                ), // input 
    .wdata1               (wdata1                 ), // input signed [7:0] 
    .wvalid2              (wvalid2                ), // input 
    .wdata2               (wdata2                 ), // input signed [7:0] 
    .wvalid3              (wvalid3                ), // input 
    .wdata3               (wdata3                 ), // input signed [7:0] 
    .wvalid4              (wvalid4                ), // input 
    .wdata4               (wdata4                 ), // input signed [7:0] 
    .wvalid5              (wvalid5                ), // input 
    .wdata5               (wdata5                 ), // input signed [7:0] 
    .wvalid6              (wvalid6                ), // input 
    .wdata6               (wdata6                 ), // input signed [7:0] 
    .wvalid7              (wvalid7                ), // input 
    .wdata7               (wdata7                 ), // input signed [7:0] 
    .num_valid_ori        (num_valid_ori          ), // input 
    .num_ori              (num_ori                ), // input [31:0] 
    .valid_o0             (valid_o0               ), // output 
    .data_o0              (data_o0                ), // output signed [31:0] 
    .valid_o1             (valid_o1               ), // output 
    .data_o1              (data_o1                ), // output signed [31:0] 
    .valid_o2             (valid_o2               ), // output 
    .data_o2              (data_o2                ), // output signed [31:0] 
    .valid_o3             (valid_o3               ), // output 
    .data_o3              (data_o3                ), // output signed [31:0] 
    .valid_o4             (valid_o4               ), // output 
    .data_o4              (data_o4                ), // output signed [31:0] 
    .valid_o5             (valid_o5               ), // output 
    .data_o5              (data_o5                ), // output signed [31:0] 
    .valid_o6             (valid_o6               ), // output 
    .data_o6              (data_o6                ), // output signed [31:0] 
    .valid_o7             (valid_o7               ), // output 
    .data_o7              (data_o7                )  // output signed [31:0]
);



endmodule