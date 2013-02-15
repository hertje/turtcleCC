
function parse (argTable)
	local options = {}
	local args = {}
	for index, arg in ipairs(argTable) do
		if ( arg:sub (1,2) == '--' ) then 
			key, val = parseOption (arg)
			options[key] = val
		elseif ( arg:sub (1,1) == '-' and arg:sub(3,3) == '=' ) then
			key,val  = arg:sub(2,2), arg:sub(4)
			options[key] = val
		elseif ( arg:sub (1,1) == '-' ) then
			for i=2, string.len (arg) do
				options[arg:sub(i,i)] = true
			end
		else table.insert (args, arg)
		end
	end
	return options, args
end

function parseOption (option) 
	local index = string.find (option, '=')
	if ( index ) then
		local key = option:sub (3,index-1)
		local val = option:sub (index+1)
		return key, val
	else
		return option:sub(3), true
	end
end
