os.loadAPI ('usr/share/move')
os.loadAPI ('usr/share/dig')

function plantTree ()
	-- assume the item in the first place is a sappling, and the item in the second place
	-- is bonemeal.
	turtle.select (1)
	turtle.place ()
	turtle.select (2)
	turtle.place ()
end

function cutTree ()
	-- assume the tree is in front of the turtle, move back down to the original possition
	-- ofter the tree has been cut
	pos = move.position ()

	success = dig.block ()
	if ( not success ) then return false end
	move.forward ()
	digSuccess = dig.pillar ()

	newpos = move.position ()
	height = newpos.z - pos.z
	moveSuccess = move.down (height)
	-- should check this as well actually. oh well I should make a logger.
	move.back ()

	return digSuccess and moveSuccess
end

function cycle ()
	turtle.suck ()
	plantTree ()
	success = cutTree ()
	return success
end
