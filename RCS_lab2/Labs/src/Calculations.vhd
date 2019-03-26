

library IEEE;
use IEEE.STD_LOGIC_1164.all, arr.all;

package calculator is 
	
	function distribution(M:iarr; N:integer; K:integer; dX:integer) return rarr;
	function autocorrelation(x:iarr; k:	integer) return rarr; 
	
	
end package;


package body calculator is
	
	function distribution(M:iarr; N:integer; K:integer; dX:integer) return rarr is
		 variable p : rarr (1 to K);
	begin
		for i in 1 to K loop
			p(i) := real(M(i) * K) / real(N * dX );
		end loop;
		return p;
	end function;
	
	
	function autocorrelation(x:iarr; k:	integer) return rarr is
	variable R: rarr(0 to k-1);
	variable temp:real;
	begin
		for i in 0 to k-1 loop
			temp := 0.0;
			for j in 1 to x'high - k loop
				temp := temp + real(x(j)*x(j+i)) ;
			end loop;
			R(i) := temp / real(x'high - k);
		end loop;
		return R;
	end function;
	
end package body;


library IEEE;
use IEEE.STD_LOGIC_1164.all, arr.all, IEEE.NUMERIC_BIT.all, CNetwork.all;
entity autocorrelator is
	generic(
		K: natural := 500
	);
	port(
		CLK, WR, RD: in bit;
		X: in integer;
		Y: out real
	);
end autocorrelator;

architecture beh of autocorrelator is
	signal R: rarr(1 to K);
	signal mem: iarr (1 to K);
	signal nctr: natural:=0;
begin
	
end beh;

		
		
		
