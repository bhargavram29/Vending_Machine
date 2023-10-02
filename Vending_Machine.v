`timescale 1ns / 1ps
module vending_machine(
  input [9:0]amount,
  input [9:0]rem_amount,
  input enter,
  input [3:0]choice,
  input [1:0]select,
  input clk,
  input reset,
  input cancel,
  output reg[9:0] change,
  output reg item,
  output reg [9:0]back_amount,
  output reg [0:3]St
    );
    
  reg [7:0]newamount;
  reg [4:0]index;
  reg [7:0]balance;
  reg [31:0]count;
  reg [7:0]amt_retur_success;
  reg [7:0]chng_success;
  reg [7:0]entr_remai_amt;
  reg [7:0]price;
  reg [0:3] state;
  integer i;
  //Items Database register
  reg [3:0]hot_item[0:9];
  reg [7:0]h_price[0:9];
  reg [3:0]h_stock[0:9];
  
  reg [3:0]cold_item[0:9];
  reg [7:0]c_price[0:9];
  reg [3:0]c_stock[0:9];
  
  initial
    begin
      //Hot beverages database
      hot_item[0]=0;
      h_price[0]=0;
      h_stock[0]=0;
      
      hot_item[1]=1;
      h_price[1]=10;
      h_stock[1]=5;
      
      hot_item[2]=2;
      h_price[2]=15;
      h_stock[2]=5;
      
      hot_item[3]=3;
      h_price[3]=20;
      h_stock[3]=5;
      
      hot_item[4]=4;
      h_price[4]=25;
      h_stock[4]=5;
      
      hot_item[5]=5;
      h_price[5]=30;
      h_stock[5]=5;
      
      hot_item[6]=6;
      h_price[6]=35;
      h_stock[6]=5;
      
      hot_item[7]=7;
      h_price[7]=40;
      h_stock[7]=5;      
      
      hot_item[8]=8;
      h_price[8]=55;
      h_stock[8]=5; 
      
      hot_item[9]=9;
      h_price[9]=60;
      h_stock[9]=5; 
      
      //colde beverages database
      
      cold_item[0]=0;
      c_price[0]=0;
      c_stock[0]=0;
      
      cold_item[1]=1;
      c_price[1]=15;
      c_stock[1]=5;
      
      cold_item[2]=2;
      c_price[2]=25;
      c_stock[2]=5;
      
      cold_item[3]=3;
      c_price[3]=35;
      c_stock[3]=5;
      
      cold_item[4]=4;
      c_price[4]=45;
      c_stock[4]=5;
      
      cold_item[5]=5;
      c_price[5]=55;
      c_stock[5]=5;
      
      cold_item[6]=6;
      c_price[6]=65;
      c_stock[6]=5;
      
      cold_item[7]=7;
      c_price[7]=75;
      c_stock[7]=5;      
      
      cold_item[8]=8;
      c_price[8]=85;
      c_stock[8]=5; 
      
      cold_item[9]=9;
      c_price[9]=60;
      c_stock[9]=5;          
    end
  
localparam Idle                 	=4'b0000;
localparam Menu				    	=4'b0001;
localparam Hot                  	=4'b0010;
localparam Cold	                    =4'b0011;
localparam Compare              	=4'b0100;
localparam Change		        	=4'b0101;
localparam Enter_Remaining_amount   =4'b0110;
localparam Give_money_Back      	=4'b0111;
localparam Item_Dispensed       	=4'b1000;
  
always@(posedge clk)
  begin
    if(reset)
      begin
		newamount<=0;
		index<=0;
		balance<=0;
		count<=0;
		amt_retur_success<=0;
		chng_success<=0;
		entr_remai_amt<=0;
		price<=0;
        back_amount<=0;
        item<=0;
        change<=0;		
        state=Idle;
        St=state; 
        end
    
    else
      begin
        case(state)  
          Idle:
            begin
            item=0;
            change=0;
            $display("state: %d", state);
				if(amount!=0)
				state=Menu;
				St=state;
				  $display("state: %d", state);

            end
          Menu:
            begin
            
             if(cancel)
                begin
                state<=Give_money_Back;
                St=state;
                end
                
                
             if(select==2'b01)
             begin
                state=Hot;
                St=state;
			
              end  
           else if(select==2'b10)
                begin
                state=Cold;
                St=state; 
                
                end           
           else if(cancel)
                begin
                state=Give_money_Back;
                St=state;
                
                end
		   else if(select==2'b00)
			    begin
				count=count+1;
				if(count==15)
				begin
				state<=Give_money_Back;
				St=state;
				count=0;
				end
				else
				state<=Menu;
				St=state;
				end
				 $display("state: %d", state); 
            end
				
           Hot:
            begin
                if(cancel)
                begin
                state<=Give_money_Back;
                St=state;
                end
              $display("select the item");
              if(choice>8)
              begin
              $display("INVALID choice");
              end 
             else if((choice<=8)&&(enter)) begin 
                for(i=0;i<10;i=i+1)begin
                if(hot_item[i]==choice)begin
                index<=i;
                if (h_stock[i]==0)begin 
                $display("Item is Out of stock , please select other item");
                state<=Menu;
				St=state;
                end
				else
                price= h_price[i];
                $display("price of the item: %d",price);
                state<=Compare;
                St=state;
                end
                end
                end
                end         
 
          Cold:
            begin
            
             if(cancel)
                begin
                state<=Give_money_Back;
                St=state;
                end
                
                
            $display("state: %d", state);
              $display("select the item");
              if(choice>=9)
              begin
              $display("INVALID choice");
             
             end 
             else if((choice<9)&&(enter)) begin 
                for(i=0;i<10;i=i+1)begin
                if(cold_item[i]==choice)begin
                index<=i;
                if (c_stock[i]==0)begin 
                $display("Item is Out of stock , please select other item");
                state<=Menu;
                St=state;
                end
               price= c_price[i];
               $display("price of the item: %d",price);
                state<=Compare;
                St=state;
                end
                end
                end
                end
			
			
          Compare:          
            begin
            newamount=amount+balance;
            $display("input amount: %d",newamount);
              if(newamount==price)
                begin
                  state<=Item_Dispensed;
                  St=state;
                end
              else if(newamount>price)
                begin
                  state=Change; 
                  St=state;              
                end
              else if(newamount<price)
                begin
                  state<=Enter_Remaining_amount;
                  St=state;
                end
                balance<=0;
            end
          
          Give_money_Back:
            begin
                if(cancel)
                begin
                back_amount<=newamount;
              	amt_retur_success=1;
              	end
              if(amt_retur_success==1) begin
                $display("collect your amount");
                state<=Idle;
                St=state;
            end
            end
            
      
           Change:
             begin
               change<=$unsigned(newamount)-$unsigned(price);
               chng_success=1;
               if(chng_success==1) begin
                 $display("collect the change");
                  state<=Item_Dispensed;
                  St=state;

                 
               end
             end
            
          Enter_Remaining_amount:
            begin
            
             if(cancel)
                begin
                state<=Give_money_Back;
                St=state;
                end
                
           
                
              entr_remai_amt=$unsigned(price)-$unsigned(newamount);
              $display("enter_remaining_amount:%d",entr_remai_amt);
              if(cancel) begin
              state<= Give_money_Back;
              St=state;
              end
				  else if (rem_amount !=0)
				  begin
				  balance<= rem_amount;
				  state<=Compare;
				  St=state;
				  end
				  else if(rem_amount==0) begin
				  count=count+1;
					 if(count==15)
					 begin
					 state<=Give_money_Back;
					 St=state;
					 count=0;
					 end
					 else
					 state<=Enter_Remaining_amount;
					 St=state;
				  end
				  
              end                   
            
        Item_Dispensed:
          begin
          item=1;
          if(item==1)
          begin
          if(select==1)
          begin
          h_stock[index]<=h_stock[index]-1;
          end
          else if(select==2)
          begin
          c_stock[index]<=c_stock[index]-1;
          end
          state<=Idle;
          St=state;
          end
          end
        endcase  
        
        
      end
        
  end   
endmodule
