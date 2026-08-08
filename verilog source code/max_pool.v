//==============================================================
// Project : Single Layer Hardware CNN
// Module  : Max Pool
// Description : 2x2 Max Pooling for 4 Feature Maps
//==============================================================

module max_pool
#(
    parameter DATA_WIDTH = 32,
    parameter IMAGE_SIZE = 14
)
(
    input clk,
    input reset,

    //----------------------------------------------------------
    // ReLU Inputs
    //----------------------------------------------------------

    input signed [DATA_WIDTH-1:0] relu0,
    input signed [DATA_WIDTH-1:0] relu1,
    input signed [DATA_WIDTH-1:0] relu2,
    input signed [DATA_WIDTH-1:0] relu3,

    input relu_valid,

    //----------------------------------------------------------
    // ReLU Coordinates
    //----------------------------------------------------------

    input [3:0] relu_row,
    input [3:0] relu_col,

    //----------------------------------------------------------
    // MaxPool Outputs
    //----------------------------------------------------------

    output reg signed [DATA_WIDTH-1:0] pool0,
    output reg signed [DATA_WIDTH-1:0] pool1,
    output reg signed [DATA_WIDTH-1:0] pool2,
    output reg signed [DATA_WIDTH-1:0] pool3,

    output reg pool_valid,

    //----------------------------------------------------------
    // MaxPool Coordinates
    //----------------------------------------------------------

    output reg [3:0] pool_row,
    output reg [3:0] pool_col
);

//--------------------------------------------------------------
// Feature Map Memories
//--------------------------------------------------------------

reg signed [DATA_WIDTH-1:0] feature_mem0
[0:IMAGE_SIZE-1][0:IMAGE_SIZE-1];

reg signed [DATA_WIDTH-1:0] feature_mem1
[0:IMAGE_SIZE-1][0:IMAGE_SIZE-1];

reg signed [DATA_WIDTH-1:0] feature_mem2
[0:IMAGE_SIZE-1][0:IMAGE_SIZE-1];

reg signed [DATA_WIDTH-1:0] feature_mem3
[0:IMAGE_SIZE-1][0:IMAGE_SIZE-1];

//--------------------------------------------------------------
// Loop Variables
//--------------------------------------------------------------

integer i;
integer j;

//--------------------------------------------------------------
// Temporary Maximum Values
//--------------------------------------------------------------

reg signed [DATA_WIDTH-1:0] temp0;
reg signed [DATA_WIDTH-1:0] temp1;
reg signed [DATA_WIDTH-1:0] temp2;
reg signed [DATA_WIDTH-1:0] temp3;

//--------------------------------------------------------------
// Sequential Logic
//--------------------------------------------------------------

always @(posedge clk or posedge reset)
begin

    if(reset)
    begin

        //------------------------------------------------------
        // Reset Outputs
        //------------------------------------------------------

        pool0 <= 0;
        pool1 <= 0;
        pool2 <= 0;
        pool3 <= 0;

        pool_valid <= 1'b0;

        pool_row <= 0;
        pool_col <= 0;

        //------------------------------------------------------
        // Clear Feature Memories
        //------------------------------------------------------

        for(i = 0; i < IMAGE_SIZE; i = i + 1)
        begin

            for(j = 0; j < IMAGE_SIZE; j = j + 1)
            begin

                feature_mem0[i][j] <= 0;
                feature_mem1[i][j] <= 0;
                feature_mem2[i][j] <= 0;
                feature_mem3[i][j] <= 0;

            end

        end

    end

    else
    begin

        //------------------------------------------------------
        // Default
        //------------------------------------------------------

        pool_valid <= 1'b0;

        //------------------------------------------------------
        // Store ReLU Values
        //
        // ReLU coordinates are 2..15.
        // Feature memory coordinates must be 0..13.
        //
        // Therefore:
        //
        // memory_row = relu_row - 2
        // memory_col = relu_col - 2
        //------------------------------------------------------

        if(relu_valid)
        begin

            if((relu_row >= 4'd2) &&
               (relu_row <= 4'd15) &&
               (relu_col >= 4'd2) &&
               (relu_col <= 4'd15))
            begin

                feature_mem0[relu_row-4'd2][relu_col-4'd2]
                    <= relu0;

                feature_mem1[relu_row-4'd2][relu_col-4'd2]
                    <= relu1;

                feature_mem2[relu_row-4'd2][relu_col-4'd2]
                    <= relu2;

                feature_mem3[relu_row-4'd2][relu_col-4'd2]
                    <= relu3;

            end

        end

        //------------------------------------------------------
        // Default Pool Output
        //------------------------------------------------------
                //------------------------------------------------------
        // 2x2 Max Pooling
        //------------------------------------------------------
        //
        // Pooling happens when the ReLU coordinate is the
        // bottom-right corner of a 2x2 window.
        //
        // Example:
        //
        // ReLU coordinates:
        //
        //   (2,2) (2,3)
        //   (3,2) (3,3)
        //
        // When relu_row = 3 and relu_col = 3,
        // this is the first 2x2 pooling window.
        //
        //------------------------------------------------------

        if(relu_valid &&
           (relu_row >= 4'd3) &&
           (relu_col >= 4'd3) &&
           (relu_row[0] == 1'b1) &&
           (relu_col[0] == 1'b1))
        begin

            //--------------------------------------------------
            // Convert ReLU coordinates to feature-map
            // memory coordinates.
            //
            // relu_row 3 -> memory row 1
            // relu_col 3 -> memory col 1
            //--------------------------------------------------

            //--------------------------------------------------
            // CHANNEL 0
            //--------------------------------------------------

            temp0 =
                feature_mem0[relu_row-4'd3]
                           [relu_col-4'd3];

            if(feature_mem0[relu_row-4'd3]
                           [relu_col-4'd2] > temp0)
            begin
                temp0 =
                    feature_mem0[relu_row-4'd3]
                               [relu_col-4'd2];
            end

            if(feature_mem0[relu_row-4'd2]
                           [relu_col-4'd3] > temp0)
            begin
                temp0 =
                    feature_mem0[relu_row-4'd2]
                               [relu_col-4'd3];
            end

            // Current ReLU value = bottom-right
            if(relu0 > temp0)
            begin
                temp0 = relu0;
            end

            pool0 <= temp0;


            //--------------------------------------------------
            // CHANNEL 1
            //--------------------------------------------------

            temp1 =
                feature_mem1[relu_row-4'd3]
                           [relu_col-4'd3];

            if(feature_mem1[relu_row-4'd3]
                           [relu_col-4'd2] > temp1)
            begin
                temp1 =
                    feature_mem1[relu_row-4'd3]
                               [relu_col-4'd2];
            end

            if(feature_mem1[relu_row-4'd2]
                           [relu_col-4'd3] > temp1)
            begin
                temp1 =
                    feature_mem1[relu_row-4'd2]
                               [relu_col-4'd3];
            end

            // Current ReLU value = bottom-right
            if(relu1 > temp1)
            begin
                temp1 = relu1;
            end

            pool1 <= temp1;


            //--------------------------------------------------
            // Pool Output Coordinates
            //--------------------------------------------------

            pool_row <= (relu_row - 4'd3) >> 1;
            pool_col <= (relu_col - 4'd3) >> 1;


            //--------------------------------------------------
            // Pool Output Valid
            //--------------------------------------------------

            pool_valid <= 1'b1;

        
        
                    //--------------------------------------------------
            // CHANNEL 2
            //--------------------------------------------------

            temp2 =
                feature_mem2[relu_row-4'd3]
                           [relu_col-4'd3];

            if(feature_mem2[relu_row-4'd3]
                           [relu_col-4'd2] > temp2)
            begin
                temp2 =
                    feature_mem2[relu_row-4'd3]
                               [relu_col-4'd2];
            end

            if(feature_mem2[relu_row-4'd2]
                           [relu_col-4'd3] > temp2)
            begin
                temp2 =
                    feature_mem2[relu_row-4'd2]
                               [relu_col-4'd3];
            end

            // Current ReLU value = bottom-right
            if(relu2 > temp2)
            begin
                temp2 = relu2;
            end

            pool2 <= temp2;


            //--------------------------------------------------
            // CHANNEL 3
            //--------------------------------------------------

            temp3 =
                feature_mem3[relu_row-4'd3]
                           [relu_col-4'd3];

            if(feature_mem3[relu_row-4'd3]
                           [relu_col-4'd2] > temp3)
            begin
                temp3 =
                    feature_mem3[relu_row-4'd3]
                               [relu_col-4'd2];
            end

            if(feature_mem3[relu_row-4'd2]
                           [relu_col-4'd3] > temp3)
            begin
                temp3 =
                    feature_mem3[relu_row-4'd2]
                               [relu_col-4'd3];
            end

            // Current ReLU value = bottom-right
            if(relu3 > temp3)
            begin
                temp3 = relu3;
            end

            pool3 <= temp3;

        end

    end

end

endmodule

