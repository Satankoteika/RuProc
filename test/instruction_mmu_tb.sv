module INSTRUCTION_MMU_TB;

  	reg clk;
  	reg rst;
    reg next;
    reg stop;

  	reg[31:0] instr;

    InstructionMMU mmu(clk, rst, next, stop, instr);

	initial begin
        next = 0;
        clk = 0; 
        stop = 0;
    	rst = 1; 
        clk = 1; #1 ; clk = 0; #1;
    	rst = 0;
    
    	$display("Start testing");

    	// First write some data into the queue;
        
    	clk = 1; #1 ; clk = 0; #1;
        clk = 1; #1 ; clk = 0; #1;
        clk = 1; #1 ; clk = 0; #1;
        clk = 1; #1 ; clk = 0; #1;
        clk = 1; #1 ; clk = 0; #1;
        clk = 1; #1 ; clk = 0; #1;
        clk = 1; #1 ; clk = 0; #1;
        clk = 1; #1 ; clk = 0; #1;
        clk = 1; #1 ; clk = 0; #1;
        clk = 1; #1 ; clk = 0; #1;
        clk = 1; #1 ; clk = 0; #1;
        clk = 1; #1 ; clk = 0; #1;
        clk = 1; #1 ; clk = 0; #1;
        clk = 1; #1 ; clk = 0; #1;
        clk = 1; #1 ; clk = 0; #1;
        clk = 1; #1 ; clk = 0; #1;
        clk = 1; #1 ; clk = 0; #1;
        clk = 1; #1 ; clk = 0; #1;

        $display("____________________");

        next = 1;
        clk = 1; #1 ; clk = 0; #1;
        $display("%h", instr);
        clk = 1; #1 ; clk = 0; #1;
        $display("%h", instr);
        clk = 1; #1 ; clk = 0; #1;
        $display("%h", instr);
        clk = 1; #1 ; clk = 0; #1;
        $display("%h", instr);
        clk = 1; #1 ; clk = 0; #1;
        $display("%h", instr);
        clk = 1; #1 ; clk = 0; #1;
        $display("%h", instr);
        clk = 1; #1 ; clk = 0; #1;
        $display("%h", instr);
        clk = 1; #1 ; clk = 0; #1;
        $display("%h", instr);
        clk = 1; #1 ; clk = 0; #1;
        $display("%h", instr);
        clk = 1; #1 ; clk = 0; #1;
        $display("%h", instr);
        clk = 1; #1 ; clk = 0; #1;
        $display("%h", instr);
        clk = 1; #1 ; clk = 0; #1;
        $display("%h", instr);
        clk = 1; #1 ; clk = 0; #1;
        $display("%h", instr);
        clk = 1; #1 ; clk = 0; #1;
        $display("%h", instr);
        clk = 1; #1 ; clk = 0; #1;
        $display("%h", instr);
        clk = 1; #1 ; clk = 0; #1;
        $display("%h", instr);
        clk = 1; #1 ; clk = 0; #1;
        $display("%h", instr);
        clk = 1; #1 ; clk = 0; #1;
        $display("%h", instr);
        clk = 1; #1 ; clk = 0; #1;
        $display("%h", instr);
        clk = 1; #1 ; clk = 0; #1;
        $display("%h", instr);
        clk = 1; #1 ; clk = 0; #1;
        $display("%h", instr);
        clk = 1; #1 ; clk = 0; #1;
        $display("%h", instr);
        clk = 1; #1 ; clk = 0; #1;
        $display("%h", instr);
        clk = 1; #1 ; clk = 0; #1;
        $display("%h", instr);
        clk = 1; #1 ; clk = 0; #1;
        $display("%h", instr);
        clk = 1; #1 ; clk = 0; #1;
        $display("%h", instr);
        clk = 1; #1 ; clk = 0; #1;
        $display("%h", instr);
        clk = 1; #1 ; clk = 0; #1;
        $display("%h", instr);
        clk = 1; #1 ; clk = 0; #1;
        $display("%h", instr);
        clk = 1; #1 ; clk = 0; #1;
        $display("%h", instr);
        clk = 1; #1 ; clk = 0; #1;
        $display("%h", instr);
        clk = 1; #1 ; clk = 0; #1;
        $display("%h", instr);
                clk = 1; #1 ; clk = 0; #1;
        $display("%h", instr);
                clk = 1; #1 ; clk = 0; #1;
        $display("%h", instr);
                clk = 1; #1 ; clk = 0; #1;
        $display("%h", instr);
                clk = 1; #1 ; clk = 0; #1;
        $display("%h", instr);
                clk = 1; #1 ; clk = 0; #1;
        $display("%h", instr);
  	end

endmodule