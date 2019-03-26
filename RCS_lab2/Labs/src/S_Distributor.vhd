-------------------------------------------------------------------------------
--
-- Title       : S_Distributor
-- Design      : Labs
-- Author      : Dima
-- Company     : Dima
--
-------------------------------------------------------------------------------
--
-- File        : S_Distributor.vhd
-- Generated   : Wed Mar  6 17:41:30 2019
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {S_Distributor} architecture {BEH}}
	
library IEEE;
use IEEE.STD_LOGIC_1164.all;

package arr is
	type iarr is array (natural range <>) of Integer;
	type rarr is array (natural range <>) of Real;
end package;	
	
	
library IEEE;
use IEEE.STD_LOGIC_1164.all, arr.all;

entity S_Distributor is	
	generic(
		N: natural:= 128
	);
	port(
		CLK : in BIT;
		RES: in BIT;
		 X : in INTEGER;
		 Y: out iarr (1 to N)
	     );
end S_Distributor;

--}} End of automatically maintained section

architecture BEH of S_Distributor is
	constant baseM : iarr (0 to N-1) := (others => 0);
	signal M: iarr (0 to N-1) := baseM;
	signal ctr : natural := 0;
	constant mx : integer := 2**12 / N;
begin
	L_main: process (CLK, RES)
		variable i:integer;
	begin
		if RES = '1' then M <= baseM;
		elsif CLK = '1' and CLK'event then
			i := X / mx;
			M(i) <= M(i) + 1;
		end if;
	end process;
	
	Y <= M;
end BEH; 

------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all, arr.all, IEEE.NUMERIC_BIT.all, CNetwork.all;

--encounts X values (type - unsigned integer value) and gets statistical info
entity ValCounter is
	generic(
		points: positive := 128;
		XBitCapacity: positive := 12
	);
	port(
		CLK : in bit;
		RES: in bit;
		WR : in bit;								--encount sequential xi
		RD: in bit;									--evaluates j-st value of P
		X : in signed(XBitCapacity-1 downto 0);	-- sequential xi
		j: in integer;
		P: out real
	);
end ValCounter;


architecture CTR of ValCounter is
	constant minvalue : integer := 0;
	constant maxvalue: integer := 2**XBitCapacity;
	constant valuescount :integer := maxvalue - minvalue;
	constant valuesInPocket : integer := valuescount / points; 
	
	constant baseM : iarr (0 to maxvalue-1) := (others => 0);
	signal M: iarr (0 to maxvalue-1) := baseM;
	
	signal ctr : natural := 0;
	
begin
	Label1: process (CLK)
		variable i:integer;
	begin
		if RES = '1' then 
			M <= baseM;
			ctr <= 0;
		elsif CLK = '1' and CLK'event then
			if WR = '1' then
				i := Bit_To_Int(bit_vector(X)) / maxvalue;
				M(i) <= M(i) + 1; 
				ctr <= ctr + 1;
			elsif RD = '1' then
				if j>= 0 and j< maxvalue then
					P <= real(M(j)*points) / real(ctr * valuesInPocket);
				else
					P <= 0.0;
				end if;
			end if;
		end if;			
	end process;
end CTR;

-----------------------------------------



		

	
