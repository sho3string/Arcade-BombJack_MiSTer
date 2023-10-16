LIBRARY ieee;
USE ieee.std_logic_1164.all;


ENTITY ram_1e IS 
	generic (
		 addr_width_g : integer := 11;
		 data_width_g : integer := 8
	); 
	PORT
	(
		address_a	: IN STD_LOGIC_VECTOR (addr_width_g-1 DOWNTO 0);
		address_b	: IN STD_LOGIC_VECTOR (addr_width_g-1 DOWNTO 0);
		clock_a		: IN STD_LOGIC;
		clock_b		: IN STD_LOGIC;
		data_a		: IN STD_LOGIC_VECTOR (data_width_g-1 DOWNTO 0);
		data_b		: IN STD_LOGIC_VECTOR (data_width_g-1 DOWNTO 0) := (others => '0');
		enable_a    : IN STD_LOGIC  := '1';
		enable_b    : IN STD_LOGIC  := '1';
		wren_a		: IN STD_LOGIC  := '0';
		wren_b		: IN STD_LOGIC  := '0';
		q_a			: OUT STD_LOGIC_VECTOR (data_width_g-1 DOWNTO 0);
		q_b			: OUT STD_LOGIC_VECTOR (data_width_g-1 DOWNTO 0)
	);
END ram_1e;


ARCHITECTURE SYN OF ram_1e IS
BEGIN
    dual_port_ram : entity work.dualport_2clk_ram_clken
      generic map (
         ADDR_WIDTH        => addr_width_g,
         DATA_WIDTH        => data_width_g
      )
      port map (
         -- Port A
         clock_a           => clock_a,
         do_latch_addr_a   => enable_a,
         address_a         => address_a,
         data_a            => data_a,
         wren_a            => wren_a,
         q_a               => q_a,

         -- Port B
         clock_b           => clock_b,
         clock_b_en        => enable_b,
         address_b         => address_b,
         data_b            => data_b,
         wren_b            => wren_b,
         q_b               => q_b
      );
END SYN;

