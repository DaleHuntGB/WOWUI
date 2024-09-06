local _, UHUI = ...
local _G = _G
local strmatch = strmatch

local TooltipDataProcessor_AddTooltipPostCall = TooltipDataProcessor.AddTooltipPostCall
local Enum_TooltipDataType_Item = Enum.TooltipDataType.Item

local gameTooltips = {
	"GameTooltip",
	"ItemRefTooltip",
	"ShoppingTooltip1",
	"ShoppingTooltip2",
	"ItemRefShoppingTooltip1",
	"ItemRefShoppingTooltip2",
}

local function RemoveCrafterInformation(tooltip, data)
	local tooltipName = tooltip:GetName()
	if UHUI:TableSearch(tooltipName, gameTooltips) then
		for dataIndex = #data.lines, 10, -1 do
			local line = data.lines[dataIndex] and data.lines[dataIndex].leftText
			if line and strmatch(line, "<(.+)>|r$") then
				for tooltipLineIndex = dataIndex, dataIndex + 2 do
					local realLine = _G[tooltipName .. "TextLeft" .. tooltipLineIndex]
					if realLine and realLine:GetText() == line then
						realLine:SetText("")
					end
				end
			end
		end
	end
end

function UHUI:HideCrafter()
	TooltipDataProcessor_AddTooltipPostCall(Enum_TooltipDataType_Item, RemoveCrafterInformation)
end
