
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY xor_gate IS
PORT( a,b : IN std_ulogic;
	c : OUT std_ulogic);
END;

ARCHITECTURE mygate OF xor_gate IS

BEGIN
c <= a XOR b AFTER 10 ns;
END;