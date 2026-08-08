//==============================================================
// Project : Single Layer Hardware CNN
// Module  : Convolution
// Description : 3x3 Convolution Layer (4 Filters)
//==============================================================

module convolution
#(
    parameter DATA_WIDTH   = 8,
    parameter WEIGHT_WIDTH = 8,
    parameter OUT_WIDTH    = 32
)
(
    input clk,
    input reset,

    //----------------------------------------------------------
    // Window Valid
    //----------------------------------------------------------

    input window_valid,

    //----------------------------------------------------------
    // Window Coordinates
    //----------------------------------------------------------

    input [3:0] window_row,
    input [3:0] window_col,

    //----------------------------------------------------------
    // 3x3 Window
    //----------------------------------------------------------

    input signed [DATA_WIDTH-1:0] w0,
    input signed [DATA_WIDTH-1:0] w1,
    input signed [DATA_WIDTH-1:0] w2,

    input signed [DATA_WIDTH-1:0] w3,
    input signed [DATA_WIDTH-1:0] w4,
    input signed [DATA_WIDTH-1:0] w5,

    input signed [DATA_WIDTH-1:0] w6,
    input signed [DATA_WIDTH-1:0] w7,
    input signed [DATA_WIDTH-1:0] w8,

    //----------------------------------------------------------
    // Four Convolution Outputs
    //----------------------------------------------------------

    output reg signed [OUT_WIDTH-1:0] conv0,
    output reg signed [OUT_WIDTH-1:0] conv1,
    output reg signed [OUT_WIDTH-1:0] conv2,
    output reg signed [OUT_WIDTH-1:0] conv3,

    output reg conv_valid,

    //----------------------------------------------------------
    // Coordinate of Convolution Result
    //----------------------------------------------------------

    output reg [3:0] conv_row,
    output reg [3:0] conv_col

);

//--------------------------------------------------------------
// Trained Weights
//--------------------------------------------------------------

reg signed [WEIGHT_WIDTH-1:0] weights [0:35];

//--------------------------------------------------------------
// Trained Biases
//--------------------------------------------------------------

reg signed [WEIGHT_WIDTH-1:0] bias [0:3];

//--------------------------------------------------------------
// Load Weights and Biases
//--------------------------------------------------------------

initial
begin

    $readmemh(
        "D:/single layer hardware cnn project/hardware/memory/conv_weights.mem",
        weights
    );

    $readmemh(
        "D:/single layer hardware cnn project/hardware/memory/conv_bias.mem",
        bias
    );

end

//--------------------------------------------------------------
// Convolution Operation
//--------------------------------------------------------------

always @(posedge clk or posedge reset)
begin

    if(reset)
    begin

        conv0 <= 0;
        conv1 <= 0;
        conv2 <= 0;
        conv3 <= 0;

        conv_valid <= 1'b0;

        conv_row <= 0;
        conv_col <= 0;

    end

    else if(window_valid)
    begin

        //------------------------------------------------------
        // Filter 0
        //------------------------------------------------------

        conv0 <=
              (w0 * weights[0])
            + (w1 * weights[1])
            + (w2 * weights[2])
            + (w3 * weights[3])
            + (w4 * weights[4])
            + (w5 * weights[5])
            + (w6 * weights[6])
            + (w7 * weights[7])
            + (w8 * weights[8])
            + bias[0];

        //------------------------------------------------------
        // Filter 1
        //------------------------------------------------------

        conv1 <=
              (w0 * weights[9])
            + (w1 * weights[10])
            + (w2 * weights[11])
            + (w3 * weights[12])
            + (w4 * weights[13])
            + (w5 * weights[14])
            + (w6 * weights[15])
            + (w7 * weights[16])
            + (w8 * weights[17])
            + bias[1];

        //------------------------------------------------------
        // Filter 2
        //------------------------------------------------------

        conv2 <=
              (w0 * weights[18])
            + (w1 * weights[19])
            + (w2 * weights[20])
            + (w3 * weights[21])
            + (w4 * weights[22])
            + (w5 * weights[23])
            + (w6 * weights[24])
            + (w7 * weights[25])
            + (w8 * weights[26])
            + bias[2];

        //------------------------------------------------------
        // Filter 3
        //------------------------------------------------------

        conv3 <=
              (w0 * weights[27])
            + (w1 * weights[28])
            + (w2 * weights[29])
            + (w3 * weights[30])
            + (w4 * weights[31])
            + (w5 * weights[32])
            + (w6 * weights[33])
            + (w7 * weights[34])
            + (w8 * weights[35])
            + bias[3];

        //------------------------------------------------------
        // IMPORTANT:
        // Store coordinates together with convolution result
        //------------------------------------------------------

        conv_row <= window_row;
        conv_col <= window_col;

        //------------------------------------------------------
        // Output Valid
        //------------------------------------------------------

        conv_valid <= 1'b1;

    end

    else
    begin

        conv_valid <= 1'b0;

    end

end

endmodule