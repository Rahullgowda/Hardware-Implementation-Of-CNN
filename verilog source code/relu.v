//==============================================================
// Project : Single Layer Hardware CNN
// Module  : ReLU
// Description : ReLU Activation for 4 Convolution Outputs
//==============================================================

module relu
#(
    parameter DATA_WIDTH = 32
)
(
    input clk,
    input reset,

    //----------------------------------------------------------
    // Convolution Inputs
    //----------------------------------------------------------

    input signed [DATA_WIDTH-1:0] conv0,
    input signed [DATA_WIDTH-1:0] conv1,
    input signed [DATA_WIDTH-1:0] conv2,
    input signed [DATA_WIDTH-1:0] conv3,

    input conv_valid,

    //----------------------------------------------------------
    // Window Coordinate
    //----------------------------------------------------------

    input [3:0] conv_row,
    input [3:0] conv_col,

    //----------------------------------------------------------
    // ReLU Outputs
    //----------------------------------------------------------

    output reg signed [DATA_WIDTH-1:0] relu0,
    output reg signed [DATA_WIDTH-1:0] relu1,
    output reg signed [DATA_WIDTH-1:0] relu2,
    output reg signed [DATA_WIDTH-1:0] relu3,

    output reg relu_valid,

    //----------------------------------------------------------
    // ReLU Coordinate
    //----------------------------------------------------------

    output reg [3:0] relu_row,
    output reg [3:0] relu_col

);

//----------------------------------------------------------
// MaxPool Signals
//----------------------------------------------------------

wire signed [31:0] pool0;
wire signed [31:0] pool1;
wire signed [31:0] pool2;
wire signed [31:0] pool3;

wire pool_valid;

wire [3:0] pool_row;
wire [3:0] pool_col;

//--------------------------------------------------------------
// ReLU Operation
//--------------------------------------------------------------

always @(posedge clk or posedge reset)
begin

    if(reset)
    begin

        relu0 <= 0;
        relu1 <= 0;
        relu2 <= 0;
        relu3 <= 0;

        relu_valid <= 1'b0;

        relu_row <= 0;
        relu_col <= 0;

    end

    else
    begin

        //------------------------------------------------------
        // Default
        //------------------------------------------------------

        relu_valid <= 1'b0;

        //------------------------------------------------------
        // Process convolution output
        //------------------------------------------------------

        if(conv_valid)
        begin

            //--------------------------------------------------
            // ReLU 0
            //--------------------------------------------------

            if(conv0 < 0)
                relu0 <= 0;
            else
                relu0 <= conv0;

            //--------------------------------------------------
            // ReLU 1
            //--------------------------------------------------

            if(conv1 < 0)
                relu1 <= 0;
            else
                relu1 <= conv1;

            //--------------------------------------------------
            // ReLU 2
            //--------------------------------------------------

            if(conv2 < 0)
                relu2 <= 0;
            else
                relu2 <= conv2;

            //--------------------------------------------------
            // ReLU 3
            //--------------------------------------------------

            if(conv3 < 0)
                relu3 <= 0;
            else
                relu3 <= conv3;

            //--------------------------------------------------
            // Coordinate
            //--------------------------------------------------

            relu_row <= conv_row;
            relu_col <= conv_col;

            //--------------------------------------------------
            // Output Valid
            //--------------------------------------------------

            relu_valid <= 1'b1;

        end

    end

end

endmodule