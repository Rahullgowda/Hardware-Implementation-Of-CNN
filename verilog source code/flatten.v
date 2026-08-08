//==============================================================
// Project : Single Layer Hardware CNN
// Module  : Flatten
// Description : Flattens 4 feature maps of 7x7 into
//               a sequential stream of 196 values
//==============================================================

module flatten
#(
    parameter DATA_WIDTH = 32,
    parameter FEATURE_SIZE = 7
)
(
    input clk,
    input reset,

    //----------------------------------------------------------
    // MaxPool Input
    //----------------------------------------------------------

    input signed [DATA_WIDTH-1:0] pool0,
    input signed [DATA_WIDTH-1:0] pool1,
    input signed [DATA_WIDTH-1:0] pool2,
    input signed [DATA_WIDTH-1:0] pool3,

    input pool_valid,
    input [3:0] pool_row,
    input [3:0] pool_col,

    //----------------------------------------------------------
    // Flatten Output
    //----------------------------------------------------------

    output reg signed [DATA_WIDTH-1:0] flat_data,

    output reg flat_valid,

    output reg [7:0] flat_index
);

//--------------------------------------------------------------
// Internal Feature Map Memories
//--------------------------------------------------------------

reg signed [DATA_WIDTH-1:0] feature_mem0
[0:FEATURE_SIZE-1][0:FEATURE_SIZE-1];

reg signed [DATA_WIDTH-1:0] feature_mem1
[0:FEATURE_SIZE-1][0:FEATURE_SIZE-1];

reg signed [DATA_WIDTH-1:0] feature_mem2
[0:FEATURE_SIZE-1][0:FEATURE_SIZE-1];

reg signed [DATA_WIDTH-1:0] feature_mem3
[0:FEATURE_SIZE-1][0:FEATURE_SIZE-1];

//--------------------------------------------------------------
// Control
//--------------------------------------------------------------

reg [1:0] channel;
reg [3:0] read_row;
reg [3:0] read_col;

reg flattening;

integer i;
integer j;

//--------------------------------------------------------------
// Sequential Logic
//--------------------------------------------------------------

always @(posedge clk or posedge reset)
begin

    if(reset)
    begin

        flat_data  <= 0;
        flat_valid <= 1'b0;
        flat_index <= 0;

        channel    <= 0;
        read_row   <= 0;
        read_col   <= 0;

        flattening <= 1'b0;

        //------------------------------------------------------
        // Clear memories
        //------------------------------------------------------

        for(i = 0; i < FEATURE_SIZE; i = i + 1)
        begin
            for(j = 0; j < FEATURE_SIZE; j = j + 1)
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

        flat_valid <= 1'b0;

        //------------------------------------------------------
        // Store MaxPool outputs
        //------------------------------------------------------

        if(pool_valid)
        begin

            feature_mem0[pool_row][pool_col] <= pool0;
            feature_mem1[pool_row][pool_col] <= pool1;
            feature_mem2[pool_row][pool_col] <= pool2;
            feature_mem3[pool_row][pool_col] <= pool3;

            //--------------------------------------------------
            // Start flattening after the final pool position
            //--------------------------------------------------

            if((pool_row == 4'd6) &&
               (pool_col == 4'd6))
            begin
                flattening <= 1'b1;

                channel  <= 0;
                read_row <= 0;
                read_col <= 0;

                flat_index <= 0;
            end

        end

        //------------------------------------------------------
        // Flatten operation
        //------------------------------------------------------

        if(flattening)
        begin

            //--------------------------------------------------
            // Channel 0
            //--------------------------------------------------

            if(channel == 0)
                flat_data <= feature_mem0[read_row][read_col];

            //--------------------------------------------------
            // Channel 1
            //--------------------------------------------------

            else if(channel == 1)
                flat_data <= feature_mem1[read_row][read_col];

            //--------------------------------------------------
            // Channel 2
            //--------------------------------------------------

            else if(channel == 2)
                flat_data <= feature_mem2[read_row][read_col];

            //--------------------------------------------------
            // Channel 3
            //--------------------------------------------------

            else
                flat_data <= feature_mem3[read_row][read_col];

            flat_valid <= 1'b1;

            //--------------------------------------------------
            // Flatten index
            //--------------------------------------------------

            flat_index <=
                channel * 8'd49 +
                read_row * 8'd7 +
                read_col;

            //--------------------------------------------------
            // Move to next value
            //--------------------------------------------------

            if(read_col == 4'd6)
            begin

                read_col <= 0;

                if(read_row == 4'd6)
                begin

                    read_row <= 0;

                    if(channel == 2'd3)
                    begin
                        channel <= 0;
                        flattening <= 1'b0;
                    end
                    else
                    begin
                        channel <= channel + 1'b1;
                    end

                end
                else
                begin
                    read_row <= read_row + 1'b1;
                end

            end
            else
            begin
                read_col <= read_col + 1'b1;
            end

        end

    end

end

endmodule