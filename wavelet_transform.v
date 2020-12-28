module wavelet_transform(clk, rst, data_stream, H_out, L_out, addr, MUX_A, MUX_B, MUX_C, MUX_D, MUX_E, d1out, d2out, d3out, Ld1out, Ld2out, Ld3out, Ld4out, sub1, sub2, add1, add2); 

input clk, rst;

output reg [0:7] H_out;
output reg [0:7] L_out;

output reg  [0:7] addr;
output [0:7] data_stream;

output [0:7] MUX_A, MUX_B, MUX_C, MUX_D, MUX_E;

output [0:7] sub1, sub2;
output reg  [0:7] d1out, d2out, d3out;

output [0:7] add1, add2;
output reg  [0:7] Ld1out, Ld2out, Ld3out, Ld4out;

reg  sel;
reg  [0:7] BDU_1, BDU_2, BDU_3, BDU_4, BDU_5, BDU_6, BDU_7, BDU_8, BDU_9, BDU_10, BDU_11;
reg  [0:7] HPDU_1, HPDU_2, HPDU_3, HPDU_4, HPDU_5, HPDU_6, HPDU_7, HPDU_8, HPDU_9, HPDU_10, HPDU_11, HPDU_12, HPDU_13, HPDU_14;
reg  [0:7] LPDU_1, LPDU_2, LPDU_3, LPDU_4, LPDU_5, LPDU_6, LPDU_7, LPDU_8, LPDU_9, LPDU_10, LPDU_11, LPDU_12, LPDU_13, LPDU_14;

rom rom1(addr, data_stream);

assign sub1 = MUX_B - d1out;
assign sub2 = MUX_C - d1out;

assign add1 = MUX_D + (H_out >> 2);
assign add2 = MUX_E + (H_out >> 2);

assign MUX_A =  (addr[7] == 1'b1 ? data_stream : (addr[6:7] == 2'b00 ? BDU_2  : (addr[5:7] == 3'b010 ? BDU_9  : (addr[6:7] == 2'b10 ? BDU_3  : 8'hz))));
assign MUX_B =  (addr[7] == 1'b0 ? data_stream : (addr[6:7] == 2'b01 ? BDU_1  : (addr[5:7] == 3'b011 ? BDU_2  : (addr[6:7] == 2'b11 ? L_out  : 8'hz))));
assign MUX_C =  (addr[7] == 1'b0 ? d3out       : (addr[6:7] == 2'b01 ? HPDU_2 : (addr[5:7] == 3'b011 ? HPDU_14: (addr[6:7] == 2'b11 ? HPDU_6 : 8'hz))));
assign MUX_D =  (addr[7] == 1'b1 ? Ld2out      : (addr[6:7] == 2'b10 ? BDU_4  : (addr[5:7] == 3'b100 ? BDU_11 : (addr[6:7] == 2'b00 ? BDU_5  : 8'hz)))); 
assign MUX_E =  (addr[7] == 1'b1 ? Ld4out      : (addr[6:7] == 2'b10 ? LPDU_2 : (addr[5:7] == 3'b100 ? LPDU_14: (addr[6:7] == 2'b00 ? LPDU_6 : 8'hz))));

always@(negedge clk, negedge rst) begin
    if(!rst) begin
        addr <= 0;
    end else begin
        addr <= addr + 1;
    end
end

always@(negedge clk, negedge rst) begin
    if(!rst) begin
        sel <= 0;
    end else begin
        sel <= !sel;
    end
end


always@(negedge clk, negedge rst) begin
    if(!rst) begin
        d1out <= 0;
        d2out <= 0;
        d3out <= 0;
        H_out <= 0;
    end else begin
        d1out <= MUX_A >> 1;
        d2out <= sub1;
        d3out <= d2out;
        H_out <= sub2;
    end
end


always@(negedge clk, negedge rst) begin
    if(!rst) begin
        Ld1out <= 0; 
        Ld2out <= 0; 
        Ld3out <= 0; 
        Ld4out <= 0; 
        L_out  <= 0; 
    end else begin
        Ld1out <= data_stream;
        Ld2out <= Ld1out;
        Ld3out <= add1;
        Ld4out <= Ld3out;
        L_out  <= add2;
    end
end


always@(negedge clk, negedge rst) begin
    if(!rst) begin
        BDU_1 <= 0; 
        BDU_2 <= 0;
        BDU_3 <= 0;
        BDU_4 <= 0;
        BDU_5 <= 0; 
        BDU_6 <= 0; 
        BDU_7 <= 0; 
        BDU_8 <= 0; 
        BDU_9 <= 0; 
        BDU_10 <= 0; 
        BDU_11 <= 0; 
    end else begin
        BDU_1 <= L_out; 
        BDU_2 <= BDU_1;
        BDU_3 <= BDU_2;
        BDU_4 <= BDU_3;
        BDU_5 <= BDU_4; 
        BDU_6 <= BDU_5; 
        BDU_7 <= BDU_6; 
        BDU_8 <= BDU_7; 
        BDU_9 <= BDU_8; 
        BDU_10 <= BDU_9; 
        BDU_11 <= BDU_10; 
    end
end


always@(negedge clk, negedge rst) begin
    if(!rst) begin
        HPDU_1 <= 0; 
        HPDU_2 <= 0;
        HPDU_3 <= 0;
        HPDU_4 <= 0;
        HPDU_5 <= 0; 
        HPDU_6 <= 0; 
        HPDU_7 <= 0; 
        HPDU_8 <= 0; 
        HPDU_9 <= 0; 
        HPDU_10 <= 0; 
        HPDU_11 <= 0; 
        HPDU_12 <= 0; 
        HPDU_13 <= 0; 
        HPDU_14 <= 0; 
    end else begin
        HPDU_1 <= d3out; 
        HPDU_2 <= HPDU_1;
        HPDU_3 <= HPDU_2;
        HPDU_4 <= HPDU_3;
        HPDU_5 <= HPDU_4; 
        HPDU_6 <= HPDU_5; 
        HPDU_7 <= HPDU_6; 
        HPDU_8 <= HPDU_7; 
        HPDU_9 <= HPDU_8; 
        HPDU_10 <= HPDU_9; 
        HPDU_11 <= HPDU_10; 
        HPDU_12 <= HPDU_11; 
        HPDU_13 <= HPDU_12; 
        HPDU_14 <= HPDU_13; 
    end
end


always@(negedge clk, negedge rst) begin
    if(!rst) begin
        LPDU_1 <= 0; 
        LPDU_2 <= 0;
        LPDU_3 <= 0;
        LPDU_4 <= 0;
        LPDU_5 <= 0; 
        LPDU_6 <= 0; 
        LPDU_7 <= 0; 
        LPDU_8 <= 0; 
        LPDU_9 <= 0; 
        LPDU_10 <= 0; 
        LPDU_11 <= 0; 
        LPDU_12 <= 0; 
        LPDU_13 <= 0; 
        LPDU_14 <= 0; 
    end else begin
        LPDU_1 <= Ld4out; 
        LPDU_2 <= LPDU_1;
        LPDU_3 <= LPDU_2;
        LPDU_4 <= LPDU_3;
        LPDU_5 <= LPDU_4; 
        LPDU_6 <= LPDU_5; 
        LPDU_7 <= LPDU_6; 
        LPDU_8 <= LPDU_7;
        LPDU_9 <= LPDU_8;
        LPDU_10 <= LPDU_9;
        LPDU_11 <= LPDU_10; 
        LPDU_12 <= LPDU_11; 
        LPDU_13 <= LPDU_12; 
        LPDU_14 <= LPDU_13; 
    end
end


endmodule

module rom(addr, data);
input     [0:7] addr;
output reg[0:7] data;

always@(addr) begin
    case(addr)
        0: data = 0;
        1: data = 145;
        2: data = 56;
        3: data = 49;
        4: data = 89;
        5: data = 137;
        6: data = 90;
        7: data = 62;
        8: data = 33;
        9: data = 71;

        10: data = 77;
        11: data = 92;
        12: data = 145;
        13: data = 153;
        14: data = 108;
        15: data = 74;
        16: data = 146;
        17: data = 183;
        18: data = 120;
        19: data = 80;

        20: data = 93;
        21: data = 73;
        22: data = 90;
        23: data = 102;
        24: data = 66;
        25: data = 72;
        26: data = 121;
        27: data = 121;
        28: data = 71;
        29: data = 57;

        30: data = 146;
        31: data = 173;
        32: data = 66;
        33: data = 69;
        34: data = 137;
        35: data = 139;
        36: data = 88;
        37: data = 77;
        38: data = 60;
        39: data = 170;

        40: data = 88;
        41: data = 36;
        42: data = 70;
        43: data = 160;
        44: data = 157;
        45: data = 61;
        46: data = 110;
        47: data = 93;
        48: data = 125;
        49: data = 143;

        50: data = 106;
        51: data = 76;
        52: data = 116;
        53: data = 115;
        54: data = 112;
        55: data = 163;
        56: data = 182;
        57: data = 148;
        58: data = 98;
        59: data = 168;

        60: data = 156;
        61: data = 86;
        62: data = 164;
        63: data = 193;
        default: data = 0;
    endcase
end

endmodule