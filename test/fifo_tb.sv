module FIFO_TB;

  	reg clk;
  	reg rst;

  	reg[7:0] data;
  	reg[7:0] queue_data;

  	reg read;
  	reg write;

  	reg empty;
  	reg full;

	FIFO #(.width(8), .depth(8)) fifo(clk, rst, read, write, empty, full, data, queue_data);

	initial begin
        clk = 0; data = 8'd0;
    	rst = 1; clk = 1; #1 ; clk = 0; #1;
    	rst = 0;
    
    	$display("Start testing");

    	// First write some data into the queue
    	write = 1; read = 0;
    	data = 8'd100;
    	clk = 1; #1 ; clk = 0; #1;
    	data = 8'd150;
    	clk = 1; #1 ; clk = 0; #1;
    	data = 8'd200;
    	clk = 1; #1 ; clk = 0; #1;
    	data = 8'd40;
 	    clk = 1; #1 ; clk = 0; #1;
    	data = 8'd70;	
	    clk = 1; #1 ; clk = 0; #1;
    	data = 8'd65;
    	clk = 1; #1 ; clk = 0; #1;
    	data = 8'd15;
    	clk = 1; #1 ; clk = 0; #1;
    
    	// Now start reading and checking the values
    	write = 0; read = 1;
   		clk = 1; #1 ; clk = 0; #1;
    	if ( queue_data === 8'd100 )
      		$display("PASS %h ", queue_data);
    	else
      		$display("FAIL %h ", queue_data);

    	clk = 1; #1 ; clk = 0; #1;
    	if ( queue_data === 8'd150 )
      		$display("PASS %h ", queue_data);
    	else
      		$display("FAIL %h ", queue_data);

    	clk = 1; #1 ; clk = 0; #1;
    	if ( queue_data === 8'd200 )
      		$display("PASS %h ", queue_data);
    	else
      		$display("FAIL %h ", queue_data);

    	clk = 1; #1 ; clk = 0; #1;
    	if ( queue_data === 8'd40 )
      		$display("PASS %h ", queue_data);
    	else
      		$display("FAIL %h ", queue_data);

    	clk = 1; #1 ; clk = 0; #1;
    	if ( queue_data === 8'd70 )
      		$display("PASS %h ", queue_data);
    	else
      		$display("FAIL %h ", queue_data);

    	clk = 1; #1 ; clk = 0; #1;
    	if ( queue_data === 8'd65 )
      		$display("PASS %h ", queue_data);
    	else
      		$display("FAIL %h ", queue_data);

    	clk = 1; #1 ; clk = 0; #1;
    	if ( queue_data === 8'd15 )
      		$display("PASS %h ", queue_data);
    	else
      		$display("FAIL %h ", queue_data);

		clk = 1; #1 ; clk = 0; #1;
    	if ( queue_data === 8'd15 )
      		$display("PASS %h ", queue_data);
    	else
      		$display("FAIL %h ", queue_data);

		clk = 1; #1 ; clk = 0; #1;
    	if ( queue_data === 8'd15 )
      		$display("PASS %h ", queue_data);
    	else
      		$display("FAIL %h ", queue_data);

		clk = 1; #1 ; clk = 0; #1;
    	if ( queue_data === 8'd15 )
      		$display("PASS %h ", queue_data);
    	else
      		$display("FAIL %h ", queue_data);

    	clk = 1; #1 ; clk = 0; #1;
    	if ( empty === 1 )
      		$display("PASS %h ", empty);
    	else
      		$display("FAIL %h ", empty);
  	end

endmodule    