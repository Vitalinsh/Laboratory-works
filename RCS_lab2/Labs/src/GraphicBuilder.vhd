-------------------------------------------------------------------------------
--
-- Title       : GraphicBuilder
-- Design      : Labs
-- Author      : Dima
-- Company     : Dima
--
-------------------------------------------------------------------------------
--
-- File        : GraphicBuilder.vhd
-- Generated   : Wed Mar  6 17:01:33 2019
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
--{entity {GraphicBuilder} architecture {BitVecToInt}}

library IEEE;
use IEEE.STD_LOGIC_1164.all, CNetwork.all;

entity GraphicBuilder is
	generic(
		N: natural := 12;
		signEnable : boolean :=	true
	);
	port(
		X: in bit_vector(N-1 downto 0);
		Y: out Integer
	);
end GraphicBuilder;

--}} End of automatically maintained section

architecture BitVecToInt of GraphicBuilder is
begin
	 Y <= BIT_TO_INT(X);
	 -- enter your statements here --

end BitVecToInt;
