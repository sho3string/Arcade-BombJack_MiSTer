--	(c) 2012 d18c7db(a)hotmail
--
--	This program is free software; you can redistribute it and/or modify it under
--	the terms of the GNU General Public License version 3 or, at your option,
--	any later version as published by the Free Software Foundation.
--
--	This program is distributed in the hope that it will be useful,
--	but WITHOUT ANY WARRANTY; without even the implied warranty of
--	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
--
-- For full details, see the GNU General Public License at www.gnu.org/licenses

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_unsigned.all;
	use ieee.numeric_std.all;

entity PROG_ROMS is
	port (
	    
	    --clk_48M     : in  std_logic;
	    dn_clk      : in  std_logic; -- M2M rom loading
		dn_addr     : in  std_logic_vector(16 downto 0);
		dn_data     : in  std_logic_vector(7 downto 0);
		dn_wr       : in  std_logic;

		I_CLK       : in  std_logic;
		I_ROM_SEL   : in  std_logic_vector( 4 downto 0);
		I_ADDR      : in  std_logic_vector(12 downto 0);
		--
		O_DATA      : out std_logic_vector( 7 downto 0)
	);
end;

architecture RTL of PROG_ROMS is
	signal ROMD_1J : std_logic_vector( 7 downto 0) := (others => '0');
	signal ROMD_1L : std_logic_vector( 7 downto 0) := (others => '0');
	signal ROMD_1M : std_logic_vector( 7 downto 0) := (others => '0');
	signal ROMD_1N : std_logic_vector( 7 downto 0) := (others => '0');
	signal ROMD_1R : std_logic_vector( 7 downto 0) := (others => '0');
	
	signal 
		ROM_1J_cs,
		ROM_1L_cs,
		ROM_1M_cs,
		ROM_1N_cs,
		ROM_1R_cs : std_logic;

begin

	ROM_1J_cs <= '1' when dn_addr(16 downto 13) = X"8" else '0';
	ROM_1L_cs <= '1' when dn_addr(16 downto 13) = X"9" else '0';
	ROM_1M_cs <= '1' when dn_addr(16 downto 13) = X"A" else '0';
	ROM_1N_cs <= '1' when dn_addr(16 downto 13) = X"B" else '0';
	ROM_1R_cs <= '1' when dn_addr(16 downto 13) = X"C" else '0';

	ROM_1J : entity work.dualport_2clk_ram  
	generic map 
    (
        FALLING_A    => true,
        ADDR_WIDTH   => 13,
        DATA_WIDTH   => 8
    )
	port map
	(
		--clock_a   => clk_48M,
		clock_a   => dn_clk,
		wren_a    => dn_wr and ROM_1J_cs,
		address_a => dn_addr(12 downto 0),
		data_a    => dn_data,

		clock_b   => I_CLK,
		address_b => I_ADDR,
		q_b       => ROMD_1J
	);

	ROM_1L : entity work.dualport_2clk_ram  
	generic map 
    (
        FALLING_A    => true,
        ADDR_WIDTH   => 13,
        DATA_WIDTH   => 8
    )
	port map
	(
		--clock_a   => clk_48M,
		clock_a   => dn_clk,
		wren_a    => dn_wr and ROM_1L_cs,
		address_a => dn_addr(12 downto 0),
		data_a    => dn_data,

		clock_b   => I_CLK,
		address_b => I_ADDR,
		q_b       => ROMD_1L
	);

	ROM_1M : entity work.dualport_2clk_ram  
	generic map 
    (
        FALLING_A    => true,
        ADDR_WIDTH   => 13,
        DATA_WIDTH   => 8
    )
	port map
	(
		--clock_a   => clk_48M,
		clock_a   => dn_clk,
		wren_a    => dn_wr and ROM_1M_cs,
		address_a => dn_addr(12 downto 0),
		data_a    => dn_data,

		clock_b   => I_CLK,
		address_b => I_ADDR,
		q_b       => ROMD_1M
	);

	ROM_1N : entity work.dualport_2clk_ram  
	generic map 
    (
        FALLING_A    => true,
        ADDR_WIDTH   => 13,
        DATA_WIDTH   => 8
    )
	port map
	(
		--clock_a   => clk_48M,
		clock_a   => dn_clk,
		wren_a    => dn_wr and ROM_1N_cs,
		address_a => dn_addr(12 downto 0),
		data_a    => dn_data,

		clock_b   => I_CLK,
		address_b => I_ADDR,
		q_b       => ROMD_1N
	);
	
	ROM_1R : entity work.dualport_2clk_ram  
	generic map 
    (
        FALLING_A    => true,
        ADDR_WIDTH   => 13,
        DATA_WIDTH   => 8
    )
	port map
	(
		--clock_a   => clk_48M,
		clock_a   => dn_clk,
		wren_a    => dn_wr and ROM_1R_cs,
		address_a => dn_addr(12 downto 0),
		data_a    => dn_data,

		clock_b   => I_CLK,
		address_b => I_ADDR,
		q_b       => ROMD_1R
	);

	O_DATA <=
		ROMD_1J when I_ROM_SEL = "11110" else
		ROMD_1L when I_ROM_SEL = "11101" else
		ROMD_1M when I_ROM_SEL = "11011" else
		ROMD_1N when I_ROM_SEL = "10111" else
		ROMD_1R when I_ROM_SEL = "01111" else
		(others => '0');
end RTL;
