class Packet;

	rand	reg	[15:0] 	Instr_dout;		//Input to the Dut 
	rand    reg     [15:0]  Data_dout;

	string 	name;
	
	constraint Limit {
	
		Data_dout  inside {[0:65535]};
		
		
		//Instr_dout[15:12] inside	{[2:2] ,[6:6] , [10:10] , [0:0] , [12:12]};
		//Instr_dout[15:12] inside	{[2:2] ,[6:6] , [10:10],[3:3] ,[7:7] , [11:11]};
		//Instr_dout[15:12] dist	{[5:5]:/70 , [12:12]:/30 , [0:0]:/30};
		//Instr_dout[15:12] inside	{[0:0] ,[12:12] , [1:1] , [5:5]};   //error
		//Instr_dout[15:12] inside	{[0:0] , [12:12] , [1:1]};
	       //Instr_dout[15:12]  dist	{ 12:= 60,1:=30,2:=30,3:=45,6:=20 , 10:=30 , 14:=30 , 9:=20 , 0:=40};  // For producing randomized inputs with weighted probability to get different instructions faster
		
		//Instr_dout[15:12]  dist	{ 12:=10,2:=30,6:=30,3:=45,10:=20 , 10:=30 , 14:=30 , 9:=20 , 0:=10}; 
		
		
		//Instr_dout[15:12]  dist	{[0:3]:/60,[5:7]:/60,[9:12]:/80,[14:14]:/10};  //  ERROR For producing randomized inputs with weighted probability to get different instructions faster
		Instr_dout[15:12]  dist	{[0:3]:/40,[5:7]:/30,[9:12]:/40,[14:14]:/10};  // For producing randomized inputs with weighted probability to get different instructions faster
		//Instr_dout[15:12] inside	{[7:7]};
		//Instr_dout[15:12]  inside  {[2:2],[6:6],[10:10] ,[3:3] ,[7:7] , [11:11] , [0:0] , [12:12]};
		//Instr_dout[15:12]  inside {[14:14] , [2:2] , [6:6] , [10:10]};  //error
		
		
		
		
		
		/////////////////////////////////////////ALU Instruction//////////////////////////////////	
		if  ( Instr_dout[15:12] inside {[1:1] ,[5:5] ,[9:9] })
		{
		
		Instr_dout[11:9] inside	{[0:$]};                     
		
	
		if((Instr_dout[15:12]== 4'd1)|| (Instr_dout[15:12]== 4'd5))
				{
					Instr_dout[8:6] inside {[0:$]};
					Instr_dout[5] inside {[0:1]};
						if(Instr_dout[5] == 1'd0)
							{
								Instr_dout[4:3] inside {[0:0]};
								Instr_dout[2:0] inside {[0:$]};
							}
						else if (Instr_dout[5] == 1'd1)
							{
								Instr_dout[4:0] inside {[0:$]};
							}
				}
			
		else if (Instr_dout[15:12]== 4'd9)
				{
					Instr_dout[8:6] inside {[0:$]};
					Instr_dout[5:0] inside {[63:63]};
				}	
		     	
		
		}
		
		/////////////////////////////////////////Memory Instruction/////////////////////////////////////////
		else if( Instr_dout[15:12] inside {[2:2] ,[6:6] ,[10:10] ,[14:14] ,[3:3] , [7:7] ,[11:11] } )
		{
			Instr_dout[11:9] inside	{[0:$]}; 
			
		if( (Instr_dout[15:12]== 4'd6) || (Instr_dout[15:12]== 4'd7))
			{
			Instr_dout[8:6] inside	{[0:$]};
			Instr_dout[5:0] inside	{[0:$]};
			}
		else
			Instr_dout[8:0] inside	{[0:$]};
		}
		
		/////////////////////////////Control Instruction////////////////////////////////////////////////////
			else if( Instr_dout[15:12] inside {[0:0] , [12:12] } )
		{
	
		if (Instr_dout[15:12]== 4'd0)
			{
				Instr_dout[11:9] inside {[1:$]} ;
				Instr_dout[8:0] inside	{[0:$]};
			}
		else if (Instr_dout[15:12]== 4'd12)
			{
				Instr_dout[11:9] == 0;
				Instr_dout[8:6] inside	{[0:$]};
				Instr_dout[5:0]  == 0;
			}
		}
		
	}
	
	
	extern function new(string name = "Packet");
endclass

function Packet::new(string name = "Packet");
	this.name = name;
endfunction

