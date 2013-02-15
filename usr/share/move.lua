
positionPath = 'storage/position'
directionPath = 'storage/direction'
-- don't use the minecraft vectors, they are messed up, who takes 
-- y te be the hight?
-- - z is the hight,
-- - x is the minecraft x,
-- - y is the minecraft y.
local _z = vector.new (0, 0, 1)
local _north = vector.new (1, 0, 0)
local _east = vector.new (0, 1, 0)
local _south = vector.new (-1, 0, 0)
local _west = vector.new (0, -1, 0)

local _position = vector.new (0, 0, 0)
local _direction = _north

function _restore () 
	if ( fs.exists (positionPath) ) then
		local fp = io.open (positionPath, 'r')
		local data = fp:read ('*a')
		fp:close()
		local t = textutils.unserialize (data)
		_position = vector.new (t[1], t[2], t[3])
	else
		_position = vector.new (0, 0, 0)
	end

	if (fs.exists (directionPath) ) then
		local fp = io.open (directionPath, 'r')
		local data = fp:read('*a')
		fp:close()
		if ( data == 'north' ) then _direction = _north
		elseif ( data == 'east' ) then _direction = _east
		elseif ( data == 'south' ) then _direction = _south
		elseif ( data == 'west' ) then _direction = _west
		else _direction = _north
		end
	else
		_direction = _north
	end
end

function _store ()
	-- writing _position to file
	local fp = io.open (positionPath, 'w')
	local data = { _position.x, _position.y, _position.z }
	fp:write (textutils.serialize (data))
	fp:flush()
	fp:close()

	-- writing _direction to file.
	local fp = io.open (directionPath, 'w')
	if ( _direction == _north ) then fp:write ('north')
	elseif ( _direction == _east ) then fp:write ('east')
	elseif ( _direction == _south ) then fp:write ('south')
	elseif ( _direction == _west ) then fp:write ('west')
	end
	fp:flush()
	fp:close()
end

function _repeat (n, action, update)
	if ( not n ) then n = 1 end
	count = 0
	repeat
		-- if the action does not work the firt time it
		-- will probably not work after that either.
		success = action ()
		if (success) then update () else return false end
		count = count + 1
	until count == n
	return true
end

function forward (n)
	local action = function () return turtle.forward () end
	local update = function () _position = _position:add (_direction) end
	return _repeat (n, action, update)
end

function back (n)
	local action = function () return turtle.back () end
	local update = function () _position = _position:sub (_direction) end
	return _repeat (n, action, update)
end

function up (n)
	local action = function () return turtle.up () end
	local update = function () _position = _position:add (_z) end
	return _repeat (n, action, update)
end

function down (n)
	local action = function () return turtle.down () end
	local update = function () _position = _position:sub (_z) end
	return _repeat (n, action, update)
end

function left (n)
	local success = turnLeft ()
	if ( not success ) then return false end
	local success = forward (n)
	if ( not success ) then return false end
	local success = turnRight ()
	return success
end

function right (n)
	local success = turnRight ()
	if ( not success ) then return false end
	local success = forward (n)
	if ( not success ) then return false end
	local success = turnLeft ()
	return success
end

function turnLeft ()
	local success = turtle.turnLeft ()
	if (success) then
		if ( _direction == _north ) then _direction = _east
		elseif (_direction == _east ) then _direction = _south
		elseif (_direction == _south ) then _direction = _west
		elseif (_direction == _west ) then _direction = _north
		end
	end
	return success
end

function turnRight ()
	local success = turtle.turnRight ()
	if (success) then
		if ( _direction == _north ) then _direction = _west
		elseif ( _direction == _east ) then _direction = _north
		elseif ( _direction == _south ) then _direction = _east
		elseif ( _direction == _west ) then _direction = _south
		end
	end
	return success
end

function turnAround ()
	update = function () return true end
	_repeat (2, turnRight, update)
end

function position () return _position end
function direction () return _direction end
