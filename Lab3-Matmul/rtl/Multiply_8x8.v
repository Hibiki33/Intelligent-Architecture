module Multiply_8x8(
    input clk,
    input rst,
    input fvalid0,
    input [7:0] fdata0,
    input fvalid1,
    input [7:0] fdata1,
    input fvalid2,
    input [7:0] fdata2,
    input fvalid3,
    input [7:0] fdata3,
    input fvalid4,
    input [7:0] fdata4,
    input fvalid5,
    input [7:0] fdata5,
    input fvalid6,
    input [7:0] fdata6,
    input fvalid7,
    input [7:0] fdata7,
    input wvalid0,
    input signed [7:0] wdata0,
    input wvalid1,
    input signed [7:0] wdata1,
    input wvalid2,
    input signed [7:0] wdata2,
    input wvalid3,
    input signed [7:0] wdata3,
    input wvalid4,
    input signed [7:0] wdata4,
    input wvalid5,
    input signed [7:0] wdata5,
    input wvalid6,
    input signed [7:0] wdata6,
    input wvalid7,
    input signed [7:0] wdata7,
    input num_valid_ori,
    input [31:0] num_ori,
    output valid_o0,
    output signed [31:0] data_o0,
    output valid_o1,
    output signed [31:0] data_o1,
    output valid_o2,
    output signed [31:0] data_o2,
    output valid_o3,
    output signed [31:0] data_o3,
    output valid_o4,
    output signed [31:0] data_o4,
    output valid_o5,
    output signed [31:0] data_o5,
    output valid_o6,
    output signed [31:0] data_o6,
    output valid_o7,
    output signed [31:0] data_o7
    );

wire    [  63:   0]   num_valid                ; 
wire    [  31:   0]   num           [63:0]     ;            
wire    [  63:   0]   num_valid_r              ; 
wire    [  31:   0]   num_r         [63:0]     ; 
wire    [  63:   0]   w_valid                  ; 
wire    [   7:   0]   w_data        [63:0]     ;          
wire    [  63:   0]   w_valid_r                ; 
wire    [   7:   0]   w_data_r      [63:0]     ;         
wire    [  63:   0]   f_valid                  ; 
wire    [   7:   0]   f_data        [63:0]     ;          
wire    [  63:   0]   f_valid_r                ; 
wire    [   7:   0]   f_data_r      [63:0]     ;         
wire    [  63:   0]   valid_l                  ; 
wire    [  31:   0]   data_l        [63:0]     ;          
wire    [  63:   0]   valid_o                  ; 
wire    [  31:   0]   data_o        [63:0]     ;           

// -------PE矩阵编号-------
//  0  1  2  3  4  5  6  7 
//  8  9 10 11 12 13 14 15 
// 16 17 18 19 20 21 22 23 
// 24 25 26 27 28 29 30 31 
// 32 33 34 35 36 37 38 39 
// 40 41 42 43 44 45 46 47 
// 48 49 50 51 52 53 54 55 
// 56 57 58 59 60 61 62 63 

assign num_valid[0] = num_valid_ori;
assign num_valid[1] = num_valid_r[0];
assign num_valid[2] = num_valid_r[1];
assign num_valid[3] = num_valid_r[2];
assign num_valid[4] = num_valid_r[3];
assign num_valid[5] = num_valid_r[4];
assign num_valid[6] = num_valid_r[5];
assign num_valid[7] = num_valid_r[6];
assign num_valid[8] = num_valid_r[0];
assign num_valid[9] = num_valid_r[8];
assign num_valid[10] = num_valid_r[9];
assign num_valid[11] = num_valid_r[10];
assign num_valid[12] = num_valid_r[11];
assign num_valid[13] = num_valid_r[12];
assign num_valid[14] = num_valid_r[13];
assign num_valid[15] = num_valid_r[14];
assign num_valid[16] = num_valid_r[8];
assign num_valid[17] = num_valid_r[16];
assign num_valid[18] = num_valid_r[17];
assign num_valid[19] = num_valid_r[18];
assign num_valid[20] = num_valid_r[19];
assign num_valid[21] = num_valid_r[20];
assign num_valid[22] = num_valid_r[21];
assign num_valid[23] = num_valid_r[22];
assign num_valid[24] = num_valid_r[16];
assign num_valid[25] = num_valid_r[24];
assign num_valid[26] = num_valid_r[25];
assign num_valid[27] = num_valid_r[26];
assign num_valid[28] = num_valid_r[27];
assign num_valid[29] = num_valid_r[28];
assign num_valid[30] = num_valid_r[29];
assign num_valid[31] = num_valid_r[30];
assign num_valid[32] = num_valid_r[24];
assign num_valid[33] = num_valid_r[32];
assign num_valid[34] = num_valid_r[33];
assign num_valid[35] = num_valid_r[34];
assign num_valid[36] = num_valid_r[35];
assign num_valid[37] = num_valid_r[36];
assign num_valid[38] = num_valid_r[37];
assign num_valid[39] = num_valid_r[38];
assign num_valid[40] = num_valid_r[32];
assign num_valid[41] = num_valid_r[40];
assign num_valid[42] = num_valid_r[41];
assign num_valid[43] = num_valid_r[42];
assign num_valid[44] = num_valid_r[43];
assign num_valid[45] = num_valid_r[44];
assign num_valid[46] = num_valid_r[45];
assign num_valid[47] = num_valid_r[46];
assign num_valid[48] = num_valid_r[40];
assign num_valid[49] = num_valid_r[48];
assign num_valid[50] = num_valid_r[49];
assign num_valid[51] = num_valid_r[50];
assign num_valid[52] = num_valid_r[51];
assign num_valid[53] = num_valid_r[52];
assign num_valid[54] = num_valid_r[53];
assign num_valid[55] = num_valid_r[54];
assign num_valid[56] = num_valid_r[48];
assign num_valid[57] = num_valid_r[56];
assign num_valid[58] = num_valid_r[57];
assign num_valid[59] = num_valid_r[58];
assign num_valid[60] = num_valid_r[59];
assign num_valid[61] = num_valid_r[60];
assign num_valid[62] = num_valid_r[61];
assign num_valid[63] = num_valid_r[62];

assign num[0] = num_ori;
assign num[1] = num_r[0];
assign num[2] = num_r[1]; 
assign num[3] = num_r[2];
assign num[4] = num_r[3];
assign num[5] = num_r[4];
assign num[6] = num_r[5];
assign num[7] = num_r[6];
assign num[8] = num_r[0];
assign num[9] = num_r[8];
assign num[10] = num_r[9];
assign num[11] = num_r[10];
assign num[12] = num_r[11];
assign num[13] = num_r[12];
assign num[14] = num_r[13];
assign num[15] = num_r[14];
assign num[16] = num_r[8];
assign num[17] = num_r[16];
assign num[18] = num_r[17];
assign num[19] = num_r[18];
assign num[20] = num_r[19];
assign num[21] = num_r[20];
assign num[22] = num_r[21];
assign num[23] = num_r[22];
assign num[24] = num_r[16];
assign num[25] = num_r[24];
assign num[26] = num_r[25];
assign num[27] = num_r[26];
assign num[28] = num_r[27];
assign num[29] = num_r[28];
assign num[30] = num_r[29];
assign num[31] = num_r[30];
assign num[32] = num_r[24];
assign num[33] = num_r[32];
assign num[34] = num_r[33];
assign num[35] = num_r[34];
assign num[36] = num_r[35];
assign num[37] = num_r[36];
assign num[38] = num_r[37];
assign num[39] = num_r[38];
assign num[40] = num_r[32];
assign num[41] = num_r[40];
assign num[42] = num_r[41];
assign num[43] = num_r[42];
assign num[44] = num_r[43];
assign num[45] = num_r[44];
assign num[46] = num_r[45];
assign num[47] = num_r[46];
assign num[48] = num_r[40];
assign num[49] = num_r[48];
assign num[50] = num_r[49];
assign num[51] = num_r[50];
assign num[52] = num_r[51];
assign num[53] = num_r[52];
assign num[54] = num_r[53];
assign num[55] = num_r[54];
assign num[56] = num_r[48];
assign num[57] = num_r[56];
assign num[58] = num_r[57];
assign num[59] = num_r[58];
assign num[60] = num_r[59];
assign num[61] = num_r[60];
assign num[62] = num_r[61];
assign num[63] = num_r[62];

assign w_valid[0] = wvalid0;
assign w_valid[1] = wvalid1;
assign w_valid[2] = wvalid2;
assign w_valid[3] = wvalid3;
assign w_valid[4] = wvalid4;
assign w_valid[5] = wvalid5;
assign w_valid[6] = wvalid6;
assign w_valid[7] = wvalid7;
assign w_valid[8] = w_valid_r[0];
assign w_valid[9] = w_valid_r[1];
assign w_valid[10] = w_valid_r[2];
assign w_valid[11] = w_valid_r[3];
assign w_valid[12] = w_valid_r[4];
assign w_valid[13] = w_valid_r[5];
assign w_valid[14] = w_valid_r[6];
assign w_valid[15] = w_valid_r[7];
assign w_valid[16] = w_valid_r[8];
assign w_valid[17] = w_valid_r[9];
assign w_valid[18] = w_valid_r[10];
assign w_valid[19] = w_valid_r[11];
assign w_valid[20] = w_valid_r[12];
assign w_valid[21] = w_valid_r[13];
assign w_valid[22] = w_valid_r[14];
assign w_valid[23] = w_valid_r[15];
assign w_valid[24] = w_valid_r[16];
assign w_valid[25] = w_valid_r[17];
assign w_valid[26] = w_valid_r[18];
assign w_valid[27] = w_valid_r[19];
assign w_valid[28] = w_valid_r[20];
assign w_valid[29] = w_valid_r[21];
assign w_valid[30] = w_valid_r[22];
assign w_valid[31] = w_valid_r[23];
assign w_valid[32] = w_valid_r[24];
assign w_valid[33] = w_valid_r[25];
assign w_valid[34] = w_valid_r[26];
assign w_valid[35] = w_valid_r[27];
assign w_valid[36] = w_valid_r[28];
assign w_valid[37] = w_valid_r[29];
assign w_valid[38] = w_valid_r[30];
assign w_valid[39] = w_valid_r[31];
assign w_valid[40] = w_valid_r[32];
assign w_valid[41] = w_valid_r[33];
assign w_valid[42] = w_valid_r[34];
assign w_valid[43] = w_valid_r[35];
assign w_valid[44] = w_valid_r[36];
assign w_valid[45] = w_valid_r[37];
assign w_valid[46] = w_valid_r[38];
assign w_valid[47] = w_valid_r[39];
assign w_valid[48] = w_valid_r[40];
assign w_valid[49] = w_valid_r[41];
assign w_valid[50] = w_valid_r[42];
assign w_valid[51] = w_valid_r[43];
assign w_valid[52] = w_valid_r[44];
assign w_valid[53] = w_valid_r[45];
assign w_valid[54] = w_valid_r[46];
assign w_valid[55] = w_valid_r[47];
assign w_valid[56] = w_valid_r[48];
assign w_valid[57] = w_valid_r[49];
assign w_valid[58] = w_valid_r[50];
assign w_valid[59] = w_valid_r[51];
assign w_valid[60] = w_valid_r[52];
assign w_valid[61] = w_valid_r[53];
assign w_valid[62] = w_valid_r[54];
assign w_valid[63] = w_valid_r[55];

assign w_data[0] = wdata0;
assign w_data[1] = wdata1;
assign w_data[2] = wdata2;
assign w_data[3] = wdata3;
assign w_data[4] = wdata4;
assign w_data[5] = wdata5;
assign w_data[6] = wdata6;
assign w_data[7] = wdata7;
assign w_data[8] = w_data_r[0];
assign w_data[9] = w_data_r[1];
assign w_data[10] = w_data_r[2];
assign w_data[11] = w_data_r[3];
assign w_data[12] = w_data_r[4];
assign w_data[13] = w_data_r[5];
assign w_data[14] = w_data_r[6];
assign w_data[15] = w_data_r[7];
assign w_data[16] = w_data_r[8];
assign w_data[17] = w_data_r[9];
assign w_data[18] = w_data_r[10];
assign w_data[19] = w_data_r[11];
assign w_data[20] = w_data_r[12];
assign w_data[21] = w_data_r[13];
assign w_data[22] = w_data_r[14];
assign w_data[23] = w_data_r[15];
assign w_data[24] = w_data_r[16];
assign w_data[25] = w_data_r[17];
assign w_data[26] = w_data_r[18];
assign w_data[27] = w_data_r[19];
assign w_data[28] = w_data_r[20];
assign w_data[29] = w_data_r[21];
assign w_data[30] = w_data_r[22];
assign w_data[31] = w_data_r[23];
assign w_data[32] = w_data_r[24];
assign w_data[33] = w_data_r[25];
assign w_data[34] = w_data_r[26];
assign w_data[35] = w_data_r[27];
assign w_data[36] = w_data_r[28];
assign w_data[37] = w_data_r[29];
assign w_data[38] = w_data_r[30];
assign w_data[39] = w_data_r[31];
assign w_data[40] = w_data_r[32];
assign w_data[41] = w_data_r[33];
assign w_data[42] = w_data_r[34];
assign w_data[43] = w_data_r[35];
assign w_data[44] = w_data_r[36];
assign w_data[45] = w_data_r[37];
assign w_data[46] = w_data_r[38];
assign w_data[47] = w_data_r[39];
assign w_data[48] = w_data_r[40];
assign w_data[49] = w_data_r[41];
assign w_data[50] = w_data_r[42];
assign w_data[51] = w_data_r[43];
assign w_data[52] = w_data_r[44];
assign w_data[53] = w_data_r[45];
assign w_data[54] = w_data_r[46];
assign w_data[55] = w_data_r[47];
assign w_data[56] = w_data_r[48];
assign w_data[57] = w_data_r[49];
assign w_data[58] = w_data_r[50];
assign w_data[59] = w_data_r[51];
assign w_data[60] = w_data_r[52];
assign w_data[61] = w_data_r[53];
assign w_data[62] = w_data_r[54];
assign w_data[63] = w_data_r[55];

assign f_valid[0] = fvalid0;
assign f_valid[1] = f_valid_r[0];
assign f_valid[2] = f_valid_r[1];
assign f_valid[3] = f_valid_r[2];
assign f_valid[4] = f_valid_r[3];
assign f_valid[5] = f_valid_r[4];
assign f_valid[6] = f_valid_r[5];
assign f_valid[7] = f_valid_r[6];
assign f_valid[8] = fvalid1;
assign f_valid[9] = f_valid_r[8];
assign f_valid[10] = f_valid_r[9];
assign f_valid[11] = f_valid_r[10];
assign f_valid[12] = f_valid_r[11];
assign f_valid[13] = f_valid_r[12];
assign f_valid[14] = f_valid_r[13];
assign f_valid[15] = f_valid_r[14];
assign f_valid[16] = fvalid2;
assign f_valid[17] = f_valid_r[16];
assign f_valid[18] = f_valid_r[17];
assign f_valid[19] = f_valid_r[18];
assign f_valid[20] = f_valid_r[19];
assign f_valid[21] = f_valid_r[20];
assign f_valid[22] = f_valid_r[21];
assign f_valid[23] = f_valid_r[22];
assign f_valid[24] = fvalid3;
assign f_valid[25] = f_valid_r[24];
assign f_valid[26] = f_valid_r[25];
assign f_valid[27] = f_valid_r[26];
assign f_valid[28] = f_valid_r[27];
assign f_valid[29] = f_valid_r[28];
assign f_valid[30] = f_valid_r[29];
assign f_valid[31] = f_valid_r[30];
assign f_valid[32] = fvalid4;
assign f_valid[33] = f_valid_r[32];
assign f_valid[34] = f_valid_r[33];
assign f_valid[35] = f_valid_r[34];
assign f_valid[36] = f_valid_r[35];
assign f_valid[37] = f_valid_r[36];
assign f_valid[38] = f_valid_r[37];
assign f_valid[39] = f_valid_r[38];
assign f_valid[40] = fvalid5;
assign f_valid[41] = f_valid_r[40];
assign f_valid[42] = f_valid_r[41];
assign f_valid[43] = f_valid_r[42];
assign f_valid[44] = f_valid_r[43];
assign f_valid[45] = f_valid_r[44];
assign f_valid[46] = f_valid_r[45];
assign f_valid[47] = f_valid_r[46];
assign f_valid[48] = fvalid6;
assign f_valid[49] = f_valid_r[48];
assign f_valid[50] = f_valid_r[49];
assign f_valid[51] = f_valid_r[50];
assign f_valid[52] = f_valid_r[51];
assign f_valid[53] = f_valid_r[52];
assign f_valid[54] = f_valid_r[53];
assign f_valid[55] = f_valid_r[54];
assign f_valid[56] = fvalid7;
assign f_valid[57] = f_valid_r[56];
assign f_valid[58] = f_valid_r[57];
assign f_valid[59] = f_valid_r[58];
assign f_valid[60] = f_valid_r[59];
assign f_valid[61] = f_valid_r[60];
assign f_valid[62] = f_valid_r[61];
assign f_valid[63] = f_valid_r[62];

assign f_data[0] = fdata0;
assign f_data[1] = f_data_r[0];
assign f_data[2] = f_data_r[1];
assign f_data[3] = f_data_r[2];
assign f_data[4] = f_data_r[3];
assign f_data[5] = f_data_r[4];
assign f_data[6] = f_data_r[5];
assign f_data[7] = f_data_r[6];
assign f_data[8] = fdata1;
assign f_data[9] = f_data_r[8];
assign f_data[10] = f_data_r[9];
assign f_data[11] = f_data_r[10];
assign f_data[12] = f_data_r[11];
assign f_data[13] = f_data_r[12];
assign f_data[14] = f_data_r[13];
assign f_data[15] = f_data_r[14];
assign f_data[16] = fdata2;
assign f_data[17] = f_data_r[16];
assign f_data[18] = f_data_r[17];
assign f_data[19] = f_data_r[18];
assign f_data[20] = f_data_r[19];
assign f_data[21] = f_data_r[20];
assign f_data[22] = f_data_r[21];
assign f_data[23] = f_data_r[22];
assign f_data[24] = fdata3;
assign f_data[25] = f_data_r[24];
assign f_data[26] = f_data_r[25];
assign f_data[27] = f_data_r[26];
assign f_data[28] = f_data_r[27];
assign f_data[29] = f_data_r[28];
assign f_data[30] = f_data_r[29];
assign f_data[31] = f_data_r[30];
assign f_data[32] = fdata4;
assign f_data[33] = f_data_r[32];
assign f_data[34] = f_data_r[33];
assign f_data[35] = f_data_r[34];
assign f_data[36] = f_data_r[35];
assign f_data[37] = f_data_r[36];
assign f_data[38] = f_data_r[37];
assign f_data[39] = f_data_r[38];
assign f_data[40] = fdata5;
assign f_data[41] = f_data_r[40];
assign f_data[42] = f_data_r[41];
assign f_data[43] = f_data_r[42];
assign f_data[44] = f_data_r[43];
assign f_data[45] = f_data_r[44];
assign f_data[46] = f_data_r[45];
assign f_data[47] = f_data_r[46];
assign f_data[48] = fdata6;
assign f_data[49] = f_data_r[48];
assign f_data[50] = f_data_r[49];
assign f_data[51] = f_data_r[50];
assign f_data[52] = f_data_r[51];
assign f_data[53] = f_data_r[52];
assign f_data[54] = f_data_r[53];
assign f_data[55] = f_data_r[54];
assign f_data[56] = fdata7;
assign f_data[57] = f_data_r[56];
assign f_data[58] = f_data_r[57];
assign f_data[59] = f_data_r[58];
assign f_data[60] = f_data_r[59];
assign f_data[61] = f_data_r[60];
assign f_data[62] = f_data_r[61];
assign f_data[63] = f_data_r[62];

assign valid_l[0] = valid_o[8];
assign valid_l[1] = valid_o[9];
assign valid_l[2] = valid_o[10];
assign valid_l[3] = valid_o[11];
assign valid_l[4] = valid_o[12];
assign valid_l[5] = valid_o[13];
assign valid_l[6] = valid_o[14];
assign valid_l[7] = valid_o[15];
assign valid_l[8] = valid_o[16];
assign valid_l[9] = valid_o[17];
assign valid_l[10] = valid_o[18];
assign valid_l[11] = valid_o[19];
assign valid_l[12] = valid_o[20];
assign valid_l[13] = valid_o[21];
assign valid_l[14] = valid_o[22];
assign valid_l[15] = valid_o[23];
assign valid_l[16] = valid_o[24];
assign valid_l[17] = valid_o[25];
assign valid_l[18] = valid_o[26];
assign valid_l[19] = valid_o[27];
assign valid_l[20] = valid_o[28];
assign valid_l[21] = valid_o[29];
assign valid_l[22] = valid_o[30];
assign valid_l[23] = valid_o[31];
assign valid_l[24] = valid_o[32];
assign valid_l[25] = valid_o[33];
assign valid_l[26] = valid_o[34];
assign valid_l[27] = valid_o[35];
assign valid_l[28] = valid_o[36];
assign valid_l[29] = valid_o[37];
assign valid_l[30] = valid_o[38];
assign valid_l[31] = valid_o[39];
assign valid_l[32] = valid_o[40];
assign valid_l[33] = valid_o[41];
assign valid_l[34] = valid_o[42];
assign valid_l[35] = valid_o[43];
assign valid_l[36] = valid_o[44];
assign valid_l[37] = valid_o[45];
assign valid_l[38] = valid_o[46];
assign valid_l[39] = valid_o[47];
assign valid_l[40] = valid_o[48];
assign valid_l[41] = valid_o[49];
assign valid_l[42] = valid_o[50];
assign valid_l[43] = valid_o[51];
assign valid_l[44] = valid_o[52];
assign valid_l[45] = valid_o[53];
assign valid_l[46] = valid_o[54];
assign valid_l[47] = valid_o[55];
assign valid_l[48] = valid_o[56];
assign valid_l[49] = valid_o[57];
assign valid_l[50] = valid_o[58];
assign valid_l[51] = valid_o[59];
assign valid_l[52] = valid_o[60];
assign valid_l[53] = valid_o[61];
assign valid_l[54] = valid_o[62];
assign valid_l[55] = valid_o[63];
assign valid_l[56] = 1'b0;
assign valid_l[57] = 1'b0;
assign valid_l[58] = 1'b0;
assign valid_l[59] = 1'b0;
assign valid_l[60] = 1'b0;
assign valid_l[61] = 1'b0;
assign valid_l[62] = 1'b0;
assign valid_l[63] = 1'b0;

assign data_l[0] = data_o[8];
assign data_l[1] = data_o[9];
assign data_l[2] = data_o[10];
assign data_l[3] = data_o[11];
assign data_l[4] = data_o[12];
assign data_l[5] = data_o[13];
assign data_l[6] = data_o[14];
assign data_l[7] = data_o[15];
assign data_l[8] = data_o[16];
assign data_l[9] = data_o[17];
assign data_l[10] = data_o[18];
assign data_l[11] = data_o[19];
assign data_l[12] = data_o[20];
assign data_l[13] = data_o[21];
assign data_l[14] = data_o[22];
assign data_l[15] = data_o[23];
assign data_l[16] = data_o[24];
assign data_l[17] = data_o[25];
assign data_l[18] = data_o[26];
assign data_l[19] = data_o[27];
assign data_l[20] = data_o[28];
assign data_l[21] = data_o[29];
assign data_l[22] = data_o[30];
assign data_l[23] = data_o[31];
assign data_l[24] = data_o[32];
assign data_l[25] = data_o[33];
assign data_l[26] = data_o[34];
assign data_l[27] = data_o[35];
assign data_l[28] = data_o[36];
assign data_l[29] = data_o[37];
assign data_l[30] = data_o[38];
assign data_l[31] = data_o[39];
assign data_l[32] = data_o[40];
assign data_l[33] = data_o[41];
assign data_l[34] = data_o[42];
assign data_l[35] = data_o[43];
assign data_l[36] = data_o[44];
assign data_l[37] = data_o[45];
assign data_l[38] = data_o[46];
assign data_l[39] = data_o[47];
assign data_l[40] = data_o[48];
assign data_l[41] = data_o[49];
assign data_l[42] = data_o[50];
assign data_l[43] = data_o[51];
assign data_l[44] = data_o[52];
assign data_l[45] = data_o[53];
assign data_l[46] = data_o[54];
assign data_l[47] = data_o[55];
assign data_l[48] = data_o[56];
assign data_l[49] = data_o[57];
assign data_l[50] = data_o[58];
assign data_l[51] = data_o[59];
assign data_l[52] = data_o[60];
assign data_l[53] = data_o[61];
assign data_l[54] = data_o[62];
assign data_l[55] = data_o[63];
assign data_l[56] = 'b0;
assign data_l[57] = 'b0;
assign data_l[58] = 'b0;
assign data_l[59] = 'b0;
assign data_l[60] = 'b0;
assign data_l[61] = 'b0;
assign data_l[62] = 'b0;
assign data_l[63] = 'b0;

genvar i;
generate
    for (i=0;i<64;i=i+1) begin
        MAC U_MAC(
            .clk                  (clk                    ), // input 
            .rst                  (rst                    ), // input 
            .num_valid            (num_valid[i]           ), // input 
            .num                  (num[i]                 ), // input [31:0] 
            .num_valid_r          (num_valid_r[i]         ), // output reg 
            .num_r                (num_r[i]               ), // output reg 
            .w_valid              (w_valid[i]             ), // input 
            .w_data               (w_data[i]              ), // input signed [7:0] 
            .w_valid_r            (w_valid_r[i]           ), // output reg 
            .w_data_r             (w_data_r[i]            ), // output reg signed [7:0] 
            .f_valid              (f_valid[i]             ), // input 
            .f_data               (f_data[i]              ), // input signed [7:0] 
            .f_valid_r            (f_valid_r[i]           ), // output reg 
            .f_data_r             (f_data_r[i]            ), // output reg signed [7:0] 
            .valid_l              (valid_l[i]             ), // input 
            .data_l               (data_l[i]              ), // input signed [31:0] 
            .valid_o              (valid_o[i]             ), // output reg 
            .data_o               (data_o[i]              )  // output reg signed [31:0] 
        );
    end
endgenerate

assign valid_o0 = valid_o[0];
assign valid_o1 = valid_o[1];
assign valid_o2 = valid_o[2];
assign valid_o3 = valid_o[3];
assign valid_o4 = valid_o[4];
assign valid_o5 = valid_o[5];
assign valid_o6 = valid_o[6];
assign valid_o7 = valid_o[7];

assign data_o0 = data_o[0];
assign data_o1 = data_o[1];
assign data_o2 = data_o[2];
assign data_o3 = data_o[3];
assign data_o4 = data_o[4];
assign data_o5 = data_o[5];
assign data_o6 = data_o[6];
assign data_o7 = data_o[7];

endmodule