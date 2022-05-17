`timescale 1 ns / 1 ps
module CLKMUX4_NOGLITCH_tb();

    reg DATA3_I = 1'b0;
    reg DATA2_I = 1'b0;
    reg DATA1_I = 1'b0;
    reg DATA0_I = 1'b0;

    reg unsigned [1:0] SEL_I = 2'b00;
    reg EN_I = 1'b1;

    wire DATA_O;

    CLKMUX4_NOGLITCH CLKMUX4_NOGLITCH(
        .DATA3_I (DATA3_I),
        .DATA2_I (DATA2_I),
        .DATA1_I (DATA1_I),
        .DATA0_I (DATA0_I),
        .SEL_I (SEL_I),
        .EN_I (EN_I),
        .DATA_O (DATA_O)
    );

    always begin
        #1 DATA3_I <= ~DATA3_I;
    end

    always begin
        #3 DATA2_I <= ~DATA2_I;
    end

    always begin
        #5 DATA1_I <= ~DATA1_I;
    end

    always begin
        #7 DATA0_I <= ~DATA0_I;
    end

    always begin
        #211 SEL_I <= SEL_I + 2'b01;
    end

    initial begin
        #197 EN_I <= ~EN_I;
        #205 EN_I <= ~EN_I;
    end

endmodule