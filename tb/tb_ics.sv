//##################################################################################################
/*
Project / Module    : tb_ics
File name           : tb_ics.sv
Version             : 1-0
Date created        : 5 MAY 2025
Author              : Elveis Ng Kai Wei
Code type           : Behavioural (System Verilog)
Description         : Testbench for ICS, testing for the whole ICS behaviour
*/
//##################################################################################################

`define PERIOD_CLK 10

module tb_ics ();
    
// Inputs of hexcb
    logic               tb_ip_clk, tb_ip_reset;
    logic [3:0]         tb_ip_nurow, tb_ip_oprow;
    
//**************************************************************************************************
// Output of hexcb
    wire [3:0]         tb_op_nucol, tb_op_opcol, tb_op_sel;
    wire [6:0]         tb_op_seg;

//**************************************************************************************************
// Module instantiation

    ics 
    dut_ics 
    (
       .ip_sys_clk(tb_ip_clk),
       .ip_sys_reset(tb_ip_reset),
       .ip_c_sync_nurow(tb_ip_nurow), 
	   .ip_c_sync_oprow(tb_ip_oprow), 
	   .op_c_hexc_nucol(tb_op_nucol),
	   .op_c_hexc_opcol(tb_op_opcol), 
	   .op_c_iocb_seg(tb_op_seg), 
	   .op_c_iocb_sel(tb_op_sel)
    );
    
//**************************************************************************************************
// Clock waveform generation
    initial tb_ip_clk = 0;
    always #(`PERIOD_CLK / 2)   tb_ip_clk <= ~tb_ip_clk; 
    
    
    initial begin
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Signal initializaiton
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

        tb_ip_reset = 1'b0;
	    tb_ip_nurow = 4'b1111;
        tb_ip_oprow = 4'b1111;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Test case 1: System Reset
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

        tb_ip_reset = 1'b1;
        #(`PERIOD_CLK)
        tb_ip_reset = 1'b0;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Test case 2: Reset During Operation
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        
        // Press 5    
        #(`PERIOD_CLK * 4)
        wait(tb_op_nucol == 4'b1011); // find Col3 to match Col2
        tb_ip_nurow = 4'b1101;
        #(`PERIOD_CLK * 2)
        tb_ip_nurow = 4'b1111;
        
        // Reset
        #(`PERIOD_CLK * 12)
        tb_ip_reset = 1'b1;
        #(`PERIOD_CLK)
        tb_ip_reset = 1'b0;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Test case 3: Explicit Compute
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        
        // Press 5    
        #(`PERIOD_CLK * 6)
        wait(tb_op_nucol == 4'b1011); // find Col3 to match Col2
        tb_ip_nurow = 4'b1101;
        #(`PERIOD_CLK * 2)
        tb_ip_nurow = 4'b1111;
        
        // Press +
        #(`PERIOD_CLK * 6)
        wait(tb_op_opcol == 4'b1101); // find Col2 to match Col0
        tb_ip_oprow = 4'b1110;
        #(`PERIOD_CLK * 2)
        tb_ip_oprow = 4'b1111;
        
        // Press 3
        #(`PERIOD_CLK * 6)
        wait(tb_op_nucol == 4'b0111); // find Col2 to match Col0
        tb_ip_nurow = 4'b1110;
        #(`PERIOD_CLK * 2)
        tb_ip_nurow = 4'b1111;
        
        // Reset
        #(`PERIOD_CLK * 14)
        tb_ip_reset = 1'b1;
        #(`PERIOD_CLK)
        tb_ip_reset = 1'b0;
        
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Test case 4: Addition ( 150 + 9 )
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

        // Press 1
        #(`PERIOD_CLK * 4)
        wait(tb_op_nucol == 4'b1101); // find Col2 to match Col0
        tb_ip_nurow = 4'b1110;
        #(`PERIOD_CLK * 2)
        tb_ip_nurow = 4'b1111;
        
        // Press 5    
        #(`PERIOD_CLK * 6)
        wait(tb_op_nucol == 4'b1011); // find Col3 to match Col2
        tb_ip_nurow = 4'b1101;
        #(`PERIOD_CLK * 2)
        tb_ip_nurow = 4'b1111;
        
        // Press 0    
        #(`PERIOD_CLK * 6)
        wait(tb_op_nucol == 4'b1011); // find Col3 to match Col1
        tb_ip_nurow = 4'b0111;
        #(`PERIOD_CLK * 2)
        tb_ip_nurow = 4'b1111;
        
        // Press +
        #(`PERIOD_CLK * 6)
        wait(tb_op_opcol == 4'b1101); // find Col2 to match Col0
        tb_ip_oprow = 4'b1110;
        #(`PERIOD_CLK * 2)
        tb_ip_oprow = 4'b1111;
        
        // Press 9
        #(`PERIOD_CLK * 6)
        wait(tb_op_nucol == 4'b0111); // find Col3 to match Col2
        tb_ip_nurow = 4'b1011;
        #(`PERIOD_CLK * 2)
        tb_ip_nurow = 4'b1111;
        
        // Press =
        #(`PERIOD_CLK * 6)
        wait((tb_op_opcol == 4'b0111)); // find Col3 to match Col2
        tb_ip_oprow = 4'b0111;
        #(`PERIOD_CLK * 2)
        tb_ip_oprow = 4'b1111;
        
        // Reset
        #(`PERIOD_CLK * 12)
        tb_ip_reset = 1'b1;
        #(`PERIOD_CLK)
        tb_ip_reset = 1'b0;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Test case 5: Addition ( 50 - 12 )
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

        // Press 5    
        #(`PERIOD_CLK * 6)
        wait(tb_op_nucol == 4'b1011); // find Col3 to match Col2
        tb_ip_nurow = 4'b1101;
        #(`PERIOD_CLK * 2)
        tb_ip_nurow = 4'b1111;
        
        // Press 0    
        #(`PERIOD_CLK * 6)
        wait(tb_op_nucol == 4'b1011); // find Col3 to match Col1
        tb_ip_nurow = 4'b0111;
        #(`PERIOD_CLK * 2)
        tb_ip_nurow = 4'b1111;
        
        // Press -
        #(`PERIOD_CLK * 8)
        wait(tb_op_opcol == 4'b1101); // find Col2 to match Col0
        tb_ip_oprow = 4'b1101;
        #(`PERIOD_CLK * 2)
        tb_ip_oprow = 4'b1111;
        
        // Press 1
        #(`PERIOD_CLK * 6)
        wait(tb_op_nucol == 4'b1101); // find Col2 to match Col0
        tb_ip_nurow = 4'b1110;
        #(`PERIOD_CLK * 2)
        tb_ip_nurow = 4'b1111;
        
        // Press 2
        #(`PERIOD_CLK * 6)
        wait(tb_op_nucol == 4'b1011); // find Col2 to match Col0
        tb_ip_nurow = 4'b1110;
        #(`PERIOD_CLK * 2)
        tb_ip_nurow = 4'b1111;
        
        // Press =
        #(`PERIOD_CLK * 6)
        wait((tb_op_opcol == 4'b0111)); // find Col3 to match Col2
        tb_ip_oprow = 4'b0111;
        #(`PERIOD_CLK * 2)
        tb_ip_oprow = 4'b1111;
        
        // Reset
        #(`PERIOD_CLK * 12)
        tb_ip_reset = 1'b1;
        #(`PERIOD_CLK)
        tb_ip_reset = 1'b0;
        
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Test case 6: Multiplication ( 3 * 4 )
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        
        // Press 3
        #(`PERIOD_CLK * 6)
        wait(tb_op_nucol == 4'b0111); // find Col2 to match Col0
        tb_ip_nurow = 4'b1110;
        #(`PERIOD_CLK * 2)
        tb_ip_nurow = 4'b1111;
        
        // Press *
        #(`PERIOD_CLK * 6)
        wait(tb_op_opcol == 4'b1101); // find Col2 to match Col0
        tb_ip_oprow = 4'b1011;
        #(`PERIOD_CLK * 2)
        tb_ip_oprow = 4'b1111;
        
        // Press 4
        #(`PERIOD_CLK * 6)
        wait(tb_op_nucol == 4'b1101); // find Col2 to match Col0
        tb_ip_nurow = 4'b1101;
        #(`PERIOD_CLK * 2)
        tb_ip_nurow = 4'b1111;
        
        // Press =
        #(`PERIOD_CLK * 6)
        wait((tb_op_opcol == 4'b0111)); // find Col3 to match Col2
        tb_ip_oprow = 4'b0111;
        #(`PERIOD_CLK * 2)
        tb_ip_oprow = 4'b1111;
        
        // Reset
        #(`PERIOD_CLK * 10)
        tb_ip_reset = 1'b1;
        #(`PERIOD_CLK)
        tb_ip_reset = 1'b0;
        
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Test case 7: Division ( 8 / 2 )
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        
        // Press 8
        #(`PERIOD_CLK * 6)
        wait(tb_op_nucol == 4'b1011); // find Col2 to match Col0
        tb_ip_nurow = 4'b1011;
        #(`PERIOD_CLK * 2)
        tb_ip_nurow = 4'b1111;
        
        // Press /
        #(`PERIOD_CLK * 6)
        wait(tb_op_opcol == 4'b1101); // find Col2 to match Col0
        tb_ip_oprow = 4'b0111;
        #(`PERIOD_CLK * 2)
        tb_ip_oprow = 4'b1111;
        
        // Press 2
        #(`PERIOD_CLK * 6)
        wait(tb_op_nucol == 4'b1011); // find Col2 to match Col0
        tb_ip_nurow = 4'b1110;
        #(`PERIOD_CLK * 2)
        tb_ip_nurow = 4'b1111;
        
        // Press =
        #(`PERIOD_CLK * 6)
        wait((tb_op_opcol == 4'b0111)); // find Col3 to match Col2
        tb_ip_oprow = 4'b0111;
        #(`PERIOD_CLK * 2)
        tb_ip_oprow = 4'b1111;
        
        // Reset
        #(`PERIOD_CLK * 11)
        tb_ip_reset = 1'b1;
        #(`PERIOD_CLK)
        tb_ip_reset = 1'b0;
        
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Test case 8: Division by Zero ( 8 / 0 )
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

        // Press 8
        #(`PERIOD_CLK * 6)
        wait(tb_op_nucol == 4'b1011); // find Col2 to match Col0
        tb_ip_nurow = 4'b1011;
        #(`PERIOD_CLK * 2)
        tb_ip_nurow = 4'b1111;
        
        // Press /
        #(`PERIOD_CLK * 6)
        wait(tb_op_opcol == 4'b1101); // find Col2 to match Col0
        tb_ip_oprow = 4'b0111;
        #(`PERIOD_CLK * 2)
        tb_ip_oprow = 4'b1111;
        
        // Press 0    
        #(`PERIOD_CLK * 6)
        wait(tb_op_nucol == 4'b1011); // find Col3 to match Col1
        tb_ip_nurow = 4'b0111;
        #(`PERIOD_CLK * 2)
        tb_ip_nurow = 4'b1111;
        
        // Press =
        #(`PERIOD_CLK * 6)
        wait((tb_op_opcol == 4'b0111)); // find Col3 to match Col2
        tb_ip_oprow = 4'b0111;
        #(`PERIOD_CLK * 2)
        tb_ip_oprow = 4'b1111;
        
        // Reset
        #(`PERIOD_CLK * 11)
        tb_ip_reset = 1'b1;
        #(`PERIOD_CLK)
        tb_ip_reset = 1'b0;
        
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Test case 9: AND Bitwise Operation ( 5 & 3 )
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        
        // Press 5    
        #(`PERIOD_CLK * 6)
        wait(tb_op_nucol == 4'b1011); // find Col3 to match Col2
        tb_ip_nurow = 4'b1101;
        #(`PERIOD_CLK * 2)
        tb_ip_nurow = 4'b1111;
        
        // Press &
        #(`PERIOD_CLK * 6)
        wait(tb_op_opcol == 4'b1011); // find Col2 to match Col0
        tb_ip_oprow = 4'b1110;
        #(`PERIOD_CLK * 2)
        tb_ip_oprow = 4'b1111;
        
        // Press 3
        #(`PERIOD_CLK * 6)
        wait(tb_op_nucol == 4'b0111); // find Col2 to match Col0
        tb_ip_nurow = 4'b1110;
        #(`PERIOD_CLK * 2)
        tb_ip_nurow = 4'b1111;
        
        // Press =
        #(`PERIOD_CLK * 6)
        wait((tb_op_opcol == 4'b0111)); // find Col3 to match Col2
        tb_ip_oprow = 4'b0111;
        #(`PERIOD_CLK * 2)
        tb_ip_oprow = 4'b1111;
        
        // Reset
        #(`PERIOD_CLK * 11)
        tb_ip_reset = 1'b1;
        #(`PERIOD_CLK)
        tb_ip_reset = 1'b0;
        
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Test case 10: OR Bitwise Operation ( 5 | 3 )
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

        // Press 5    
        #(`PERIOD_CLK * 6)
        wait(tb_op_nucol == 4'b1011); // find Col3 to match Col2
        tb_ip_nurow = 4'b1101;
        #(`PERIOD_CLK * 2)
        tb_ip_nurow = 4'b1111;
        
        // Press |
        #(`PERIOD_CLK * 6)
        wait(tb_op_opcol == 4'b1011); // find Col2 to match Col0
        tb_ip_oprow = 4'b1101;
        #(`PERIOD_CLK * 2)
        tb_ip_oprow = 4'b1111;
        
        // Press 3
        #(`PERIOD_CLK * 6)
        wait(tb_op_nucol == 4'b0111); // find Col2 to match Col0
        tb_ip_nurow = 4'b1110;
        #(`PERIOD_CLK * 2)
        tb_ip_nurow = 4'b1111;
        
        // Press =
        #(`PERIOD_CLK * 6)
        wait((tb_op_opcol == 4'b0111)); // find Col3 to match Col2
        tb_ip_oprow = 4'b0111;
        #(`PERIOD_CLK * 2)
        tb_ip_oprow = 4'b1111;
        
        // Reset
        #(`PERIOD_CLK * 11)
        tb_ip_reset = 1'b1;
        #(`PERIOD_CLK)
        tb_ip_reset = 1'b0;
        
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Test case 11: XOR Bitwise Operation ( 5 ^ 3 )
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

        // Press 5    
        #(`PERIOD_CLK * 6)
        wait(tb_op_nucol == 4'b1011); // find Col3 to match Col2
        tb_ip_nurow = 4'b1101;
        #(`PERIOD_CLK * 2)
        tb_ip_nurow = 4'b1111;
        
        // Press ^
        #(`PERIOD_CLK * 6)
        wait(tb_op_opcol == 4'b1011); // find Col2 to match Col0
        tb_ip_oprow = 4'b1011;
        #(`PERIOD_CLK * 2)
        tb_ip_oprow = 4'b1111;
        
        // Press 3
        #(`PERIOD_CLK * 6)
        wait(tb_op_nucol == 4'b0111); // find Col2 to match Col0
        tb_ip_nurow = 4'b1110;
        #(`PERIOD_CLK * 2)
        tb_ip_nurow = 4'b1111;
        
        // Press =
        #(`PERIOD_CLK * 6)
        wait((tb_op_opcol == 4'b0111)); // find Col3 to match Col2
        tb_ip_oprow = 4'b0111;
        #(`PERIOD_CLK * 2)
        tb_ip_oprow = 4'b1111;
        
        // Reset
        #(`PERIOD_CLK * 11)
        tb_ip_reset = 1'b1;
        #(`PERIOD_CLK)
        tb_ip_reset = 1'b0;
        
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Test case 12: NOT Bitwise Operation ( ~ 3 )
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

         // Press ~
        #(`PERIOD_CLK * 6)
        wait(tb_op_opcol == 4'b1011); // find Col2 to match Col0
        tb_ip_oprow = 4'b0111;
        #(`PERIOD_CLK * 2)
        tb_ip_oprow = 4'b1111;
        
        // Press 3
        #(`PERIOD_CLK * 6)
        wait(tb_op_nucol == 4'b0111); // find Col2 to match Col0
        tb_ip_nurow = 4'b1110;
        #(`PERIOD_CLK * 2)
        tb_ip_nurow = 4'b1111;
        
        // Press =
        #(`PERIOD_CLK * 6)
        wait((tb_op_opcol == 4'b0111)); // find Col3 to match Col2
        tb_ip_oprow = 4'b0111;
        #(`PERIOD_CLK * 2)
        tb_ip_oprow = 4'b1111;
        
        // Reset
        #(`PERIOD_CLK * 11)
        tb_ip_reset = 1'b1;
        #(`PERIOD_CLK)
        tb_ip_reset = 1'b0;       

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Test case 13: Left Shift ( 3 << 2 )
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        
        // Press 3
        #(`PERIOD_CLK * 6)
        wait(tb_op_nucol == 4'b0111); // find Col2 to match Col0
        tb_ip_nurow = 4'b1110;
        #(`PERIOD_CLK * 2)
        tb_ip_nurow = 4'b1111;
        
         // Press <<
        #(`PERIOD_CLK * 8)
        wait(tb_op_opcol == 4'b0111); // find Col2 to match Col0
        tb_ip_oprow = 4'b1110;
        #(`PERIOD_CLK * 2)
        tb_ip_oprow = 4'b1111;
        
        // Press 2
        #(`PERIOD_CLK * 8)
        wait(tb_op_nucol == 4'b1011); // find Col2 to match Col0
        tb_ip_nurow = 4'b1110;
        #(`PERIOD_CLK * 2)
        tb_ip_nurow = 4'b1111;
        
        // Press =
        #(`PERIOD_CLK * 8)
        wait((tb_op_opcol == 4'b0111)); // find Col3 to match Col2
        tb_ip_oprow = 4'b0111;
        #(`PERIOD_CLK * 2)
        tb_ip_oprow = 4'b1111;
        
        // Reset
        #(`PERIOD_CLK * 11)
        tb_ip_reset = 1'b1;
        #(`PERIOD_CLK)
        tb_ip_reset = 1'b0;       

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Test case 14: Right Shift ( 6 >> 2 )
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        
        // Press 6
        #(`PERIOD_CLK * 6)
        wait(tb_op_nucol == 4'b0111); // find Col2 to match Col0
        tb_ip_nurow = 4'b1101;
        #(`PERIOD_CLK * 2)
        tb_ip_nurow = 4'b1111;
        
         // Press >> 
        #(`PERIOD_CLK * 6)
        wait(tb_op_opcol == 4'b0111); // find Col2 to match Col0
        tb_ip_oprow = 4'b1101;
        #(`PERIOD_CLK * 2)
        tb_ip_oprow = 4'b1111;
        
        // Press 2
        #(`PERIOD_CLK * 6)
        wait(tb_op_nucol == 4'b1011); // find Col2 to match Col0
        tb_ip_nurow = 4'b1110;
        #(`PERIOD_CLK * 2)
        tb_ip_nurow = 4'b1111;
        
        // Press =
        #(`PERIOD_CLK * 6)
        wait((tb_op_opcol == 4'b0111)); // find Col3 to match Col2
        tb_ip_oprow = 4'b0111;
        #(`PERIOD_CLK * 2)
        tb_ip_oprow = 4'b1111;
        
        // Reset
        #(`PERIOD_CLK * 11)
        tb_ip_reset = 1'b1;
        #(`PERIOD_CLK)
        tb_ip_reset = 1'b0;       

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Test case 15: Negatif Result ( 2 - 5 )
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

        // Press 2
        #(`PERIOD_CLK * 6)
        wait(tb_op_nucol == 4'b1011); // find Col2 to match Col0
        tb_ip_nurow = 4'b1110;
        #(`PERIOD_CLK * 2)
        tb_ip_nurow = 4'b1111;
        
        // Press -
        #(`PERIOD_CLK * 6)
        wait(tb_op_opcol == 4'b1101); // find Col2 to match Col0
        tb_ip_oprow = 4'b1101;
        #(`PERIOD_CLK * 2)
        tb_ip_oprow = 4'b1111;
        
        // Press 5    
        #(`PERIOD_CLK * 6)
        wait(tb_op_nucol == 4'b1011); // find Col3 to match Col2
        tb_ip_nurow = 4'b1101;
        #(`PERIOD_CLK * 2)
        tb_ip_nurow = 4'b1111;
        
        // Press =
        #(`PERIOD_CLK * 6)
        wait((tb_op_opcol == 4'b0111)); // find Col3 to match Col2
        tb_ip_oprow = 4'b0111;
        #(`PERIOD_CLK * 2)
        tb_ip_oprow = 4'b1111;
        
        // Reset
        #(`PERIOD_CLK * 11)
        tb_ip_reset = 1'b1;
        #(`PERIOD_CLK)
        tb_ip_reset = 1'b0;
        
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Test case 16: Overflow Detection ( 250 + 6 )
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

        // Press 2
        #(`PERIOD_CLK * 6)
        wait(tb_op_nucol == 4'b1011); // find Col2 to match Col0
        tb_ip_nurow = 4'b1110;
        #(`PERIOD_CLK * 2)
        tb_ip_nurow = 4'b1111;
        
        // Press 5    
        #(`PERIOD_CLK * 6)
        wait(tb_op_nucol == 4'b1011); // find Col3 to match Col2
        tb_ip_nurow = 4'b1101;
        #(`PERIOD_CLK * 2)
        tb_ip_nurow = 4'b1111;
        
        // Press 0    
        #(`PERIOD_CLK * 6)
        wait(tb_op_nucol == 4'b1011); // find Col3 to match Col1
        tb_ip_nurow = 4'b0111;
        #(`PERIOD_CLK * 2)
        tb_ip_nurow = 4'b1111;
        
        // Press +
        #(`PERIOD_CLK * 6)
        wait(tb_op_opcol == 4'b1101); // find Col2 to match Col0
        tb_ip_oprow = 4'b1110;
        #(`PERIOD_CLK * 2)
        tb_ip_oprow = 4'b1111;
        
        // Press 6
        #(`PERIOD_CLK * 6)
        wait(tb_op_nucol == 4'b0111); // find Col2 to match Col0
        tb_ip_nurow = 4'b1101;
        #(`PERIOD_CLK * 2)
        tb_ip_nurow = 4'b1111;
        
        // Press =
        #(`PERIOD_CLK * 6)
        wait((tb_op_opcol == 4'b0111)); // find Col3 to match Col2
        tb_ip_oprow = 4'b0111;
        #(`PERIOD_CLK * 2)
        tb_ip_oprow = 4'b1111;
        
        // Reset
        #(`PERIOD_CLK * 11)
        tb_ip_reset = 1'b1;
        #(`PERIOD_CLK)
        tb_ip_reset = 1'b0;
    
       $stop;
    end
endmodule