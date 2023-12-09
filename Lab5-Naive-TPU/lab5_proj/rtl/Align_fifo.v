module Align_fifo(
    input clk,
    input rst,
    // connect Multiply_8x8
    input valid_get0,
    input [31:0] data_get0,
    input valid_get1,
    input [31:0] data_get1,
    input valid_get2,
    input [31:0] data_get2,
    input valid_get3,
    input [31:0] data_get3,
    input valid_get4,
    input [31:0] data_get4,
    input valid_get5,
    input [31:0] data_get5,
    input valid_get6,
    input [31:0] data_get6,
    input valid_get7,
    input [31:0] data_get7,
    // connect Multiply_ctrl
    input [7:0] sub_scale_M,
    input [7:0] sub_scale_P,
    output reg align_fifo_get_all,
    // connect Out_ctrl
    input out_ctrl_ready,
    output reg valid,
    output reg [31:0] data
    );

reg [3:0] fifo_wr_cnt [7:0];
wire [31:0] fifo_din [7:0];
wire [7:0] fifo_wr_en;
reg  [7:0] fifo_rd_en;
wire [31:0] fifo_dout [7:0];
wire [7:0] fifo_empty;

assign fifo_wr_en[0] = (~align_fifo_get_all)&&valid_get0&&(sub_scale_P>8'd0)&&(fifo_wr_cnt[0]<sub_scale_M);
assign fifo_wr_en[1] = (~align_fifo_get_all)&&valid_get1&&(sub_scale_P>8'd1)&&(fifo_wr_cnt[1]<sub_scale_M);
assign fifo_wr_en[2] = (~align_fifo_get_all)&&valid_get2&&(sub_scale_P>8'd2)&&(fifo_wr_cnt[2]<sub_scale_M);
assign fifo_wr_en[3] = (~align_fifo_get_all)&&valid_get3&&(sub_scale_P>8'd3)&&(fifo_wr_cnt[3]<sub_scale_M);
assign fifo_wr_en[4] = (~align_fifo_get_all)&&valid_get4&&(sub_scale_P>8'd4)&&(fifo_wr_cnt[4]<sub_scale_M);
assign fifo_wr_en[5] = (~align_fifo_get_all)&&valid_get5&&(sub_scale_P>8'd5)&&(fifo_wr_cnt[5]<sub_scale_M);
assign fifo_wr_en[6] = (~align_fifo_get_all)&&valid_get6&&(sub_scale_P>8'd6)&&(fifo_wr_cnt[6]<sub_scale_M);
assign fifo_wr_en[7] = (~align_fifo_get_all)&&valid_get7&&(sub_scale_P>8'd7)&&(fifo_wr_cnt[7]<sub_scale_M);

assign fifo_din[0] = data_get0;
assign fifo_din[1] = data_get1;
assign fifo_din[2] = data_get2;
assign fifo_din[3] = data_get3;
assign fifo_din[4] = data_get4;
assign fifo_din[5] = data_get5;
assign fifo_din[6] = data_get6;
assign fifo_din[7] = data_get7;

genvar j;
generate
    for (j=0;j<8;j=j+1) begin
        always @(posedge clk or posedge rst) begin
            if (rst) begin
                fifo_wr_cnt[j] <= 'b0;
            end
            else if (align_fifo_get_all) begin
                fifo_wr_cnt[j] <= 'b0;
            end
            else if (fifo_wr_en[j]) begin
                fifo_wr_cnt[j] <= fifo_wr_cnt[j] + 'b1;
            end
            else begin
                fifo_wr_cnt[j] <= fifo_wr_cnt[j];
            end
        end
    end
endgenerate

genvar i;
generate
    for (i=0;i<8;i=i+1) begin
        out_align_fifo U_out_align_fifo(
            .clk   (clk           ), // input wire clk
            .din   (fifo_din[i]   ), // input wire [31 : 0] din
            .wr_en (fifo_wr_en[i] ), // input wire wr_en
            .rd_en (fifo_rd_en[i] ), // input wire rd_en
            .dout  (fifo_dout[i]  ), // output wire [31 : 0] dout
            .full  (              ), // output wire full
            .empty (fifo_empty[i] )  // output wire empty
        );
    end
endgenerate

localparam NOW_OUT0 = 8'b0000_0001;
localparam NOW_OUT1 = 8'b0000_0010;
localparam NOW_OUT2 = 8'b0000_0100;
localparam NOW_OUT3 = 8'b0000_1000;
localparam NOW_OUT4 = 8'b0001_0000;
localparam NOW_OUT5 = 8'b0010_0000;
localparam NOW_OUT6 = 8'b0100_0000;
localparam NOW_OUT7 = 8'b1000_0000;

reg [7:0] c_state;
reg [7:0] n_state;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        c_state <= NOW_OUT0;
    end
    else begin
        c_state <= n_state;
    end
end

always @(*) begin
    case (c_state)
    NOW_OUT0: begin
        if (fifo_rd_en[0]&&(sub_scale_P==8'd1))
            n_state = NOW_OUT0;
        else if (fifo_rd_en[0])
            n_state = NOW_OUT1;
        else
            n_state = c_state;
    end
    NOW_OUT1: begin
        if (fifo_rd_en[1]&&(sub_scale_P==8'd2))
            n_state = NOW_OUT0;
        else if (fifo_rd_en[1])
            n_state = NOW_OUT2;
        else
            n_state = c_state;
    end
    NOW_OUT2: begin
        if (fifo_rd_en[2]&&(sub_scale_P==8'd3))
            n_state = NOW_OUT0;
        else if (fifo_rd_en[2])
            n_state = NOW_OUT3;
        else
            n_state = c_state;
    end
    NOW_OUT3: begin
        if (fifo_rd_en[3]&&(sub_scale_P==8'd4))
            n_state = NOW_OUT0;
        else if (fifo_rd_en[3])
            n_state = NOW_OUT4;
        else
            n_state = c_state;
    end
    NOW_OUT4: begin
        if (fifo_rd_en[4]&&(sub_scale_P==8'd5))
            n_state = NOW_OUT0;
        else if (fifo_rd_en[4])
            n_state = NOW_OUT5;
        else
            n_state = c_state;
    end
    NOW_OUT5: begin
        if (fifo_rd_en[5]&&(sub_scale_P==8'd6))
            n_state = NOW_OUT0;
        else if (fifo_rd_en[5])
            n_state = NOW_OUT6;
        else
            n_state = c_state;
    end
    NOW_OUT6: begin
        if (fifo_rd_en[6]&&(sub_scale_P==8'd7))
            n_state = NOW_OUT0;
        else if (fifo_rd_en[6])
            n_state = NOW_OUT7;
        else
            n_state = c_state;
    end
    NOW_OUT7: begin
        if (fifo_rd_en[7]&&(sub_scale_P==8'd8))
            n_state = NOW_OUT0;
        else if (fifo_rd_en[7])
            n_state = NOW_OUT0;
        else
            n_state = c_state;
    end
    default: n_state = NOW_OUT0;
    endcase
end

always @(*) begin
    fifo_rd_en = 8'b0;
    case (c_state)
    NOW_OUT0: fifo_rd_en[0] = (~fifo_empty[0])&out_ctrl_ready;
    NOW_OUT1: fifo_rd_en[1] = (~fifo_empty[1])&out_ctrl_ready;
    NOW_OUT2: fifo_rd_en[2] = (~fifo_empty[2])&out_ctrl_ready;
    NOW_OUT3: fifo_rd_en[3] = (~fifo_empty[3])&out_ctrl_ready;
    NOW_OUT4: fifo_rd_en[4] = (~fifo_empty[4])&out_ctrl_ready;
    NOW_OUT5: fifo_rd_en[5] = (~fifo_empty[5])&out_ctrl_ready;
    NOW_OUT6: fifo_rd_en[6] = (~fifo_empty[6])&out_ctrl_ready;
    NOW_OUT7: fifo_rd_en[7] = (~fifo_empty[7])&out_ctrl_ready;
    default: fifo_rd_en = 8'b0;
    endcase
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        valid <= 1'b0;
    end
    else begin
        case (c_state)
        NOW_OUT0: valid = fifo_rd_en[0];
        NOW_OUT1: valid = fifo_rd_en[1];
        NOW_OUT2: valid = fifo_rd_en[2];
        NOW_OUT3: valid = fifo_rd_en[3];
        NOW_OUT4: valid = fifo_rd_en[4];
        NOW_OUT5: valid = fifo_rd_en[5];
        NOW_OUT6: valid = fifo_rd_en[6];
        NOW_OUT7: valid = fifo_rd_en[7];
        default: valid = 1'b0;
        endcase
    end
end

reg [7:0] c_state_f1;
always @(posedge clk or posedge rst) begin
    if (rst) begin
        c_state_f1 <= 8'b0;
    end
    else begin
        c_state_f1 <= c_state;
    end
end
always @(*) begin
    case (c_state_f1)
    NOW_OUT0: data = fifo_dout[0];
    NOW_OUT1: data = fifo_dout[1];
    NOW_OUT2: data = fifo_dout[2];
    NOW_OUT3: data = fifo_dout[3];
    NOW_OUT4: data = fifo_dout[4];
    NOW_OUT5: data = fifo_dout[5];
    NOW_OUT6: data = fifo_dout[6];
    NOW_OUT7: data = fifo_dout[7];
    default: data = 'b0;
    endcase
end

reg [15:0] get_cnt;
reg [15:0] get_valid_cnt;
reg [15:0] all_count;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        get_valid_cnt <= 'b0;
    end
    else if (get_valid_cnt>='d64&&(align_fifo_get_all||all_count==0)) begin
        get_valid_cnt <= 'b0;
    end
    else begin
        get_valid_cnt <= get_valid_cnt + valid_get7 + valid_get6
                                       + valid_get5 + valid_get4
                                       + valid_get3 + valid_get2
                                       + valid_get1 + valid_get0;
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        get_cnt <= 'b0;
    end
    else if (align_fifo_get_all) begin
        get_cnt <= 'b0;
    end
    else begin
        get_cnt <= get_cnt + fifo_wr_en[7] + fifo_wr_en[6]
                           + fifo_wr_en[5] + fifo_wr_en[4]
                           + fifo_wr_en[3] + fifo_wr_en[2]
                           + fifo_wr_en[1] + fifo_wr_en[0];
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        all_count <= 'b0;
    end
    else begin
        all_count <= sub_scale_M*sub_scale_P;
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        align_fifo_get_all <= 1'b0;
    end
    else if ((get_cnt>=all_count)&&(all_count!=0)&&(~align_fifo_get_all)) begin
        align_fifo_get_all <= 1'b1;
    end
    else if (get_valid_cnt>='d64) begin
        align_fifo_get_all <= 1'b0;
    end
    else begin
        align_fifo_get_all <= align_fifo_get_all;
    end
end

endmodule
