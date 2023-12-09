module Input_align(
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
    input [7:0] wdata0,
    input wvalid1,
    input [7:0] wdata1,
    input wvalid2,
    input [7:0] wdata2,
    input wvalid3,
    input [7:0] wdata3,
    input wvalid4,
    input [7:0] wdata4,
    input wvalid5,
    input [7:0] wdata5,
    input wvalid6,
    input [7:0] wdata6,
    input wvalid7,
    input [7:0] wdata7,
    output ali_fvalid0,
    output [7:0] ali_fdata0,
    output ali_fvalid1,
    output [7:0] ali_fdata1,
    output ali_fvalid2,
    output [7:0] ali_fdata2,
    output ali_fvalid3,
    output [7:0] ali_fdata3,
    output ali_fvalid4,
    output [7:0] ali_fdata4,
    output ali_fvalid5,
    output [7:0] ali_fdata5,
    output ali_fvalid6,
    output [7:0] ali_fdata6,
    output ali_fvalid7,
    output [7:0] ali_fdata7,
    output ali_wvalid0,
    output [7:0] ali_wdata0,
    output ali_wvalid1,
    output [7:0] ali_wdata1,
    output ali_wvalid2,
    output [7:0] ali_wdata2,
    output ali_wvalid3,
    output [7:0] ali_wdata3,
    output ali_wvalid4,
    output [7:0] ali_wdata4,
    output ali_wvalid5,
    output [7:0] ali_wdata5,
    output ali_wvalid6,
    output [7:0] ali_wdata6,
    output ali_wvalid7,
    output [7:0] ali_wdata7
    );

reg                   fvalid1_r                ; 
reg     [   7:   0]   fdata1_r                 ; 
reg     [   1:   0]   fvalid2_r                ; 
reg     [  15:   0]   fdata2_r                 ; 
reg     [   2:   0]   fvalid3_r                ; 
reg     [  23:   0]   fdata3_r                 ; 
reg     [   3:   0]   fvalid4_r                ; 
reg     [  31:   0]   fdata4_r                 ; 
reg     [   4:   0]   fvalid5_r                ; 
reg     [  39:   0]   fdata5_r                 ; 
reg     [   5:   0]   fvalid6_r                ; 
reg     [  47:   0]   fdata6_r                 ; 
reg     [   6:   0]   fvalid7_r                ; 
reg     [  55:   0]   fdata7_r                 ; 
reg                   wvalid1_r                ; 
reg     [   7:   0]   wdata1_r                 ; 
reg     [   1:   0]   wvalid2_r                ; 
reg     [  15:   0]   wdata2_r                 ; 
reg     [   2:   0]   wvalid3_r                ; 
reg     [  23:   0]   wdata3_r                 ; 
reg     [   3:   0]   wvalid4_r                ; 
reg     [  31:   0]   wdata4_r                 ; 
reg     [   4:   0]   wvalid5_r                ; 
reg     [  39:   0]   wdata5_r                 ; 
reg     [   5:   0]   wvalid6_r                ; 
reg     [  47:   0]   wdata6_r                 ; 
reg     [   6:   0]   wvalid7_r                ; 
reg     [  55:   0]   wdata7_r                 ; 

always @(posedge clk or posedge rst) begin
    if (rst) begin
        fvalid1_r <= 'b0;
        fdata1_r  <= 'b0;
        fvalid2_r <= 'b0;
        fdata2_r  <= 'b0;
        fvalid3_r <= 'b0;
        fdata3_r  <= 'b0;
        fvalid4_r <= 'b0;
        fdata4_r  <= 'b0;
        fvalid5_r <= 'b0;
        fdata5_r  <= 'b0;
        fvalid6_r <= 'b0;
        fdata6_r  <= 'b0;
        fvalid7_r <= 'b0;
        fdata7_r  <= 'b0;
        wvalid1_r <= 'b0;
        wdata1_r  <= 'b0;
        wvalid2_r <= 'b0;
        wdata2_r  <= 'b0;
        wvalid3_r <= 'b0;
        wdata3_r  <= 'b0;
        wvalid4_r <= 'b0;
        wdata4_r  <= 'b0;
        wvalid5_r <= 'b0;
        wdata5_r  <= 'b0;
        wvalid6_r <= 'b0;
        wdata6_r  <= 'b0;
        wvalid7_r <= 'b0;
        wdata7_r  <= 'b0;
    end
    else begin
        fvalid1_r <= fvalid1; //            
        fdata1_r  <= fdata1; // [   7:   0]
        fvalid2_r <= {fvalid2_r[0],fvalid2}; // [   1:   0]
        fdata2_r  <= {fdata2_r[7:0],fdata2}; // [  15:   0]
        fvalid3_r <= {fvalid3_r[1:0],fvalid3}; // [   2:   0]
        fdata3_r  <= {fdata3_r[15:0],fdata3}; // [  23:   0]
        fvalid4_r <= {fvalid4_r[2:0],fvalid4}; // [   3:   0]
        fdata4_r  <= {fdata4_r[23:0],fdata4}; // [  31:   0]
        fvalid5_r <= {fvalid5_r[3:0],fvalid5}; // [   4:   0]
        fdata5_r  <= {fdata5_r[31:0],fdata5}; // [  39:   0]
        fvalid6_r <= {fvalid6_r[4:0],fvalid6}; // [   5:   0]
        fdata6_r  <= {fdata6_r[39:0],fdata6}; // [  47:   0]
        fvalid7_r <= {fvalid7_r[5:0],fvalid7}; // [   6:   0]
        fdata7_r  <= {fdata7_r[47:0],fdata7}; // [  55:   0]
        wvalid1_r <= wvalid1; //            
        wdata1_r  <= wdata1; // [   7:   0]
        wvalid2_r <= {wvalid2_r[0],wvalid2}; // [   1:   0]
        wdata2_r  <= {wdata2_r[7:0],wdata2}; // [  15:   0]
        wvalid3_r <= {wvalid3_r[1:0],wvalid3}; // [   2:   0]
        wdata3_r  <= {wdata3_r[15:0],wdata3}; // [  23:   0]
        wvalid4_r <= {wvalid4_r[2:0],wvalid4}; // [   3:   0]
        wdata4_r  <= {wdata4_r[23:0],wdata4}; // [  31:   0]
        wvalid5_r <= {wvalid5_r[3:0],wvalid5}; // [   4:   0]
        wdata5_r  <= {wdata5_r[31:0],wdata5}; // [  39:   0]
        wvalid6_r <= {wvalid6_r[4:0],wvalid6}; // [   5:   0]
        wdata6_r  <= {wdata6_r[39:0],wdata6}; // [  47:   0]
        wvalid7_r <= {wvalid7_r[5:0],wvalid7}; // [   6:   0]
        wdata7_r  <= {wdata7_r[47:0],wdata7}; // [  55:   0]
    end
end

assign ali_fvalid0 = fvalid0;
assign ali_fdata0 = fdata0;
assign ali_fvalid1 = fvalid1_r;
assign ali_fdata1 = fdata1_r;
assign ali_fvalid2 = fvalid2_r[1];
assign ali_fdata2 = fdata2_r[15:8];
assign ali_fvalid3 = fvalid3_r[2];
assign ali_fdata3 = fdata3_r[23:16];
assign ali_fvalid4 = fvalid4_r[3];
assign ali_fdata4 = fdata4_r[31:24];
assign ali_fvalid5 = fvalid5_r[4];
assign ali_fdata5 = fdata5_r[39:32];
assign ali_fvalid6 = fvalid6_r[5];
assign ali_fdata6 = fdata6_r[47:40];
assign ali_fvalid7 = fvalid7_r[6];
assign ali_fdata7 = fdata7_r[55:48];
assign ali_wvalid0 = wvalid0;
assign ali_wdata0 = wdata0;
assign ali_wvalid1 = wvalid1_r;
assign ali_wdata1 = wdata1_r;
assign ali_wvalid2 = wvalid2_r[1];
assign ali_wdata2 = wdata2_r[15:8];
assign ali_wvalid3 = wvalid3_r[2];
assign ali_wdata3 = wdata3_r[23:16];
assign ali_wvalid4 = wvalid4_r[3];
assign ali_wdata4 = wdata4_r[31:24];
assign ali_wvalid5 = wvalid5_r[4];
assign ali_wdata5 = wdata5_r[39:32];
assign ali_wvalid6 = wvalid6_r[5];
assign ali_wdata6 = wdata6_r[47:40];
assign ali_wvalid7 = wvalid7_r[6];
assign ali_wdata7 = wdata7_r[55:48];

endmodule