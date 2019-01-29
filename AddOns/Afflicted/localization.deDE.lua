if( GetLocale() ~= "deDE" ) then
	return
end

AfflictedLocals = setmetatable({
}, {__index = AfflictedLocals})