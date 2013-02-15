os.loadAPI ('usr/share/move')

function block (direction)
	if ( not direction ) then direction = 'forward' end

	if ( direction == "down" and turtle.detectDown () ) then return turtle.digDown ()
	elseif ( direction == "up" and turtle.detectUp () ) then return turtle.digUp ()
	elseif ( direction == "forward" and turtle.detect () ) then return turtle.dig ()
	end
end

function trench (length)
	if ( length == 0 ) then return true end

	local count = 0
	while count < length - 1 do
		block ("down")
		success = move.forward ()
		if ( not success ) then break end
		count = count + 1
	end
	block ("down")
	return true
end

function row (length, height)
	if ( not height ) then height = 1 end

	-- if the height is 1 just cut a standard row. If the height is 2, cut the row below
	-- the turtle as well. If the height is 3, cut the row above the turtle as well.

	if ( length == 0 ) then return true end

	local count = 0
	while count < length - 1 do
		block ()
		if ( height > 1 ) then block ("down") end
		if ( height > 2 ) then block ("up") end

		-- deal with gravel and moving blocks. If the movement failed, there is something
		-- in the way, so dig it again and try to go forward.
		while ( not move.forward () ) do block () end

		count = count + 1
	end

	if ( height > 1 ) then block ("down") end
	if ( height > 2 ) then block ("up") end
	return true
end

function slab (width, depth, height)
	if ( not height ) then height = 1 end

	-- height has the same meaning as in <digRow>.
	if ( depth == 0 or width == 0 ) then return true end

	local count = 0
	local odd = false
	while count < width - 1 do
		row (depth, height)

		-- get in position for the next row turn left and right in an alternating way.
		-- Deal with gravel and such. in the <while (not move.forward ())> thing.
		if odd then move.turnRight () else move.turnLeft () end
		block ()
		while ( not move.forward () ) do block () end
		if odd then move.turnRight () else move.turnLeft () end

		count = count + 1
		if odd then odd = false else odd = true end
	end

	row (depth, height)
	return true
end

function cube (width, depth, height)
	if ( width == 0 or depth == 0 or height == 0 ) then return true end

	local  count = 0
	while count  < height - 3  do
		slab (width, depth, 3)

		-- don't move down if we have less then 3 slabs to go (we'll move down to far).
		count = count + 3
		if ( count > height - 3 ) then break end

		-- get back into position. We are always left facing a wall, with or left hand
		-- side to the wall. Since we dig out a slab to our left side, just turn around
		move.turnAround ()
		-- then move down three blocks, (dig out the two last blocks.
		move.down ()
		block ('down')
		move.down ()
		block ('down')
		move.down ()
		
	end

	-- move down the appropriate amount. This will always be two blocks down. We either
	-- need to shave off two slabs (the slab below the turtle and the slab at the level
	-- of the turtle). Or one slab (the slab at the level of the turtle).
	move.turnAround ()
	move.down ()
	block ('down')
	move.down ()

	slab (width, depth, height - count)
	return true
end

function pillar (width)
	if ( not width ) then width = 1 end

	while turtle.detectUp () do
		success = block ('up')

		-- there was a block and we could not break it, don't know how to proceed
		if ( not success ) then
			print ('pillar: digging up failed')
			return false
		end

		-- we want to save trouble and cut the pillar in front as well (this will be
		-- royally screwed if we encounter gravel, at least the actual pillar will be
		-- gone)
		if ( width > 1 ) then block () end

		-- When we can not move up, assume gravel (or something similar) dropped on us, so
		-- we have to move that many blocks up to reach the first possible block that is
		-- not air.
		blockCount = 0
		while ( not move.up () ) do
			block ('up')
			blockCount =  blockCount + 1
		end
		-- we already moved up one block
		if ( blockCount > 1 ) then
			success = move.up (blockCount - 1)
			-- if we still where not able to go up, we don't know what went wrong.
			if ( not success ) then
				print ('Giving up!')
				return false
			end
		end
	end

	return true
end
