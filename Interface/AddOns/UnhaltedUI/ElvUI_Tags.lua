local E, L, V, P, G = unpack(ElvUI)
local CT = E:NewModule('CustomTags', 'AceHook-3.0', 'AceEvent-3.0')
ElvUF.Tags.Events['BetterHP'] = 'UNIT_HEALTH UNIT_MAXHEALTH UNIT_ABSORB_AMOUNT_CHANGED UNIT_CONNECTION PLAYER_FLAGS_CHANGED'
ElvUF.Tags.Methods['BetterHP'] = function(unit)
    local uHealth = UnitHealth(unit)
    local uMaxHealth = UnitHealthMax(unit)
    local uTotalAbsorb = UnitGetTotalAbsorbs(unit) or 0
    local uEffectiveHealth = uHealth + uTotalAbsorb
    local uEffectiveHealthPercent = (uEffectiveHealth / uMaxHealth) * 100
    if UnitIsDeadOrGhost(unit) then return "Dead" end
    if not UnitIsConnected(unit) then return "Offline" end
    return E:ShortValue(uEffectiveHealth) .. " • " .. E:Round(uEffectiveHealthPercent, 1) .. "%"
end

E:RegisterModule(CT:GetName())