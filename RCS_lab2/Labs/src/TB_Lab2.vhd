-------------------------------------------------------------------------------
--
-- Title       : TB_Lab2
-- Design      : Labs
-- Author      : Dima
-- Company     : Dima
--
-------------------------------------------------------------------------------
--
-- File        : TB_Lab2.vhd
-- Generated   : Wed Mar  6 18:40:26 2019
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
--{entity {TB_Lab2} architecture {TB_Lab2}}

library IEEE;
use IEEE.STD_LOGIC_1164.all, arr.all, IEEE.NUMERIC_BIT.all, CNetwork.all, calculator.all;

entity TB_Lab2 is
end TB_Lab2;

--}} End of automatically maintained section

architecture TB_Lab2 of TB_Lab2 is 

   	component LFSR is	
	generic (
		seed:bit_vector(1 to 24) := (others => '0')
	);
	port(
		 CLK : in bit;
		 RES : in bit;
		 Y : out bit;
		 G: out bit_vector(11 downto 0)
	     );
	end component; 
	
	component RLA is
	generic(
	N:natural := 12;
	M:natural := 2
	);
	port(
		X: in Signed(N-1 downto 0);
		CLK:in bit;
		Y: out Signed(N-1 downto 0)
	);
	end component;
	
	component S_Distributor is	
	generic(
		N: natural:= 128
	);
	port(
		CLK : in BIT;
		RES: in BIT;
		 X : in INTEGER;
		 Y: out iarr (1 to N)
	     );
	end component;
	
	component ValCounter is
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
	end component;
	
	constant N:integer := 1000;
	constant K:integer := 128; 
	constant K2: integer:= 500;
	constant tau1: integer := 50;
	constant tau2: integer := 500;
												
	signal clk, xclk, rand:bit;					-- clocks
	signal x: bit_vector(11 downto 0);			-- to taking result from LFSR
	signal x_uns, y_norm : Signed(11 downto 0);	-- to casting types 
	signal ctr, xi, yi:integer := 0;
	signal fx, fy, fRand : iarr (1 to N);		-- arrays for function
	signal fM, fMy  : iarr (1 to K);			-- arrays for encounting values distribution
	signal fP, fPy : rarr (1 to K);				-- arrays for distribution
	signal fR, fRy, fRRand : rarr (1 to K2);		-- arrays for correlation
	
	signal calc, gener: bit;					-- state of model (generation signals or calculations)
	signal j:integer := 1;	  					-- index for displaying
	
	signal Pj, Rxx: real;						-- 
	
	signal R, Ry, P, Py, RRand: real := 0.0;	-- use to correct displaying correlation and distribution
	signal fR1, fRy1 : rarr (1 to tau1);
	signal fR2, fRy2 : rarr (1 to tau2);
	
begin
    clk <= not clk after 1 ns;
	xclk <= clk when ctr < N else '0';
	calc <= '1' when ctr > N else '0';
	gener <='1' when ctr < N else '0';
	
	L_CLKS: process (clk)
	begin
		if clk = '1' and clk'event then
			ctr <= ctr+1;
			if ctr <= N and ctr>0 then
				fx(ctr) <= xi;
				fy(ctr) <= yi;
				if rand = '1' then fRand(ctr) <= 1;
				else fRand(ctr) <= -1; end if;
			end if;
			if ctr = N then
				fP <= distribution(fM, N, K, 2**12/K);
				fPy <= distribution(fMy, N, K, 2**12/K);
				fR <= autocorrelation(fx, K2);
				fRy <= autocorrelation(fy, K2);
				fRRand <= autocorrelation(fRand, K2);
				--fR2 <= autocorrelation(fx, tau2);
				
				null;
			end if;
			if ctr > N then
				if j<=K then	
					P <= fP(j);
					Py <= fPy(j);
				end if;
				if j<=K2 then
					R <= fR(j);
					Ry <= fRy(j);
					RRand <= fRRand(j);
				end if;
				--if j<K then j <= j + 1; end if;
				j <= j + 1;
			end if;
		end if;
	end process;
	
	L_LFSR: entity LFSR port map 
		(CLK => xclk, RES => '0', Y => rand, G => x );
		
	x_uns <= Signed(x);
	
	L_RLA: entity RLA port map
		(CLK => xclk, X => x_uns, Y => y_norm);	
		
	xi <= (BIT_TO_INT (x))*1;
	yi <= BIT_TO_INT (bit_vector(y_norm));
	
	L_DISTX: entity S_Distributor port map
		(CLK => xclk, RES => '0', X => xi, Y => fM);
		
	L_DISTY: entity S_Distributor port map
		(CLK => xclk, RES => '0', X => yi, Y => fMy); 
		
	L_DISX: entity ValCounter port map
		(CLK => clk, RES => '0', WR => gener, RD => calc, X => X_uns, j => j, P => Pj);
		
		
end TB_Lab2;
