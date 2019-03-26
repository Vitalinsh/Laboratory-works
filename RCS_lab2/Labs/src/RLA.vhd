-------------------------------------------------------------------------------
--
-- Title       : RLA
-- Design      : Labs
-- Author      : Dima
-- Company     : Dima
--
-------------------------------------------------------------------------------
--
-- File        : RLA.vhd
-- Generated   : Wed Mar  6 17:15:48 2019
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
--{entity {RLA} architecture {Normal}}

library IEEE;
use IEEE.STD_LOGIC_1164.all, IEEE.NUMERIC_BIT.all;

entity RLA is
	generic(
	N:natural := 12;
	M:natural := 16
	);
	port(
		X: in Signed(N-1 downto 0);
		CLK:in bit;
		Y: out Signed(N-1 downto 0)
	);
end RLA;

--}} End of automatically maintained section

architecture Normal of RLA is
	signal Z : Signed (N - 1 downto 0);
	type mem is array (1 to M) of Signed(N-1 downto 0); 
	signal Xlast : mem := (others => (others => '0'));
begin
	L_Z: process (CLK)
	variable temp: Signed(N - 1 downto 0) := (others => '0');
	begin
		if CLK = '1' and CLK'event then
			--temp := (others => '0');
			--for i in 1 to M loop
--				temp := temp + Xlast(i);
--			end loop;
--			Z <=  Z + X - temp/M;
			Z <= Z + (X - Xlast(M))/M;
			for i in M downto 2 loop
				Xlast(i) <= Xlast(i-1);
			end loop;
			Xlast(1) <= X;
			--shifts
			
			
		end if;
	end process;
	
	Y <= Z(N - 1 downto 0);
end Normal;
