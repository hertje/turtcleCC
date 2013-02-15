os.loadAPI('usr/share/move')
os.loadAPI('usr/utils/parseArgs')

local argv = { ... }
local options, arguments = parseArgs.parse (argv)

if ( #arguments == 0 ) then return 1 end

if options['n'] then
	count = options['n']
	print (type (count))
	print (type (type (count)))
	if type(count) == "boolean" then
		print ("looking for number")
		count = arguments[2]
		print (type (count))
		print (count)
	end
	-- all values in options are strings, but adding 0 to it will make it an int.
	count = count + 0
else
	count = 1
end

local movement = arguments[1]

move._restore ()
print (movement)
print ('from: ', move.position())

if (movement == 'forward') then move.forward (count)
elseif ( movement == 'back' ) then move.back (count)
elseif ( movement == 'up' ) then move.up (count)
elseif ( movement == 'down' ) then move.down (count)
elseif ( movement == 'turnaround' ) then move.turnAround (count)
elseif ( movement == 'turnAround' ) then move.turnAround (count)

elseif ( movement == 'left' ) then
	if options['t'] or options['turn'] then move.turnLeft ()
	else move.left (count)
	end
elseif ( movement == 'right' ) then
	if options['t'] or options['turn'] then move.turnRight ()
	else move.right (count)
	end
end

move._store ()
print ('to:', move.position())


