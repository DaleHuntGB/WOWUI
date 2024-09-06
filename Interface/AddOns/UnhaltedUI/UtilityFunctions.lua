local _, UHUI = ...

function UHUI:TableSearch(val, tbl)
	if not val or not tbl or type(tbl) ~= "table" then return false end
	for _, v in pairs(tbl) do if v == val then return true end end
	return false
end