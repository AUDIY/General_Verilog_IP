/*-----------------------------------------------------------------------------
* CLKMUX4_NOGLITCH.v
*
* Glitch-free Clock Multiplexer Module w/o ALTCLKCTRL IP.
*
* Designer: AUDIY
* Date    : 22/05/11 (YY/MM/DD)
* Version : 1.00
*
* Description
*   Input
*   DATA3_I: Clock Input 3
*   DATA2_I: Clock Input 2
*   DATA1_I: Clock Input 1
*   DATA0_I: Clock Input 0
*   SEL_I  : Clock Select
*            2'b11: DATA3_I
*            2'b10: DATA2_I
*            2'b01: DATA1_I
*            2'b00: DATA0_I
*   EN_I   : Output Enable
*            1'b1: Enable
*            1'b0: Disable
*
*   Output
*   DATA_O: Selected Clock Output
*
-----------------------------------------------------------------------------*/
module CLKMUX4_NOGLITCH(
    DATA3_I,
    DATA2_I,
    DATA1_I,
    DATA0_I,
    SEL_I,
    EN_I,
    DATA_O
);

    /* Input/Output Definition */
    input  wire                DATA3_I;
    input  wire                DATA2_I;
    input  wire                DATA1_I;
    input  wire                DATA0_I;
    input  wire unsigned [1:0] SEL_I;
    input  wire                EN_I;

    output wire                DATA_O;

    /* Internal Wire/Register Definition */
    wire unsigned [3:0] DATA_WIRE;
    wire unsigned [1:0] SELECT_ENABLE_WIRE_XOR;
    wire                SELECT_ENABLE_WIRE_OR;
    wire                TRUE_EN;
    wire                DATACTRL;

    reg unsigned [1:0] SEL_REG = 2'b00;
    reg                ENA_REG = 1'b0;

    /* RTL */
    // Bus Input wire
    assign DATA_WIRE[3:0] = {DATA3_I, DATA2_I, DATA1_I, DATA0_I};

    // Multiplex Clock
    assign DATACTRL       = datasel(DATA_WIRE, SEL_REG);

    // Enable & Select signal
    always @ (negedge DATACTRL) begin
        if (ENA_REG == 1'b0) begin
            SEL_REG[1:0] <= SEL_I[1:0];
        end
        ENA_REG <= TRUE_EN;
    end

    // Logic calcuration
    assign SELECT_ENABLE_WIRE_XOR[1:0] = {SEL_REG[1] ^ SEL_I[1], SEL_REG[0] ^ SEL_I[0]};
    assign SELECT_ENABLE_WIRE_OR       = SELECT_ENABLE_WIRE_XOR[1] | SELECT_ENABLE_WIRE_XOR[0];
    assign TRUE_EN                     = ~SELECT_ENABLE_WIRE_OR & EN_I;

    // Assign Clock Output
    assign DATA_O                      = ENA_REG & DATACTRL;

    // Clock Select Function
    function datasel;
        input unsigned [3:0] data_wire;
        input unsigned [1:0] sel_reg; 
    begin
        case (sel_reg)
            2'b11:
                datasel = data_wire[3];

            2'b10:
                datasel = data_wire[2];

            2'b01:
                datasel = data_wire[1];

            default:
                datasel = data_wire[0];

        endcase
    end
    endfunction

endmodule