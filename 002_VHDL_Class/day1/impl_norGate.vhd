
ENTITY norGate IS
PORT(
	a,b	:	IN BIT;
	c	:	OUT BIT);
END;

ARCHITECTURE mynorGate OF norGate IS
BEGIN
c <=	'0' WHEN a = '0' AND b = '0' ELSE
	'1' WHEN a = '0' AND b = '1' ELSE
	'1' WHEN a = '1' AND b = '0' ELSE
	'0' WHEN a = '1' AND b = '1' ;
END;	
	