-------------------------------------------------------------------------------
--
-- Title       : LFSR
-- Design      : Labs
-- Author      : Dima
-- Company     : Dima
--
-------------------------------------------------------------------------------
--
-- File        : LFSR.vhd
-- Generated   : Wed Mar  6 16:23:21 2019
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
--{entity {LFSR} architecture {Reverse}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity LFSR is	
	generic (
		seed:bit_vector(1 to 24) := (others => '0')
	);
	port(
		 CLK : in bit;
		 RES : in bit;
		 Y : out bit;
		 G: out bit_vector(11 downto 0)
	     );
end LFSR;

--}} End of automatically maintained section

architecture Reverse of LFSR is
	signal Z: bit_vector (1 to 24) := seed;
	signal z0:bit := '0';
begin 	
	
	z0 <= not (Z(11)xor Z(24));
	
	L_Shift: process (CLK, RES)
	begin
		if RES = '1' then Z <= seed;
		elsif CLK = '1' and CLK'event then 
			Z <= z0 & Z(1 to 23);
		end if;
	end process;
	
	Y <= Z(24);
	
	L_setG: process(Z)
		variable b:natural:=2;
	begin
		b := 2;
		for i in 0 to 11 loop
			G(i) <= Z (b);
			b := b + 2;
		end loop;
	end process;
	
		
	
end Reverse;
