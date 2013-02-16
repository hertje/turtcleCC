os.loadAPI ('usr/share/forester')
os.loadAPI ('usr/share/move')

success = true
corner = false
while success do
	turtle.suck ()
	success = forester.cycle ()

	if ( not move.forward (4) ) then break end

	if ( corner ) then
		move.turnRight ()
		if ( not move.forward () ) then break end
		move.turnLeft ()
		if ( not move.forward () ) then break end
		move.turnLeft ()
	end

	if ( corner ) then corner = false else corner = true end

	os.sleep (15)
end

print ('done')
