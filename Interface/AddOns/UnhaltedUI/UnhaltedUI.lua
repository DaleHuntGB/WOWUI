local _, UHUI = ...
local LSM = LibStub("LibSharedMedia-3.0")
BINDING_HEADER_UHUI = C_AddOns.GetAddOnMetadata("UnhaltedUI", "Title")
BINDING_NAME_HIDEBARS = "Hide Action Bars (OOC)"
BINDING_NAME_QUICKLEAVE = "Quick Leave Party"
SetCVar("advancedCombatLogging", 1)
SetCVar("autoLootDefault", 1)
local BuffsToCancel = {
    [388658]    = true,
    [394015]    = true,
    [391312]    = true,
    [394007]    = true,
    [394008]    = true,
    [394003]    = true,
    [394016]    = true,
    [394001]    = true,
    [394005]    = true,
    [394006]    = true,
    [394011]    = true,
    [391775]    = true,
    [61734]     = true,
    [61716]     = true,
    [318452]    = true,
    [290224]    = true,
    [44212]     = true,
    [279509]    = true,
    [61781]     = true,
    [8222]      = true,
}

UIErrorsFrame:ClearAllPoints()
UIErrorsFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 225)
ActionStatus.Text:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
ActionStatus.Text:SetShadowColor(0, 0, 0, 0)
C_Timer.After(0.5, function()
    LibDBIcon10_BugSack:ClearAllPoints()
    LibDBIcon10_BugSack:SetPoint("BOTTOMLEFT", Minimap, "BOTTOMLEFT", 1, 32)
    LibDBIcon10_BugSack:SetScale(0.8)
end)

function UHUI:FasterAutoLoot()
    local FasterAutoLoot = CreateFrame("Frame")
    FasterAutoLoot:RegisterEvent("LOOT_READY")
    FasterAutoLoot:SetScript("OnEvent", function(self, event, ...)
        if event == "LOOT_READY" then
            LootFrame:Hide()
            for i = GetNumLootItems(), 1, -1 do
                LootSlot(i)
                LootSlot(i)
            end
            CloseLoot()
        end
    end)
end

function UHUI:RegisterSlashCommands()
    SLASH_COMBATLOG1 = "/cl"
    SlashCmdList["COMBATLOG"] = function()
        if not LoggingCombat() then
            LoggingCombat(true)
            print("|cFF8080FFUnhalted|rUI: Combat Log |cFF40FF40Started|r.")
        else
            LoggingCombat(false)
            print("|cFF8080FFUnhalted|rUI: Combat Log |cFFFF4040Stopped|r.")
        end
    end
    SLASH_SHOWBARS1 = "/bars"
    SlashCmdList["SHOWBARS"] = function() local b,E={1,2,3,4}, unpack(ElvUI) for _,n in pairs(b) do local s=E.db.actionbar["bar"..n].visibility;E.db.actionbar["bar"..n].visibility=(s=="hide" and "show" or "hide") E.ActionBars:PositionAndSizeBar("bar"..n) end end
end

function UHUI:SkipCinematics()
    local SkipCinematicsFrame = CreateFrame("Frame")
    SkipCinematicsFrame:RegisterEvent("CINEMATIC_START")
    SkipCinematicsFrame:SetScript("OnEvent", function(self, event, ...)
        if event == "CINEMATIC_START" then
            CinematicFrame_CancelCinematic()
        end
    end)
    MovieFrame_PlayMovie = function(...)
        CinematicFinished(0)
        CinematicFinished(1)
        CinematicFinished(2)
        CinematicFinished(3)
    end
end

function UHUI:HideTalkingHead()
    hooksecurefunc(TalkingHeadFrame, "PlayCurrent", function(self) self:Hide() end)
end

function UHUI:RemoveTransforms()
    local RemoveTransforms = CreateFrame("Frame")
    RemoveTransforms:RegisterEvent("UNIT_AURA")
    RemoveTransforms:RegisterEvent("PLAYER_REGEN_ENABLED")
    RemoveTransforms:RegisterEvent("PLAYER_ENTERING_WORLD")
    RemoveTransforms:SetScript("OnEvent", function(_, event, ...)
        if (event == "UNIT_AURA" or event == "PLAYER_REGEN_ENABLED" or event == "PLAYER_ENTERING_WORLD") and not UnitAffectingCombat("player") then
            for i = 1, 40 do
                local BuffData = C_UnitAuras.GetBuffDataByIndex("player", i)
                if BuffData then
                    local SpellID = BuffData.spellId
                    if SpellID and BuffsToCancel[SpellID] then
                        CancelUnitBuff("player", i, "HELPFUL")
                    end
                end
            end
        end
    end)
end

function UHUI:RegisterMedia()
    LSM:Register("sound","|cFF8080FFBlade|r", [[Interface\Addons\UnhaltedUI\Sounds\Blade.ogg]])
    LSM:Register("sound","|cFF8080FFBuffed|r", [[Interface\Addons\UnhaltedUI\Sounds\Buffed.ogg]])
    LSM:Register("sound","|cFF8080FFBullet|r", [[Interface\Addons\UnhaltedUI\Sounds\Bullet.ogg]])
    LSM:Register("sound","|cFF8080FFInfo|r", [[Interface\Addons\UnhaltedUI\Sounds\Info.ogg]])
    LSM:Register("sound","|cFF8080FFMail|r", [[Interface\Addons\UnhaltedUI\Sounds\Mail.ogg]])
    LSM:Register("sound","|cFF8080FFPositive|r", [[Interface\Addons\UnhaltedUI\Sounds\Positive.ogg]])
    LSM:Register("sound","|cFF8080FFThunder|r", [[Interface\Addons\UnhaltedUI\Sounds\Thunder.ogg]])
    LSM:Register("sound","|cFF8080FFOn You|r", [[Interface\Addons\UnhaltedUI\Sounds\OnYou.ogg]])
    LSM:Register("sound", "|cFF8080FF1|r", [[Interface\Addons\UnhaltedUI\Sounds\1.ogg]])
    LSM:Register("sound", "|cFF8080FF2|r", [[Interface\Addons\UnhaltedUI\Sounds\2.ogg]])
    LSM:Register("sound", "|cFF8080FF3|r", [[Interface\Addons\UnhaltedUI\Sounds\3.ogg]])
    LSM:Register("sound", "|cFF8080FF4|r", [[Interface\Addons\UnhaltedUI\Sounds\4.ogg]])
    LSM:Register("sound", "|cFF8080FF5|r", [[Interface\Addons\UnhaltedUI\Sounds\5.ogg]])
    LSM:Register("sound", "|cFF8080FF6|r", [[Interface\Addons\UnhaltedUI\Sounds\6.ogg]])
    LSM:Register("sound", "|cFF8080FF7|r", [[Interface\Addons\UnhaltedUI\Sounds\7.ogg]])
    LSM:Register("sound", "|cFF8080FF8|r", [[Interface\Addons\UnhaltedUI\Sounds\8.ogg]])
    LSM:Register("sound", "|cFF8080FF9|r", [[Interface\Addons\UnhaltedUI\Sounds\9.ogg]])
    LSM:Register("sound", "|cFF8080FF10|r", [[Interface\Addons\UnhaltedUI\Sounds\10.ogg]])
    LSM:Register("sound", "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_1:16|t", [[Interface\Addons\UnhaltedUI\Sounds\01.ogg]])
    LSM:Register("sound", "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_2:16|t", [[Interface\Addons\UnhaltedUI\Sounds\02.ogg]])
    LSM:Register("sound", "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_3:16|t", [[Interface\Addons\UnhaltedUI\Sounds\03.ogg]])
    LSM:Register("sound", "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_4:16|t", [[Interface\Addons\UnhaltedUI\Sounds\04.ogg]])
    LSM:Register("sound", "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_5:16|t", [[Interface\Addons\UnhaltedUI\Sounds\05.ogg]])
    LSM:Register("sound", "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_6:16|t", [[Interface\Addons\UnhaltedUI\Sounds\06.ogg]])
    LSM:Register("sound", "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_7:16|t", [[Interface\Addons\UnhaltedUI\Sounds\07.ogg]])
    LSM:Register("sound", "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_8:16|t", [[Interface\Addons\UnhaltedUI\Sounds\08.ogg]])
    LSM:Register("sound", "|cFF8080FFAdd|r", [[Interface\Addons\UnhaltedUI\Sounds\Add.ogg]])
    LSM:Register("sound", "|cFF8080FFAdds|r", [[Interface\Addons\UnhaltedUI\Sounds\Adds.ogg]])
    LSM:Register("sound", "|cFF8080FFAffix|r", [[Interface\Addons\UnhaltedUI\Sounds\Affix.ogg]])
    LSM:Register("sound", "|cFF8080FFAoE|r", [[Interface\Addons\UnhaltedUI\Sounds\AoE.ogg]])
    LSM:Register("sound", "|cFF8080FFAssist|r", [[Interface\Addons\UnhaltedUI\Sounds\Assist.ogg]])
    LSM:Register("sound", "|cFF8080FFAvoid|r", [[Interface\Addons\UnhaltedUI\Sounds\Avoid.ogg]])
    LSM:Register("sound", "|cFF8080FFBack|r", [[Interface\Addons\UnhaltedUI\Sounds\Back.ogg]])
    LSM:Register("sound", "|cFF8080FFBackup|r", [[Interface\Addons\UnhaltedUI\Sounds\Backup.ogg]])
    LSM:Register("sound", "|cFF8080FFBait|r", [[Interface\Addons\UnhaltedUI\Sounds\Bait.ogg]])
    LSM:Register("sound", "|cFF8080FFBeam|r", [[Interface\Addons\UnhaltedUI\Sounds\Beam.ogg]])
    LSM:Register("sound", "|cFF8080FFBloodlust|r", [[Interface\Addons\UnhaltedUI\Sounds\Bloodlust.ogg]])
    LSM:Register("sound", "|cFF8080FFBlue|r", [[Interface\Addons\UnhaltedUI\Sounds\Blue.ogg]])
    LSM:Register("sound", "|cFF8080FFBoss|r", [[Interface\Addons\UnhaltedUI\Sounds\Boss.ogg]])
    LSM:Register("sound", "|cFF8080FFBreak|r", [[Interface\Addons\UnhaltedUI\Sounds\Break.ogg]])
    LSM:Register("sound", "|cFF8080FFBuff|r", [[Interface\Addons\UnhaltedUI\Sounds\Buff.ogg]])
    LSM:Register("sound", "|cFF8080FFCC|r", [[Interface\Addons\UnhaltedUI\Sounds\CC.ogg]])
    LSM:Register("sound", "|cFF8080FFCD|r", [[Interface\Addons\UnhaltedUI\Sounds\CD.ogg]])
    LSM:Register("sound", "|cFF8080FFCenter|r", [[Interface\Addons\UnhaltedUI\Sounds\Center.ogg]])
    LSM:Register("sound", "|cFF8080FFChain|r", [[Interface\Addons\UnhaltedUI\Sounds\Chain.ogg]])
    LSM:Register("sound", "|cFF8080FFCharge|r", [[Interface\Addons\UnhaltedUI\Sounds\Charge.ogg]])
    LSM:Register("sound", "|cFF8080FFClear|r", [[Interface\Addons\UnhaltedUI\Sounds\Clear.ogg]])
    LSM:Register("sound", "|cFF8080FFCollect|r", [[Interface\Addons\UnhaltedUI\Sounds\Collect.ogg]])
    LSM:Register("sound", "|cFF8080FFDance|r", [[Interface\Addons\UnhaltedUI\Sounds\Dance.ogg]])
    LSM:Register("sound", "|cFF8080FFDebuff|r", [[Interface\Addons\UnhaltedUI\Sounds\Debuff.ogg]])
    LSM:Register("sound", "|cFF8080FFDispell|r", [[Interface\Addons\UnhaltedUI\Sounds\Dispell.ogg]])
    LSM:Register("sound", "|cFF8080FFDodge|r", [[Interface\Addons\UnhaltedUI\Sounds\Dodge.ogg]])
    LSM:Register("sound", "|cFF8080FFDont Move|r", [[Interface\Addons\UnhaltedUI\Sounds\Dont Move.ogg]])
    LSM:Register("sound", "|cFF8080FFDot|r", [[Interface\Addons\UnhaltedUI\Sounds\Dot.ogg]])
    LSM:Register("sound", "|cFF8080FFDrop|r", [[Interface\Addons\UnhaltedUI\Sounds\Drop.ogg]])
    LSM:Register("sound", "|cFF8080FFEnter|r", [[Interface\Addons\UnhaltedUI\Sounds\Enter.ogg]])
    LSM:Register("sound", "|cFF8080FFEscort|r", [[Interface\Addons\UnhaltedUI\Sounds\Escort.ogg]])
    LSM:Register("sound", "|cFF8080FFExit|r", [[Interface\Addons\UnhaltedUI\Sounds\Exit.ogg]])
    LSM:Register("sound", "|cFF8080FFFixate|r", [[Interface\Addons\UnhaltedUI\Sounds\Fixate.ogg]])
    LSM:Register("sound", "|cFF8080FFFront|r", [[Interface\Addons\UnhaltedUI\Sounds\Front.ogg]])
    LSM:Register("sound", "|cFF8080FFGate|r", [[Interface\Addons\UnhaltedUI\Sounds\Gate.ogg]])
    LSM:Register("sound", "|cFF8080FFGather|r", [[Interface\Addons\UnhaltedUI\Sounds\Gather.ogg]])
    LSM:Register("sound", "|cFF8080FFGreen|r", [[Interface\Addons\UnhaltedUI\Sounds\Green.ogg]])
    LSM:Register("sound", "|cFF8080FFHealcd|r", [[Interface\Addons\UnhaltedUI\Sounds\Healcd.ogg]])
    LSM:Register("sound", "|cFF8080FFHide|r", [[Interface\Addons\UnhaltedUI\Sounds\Hide.ogg]])
    LSM:Register("sound", "|cFF8080FFHigh Energy|r", [[Interface\Addons\UnhaltedUI\Sounds\High Energy.ogg]])
    LSM:Register("sound", "|cFF8080FFHigh Stacks|r", [[Interface\Addons\UnhaltedUI\Sounds\High Stacks.ogg]])
    LSM:Register("sound", "|cFF8080FFImmunity|r", [[Interface\Addons\UnhaltedUI\Sounds\Immunity.ogg]])
    LSM:Register("sound", "|cFF8080FFIn|r", [[Interface\Addons\UnhaltedUI\Sounds\In.ogg]])
    LSM:Register("sound", "|cFF8080FFInterrupt|r", [[Interface\Addons\UnhaltedUI\Sounds\Interrupt.ogg]])
    LSM:Register("sound", "|cFF8080FFIntermission|r", [[Interface\Addons\UnhaltedUI\Sounds\Intermission.ogg]])
    LSM:Register("sound", "|cFF8080FFInvisibility|r", [[Interface\Addons\UnhaltedUI\Sounds\Invisibility.ogg]])
    LSM:Register("sound", "|cFF8080FFJump|r", [[Interface\Addons\UnhaltedUI\Sounds\Jump.ogg]])
    LSM:Register("sound", "|cFF8080FFKick|r", [[Interface\Addons\UnhaltedUI\Sounds\Kick.ogg]])
    LSM:Register("sound", "|cFF8080FFKnock|r", [[Interface\Addons\UnhaltedUI\Sounds\Knock.ogg]])
    LSM:Register("sound", "|cFF8080FFLeft|r", [[Interface\Addons\UnhaltedUI\Sounds\Left.ogg]])
    LSM:Register("sound", "|cFF8080FFLinked|r", [[Interface\Addons\UnhaltedUI\Sounds\Linked.ogg]])
    LSM:Register("sound", "|cFF8080FFLoS|r", [[Interface\Addons\UnhaltedUI\Sounds\LoS.ogg]])
    LSM:Register("sound", "|cFF8080FFMelee|r", [[Interface\Addons\UnhaltedUI\Sounds\Melee.ogg]])
    LSM:Register("sound", "|cFF8080FFMove|r", [[Interface\Addons\UnhaltedUI\Sounds\Move.ogg]])
    LSM:Register("sound", "|cFF8080FFNext|r", [[Interface\Addons\UnhaltedUI\Sounds\Next.ogg]])
    LSM:Register("sound", "|cFF8080FFNuke|r", [[Interface\Addons\UnhaltedUI\Sounds\Nuke.ogg]])
    LSM:Register("sound", "|cFF8080FFOrange|r", [[Interface\Addons\UnhaltedUI\Sounds\Orange.ogg]])
    LSM:Register("sound", "|cFF8080FFOrb|r", [[Interface\Addons\UnhaltedUI\Sounds\Orb.ogg]])
    LSM:Register("sound", "|cFF8080FFOut|r", [[Interface\Addons\UnhaltedUI\Sounds\Out.ogg]])
    LSM:Register("sound", "|cFF8080FFOverlap|r", [[Interface\Addons\UnhaltedUI\Sounds\Overlap.ogg]])
    LSM:Register("sound", "|cFF8080FFPhase2|r", [[Interface\Addons\UnhaltedUI\Sounds\Phase2.ogg]])
    LSM:Register("sound", "|cFF8080FFPhase3|r", [[Interface\Addons\UnhaltedUI\Sounds\Phase3.ogg]])
    LSM:Register("sound", "|cFF8080FFPots|r", [[Interface\Addons\UnhaltedUI\Sounds\Pots.ogg]])
    LSM:Register("sound", "|cFF8080FFPull|r", [[Interface\Addons\UnhaltedUI\Sounds\Pull.ogg]])
    LSM:Register("sound", "|cFF8080FFPurple|r", [[Interface\Addons\UnhaltedUI\Sounds\Purple.ogg]])
    LSM:Register("sound", "|cFF8080FFPush|r", [[Interface\Addons\UnhaltedUI\Sounds\Push.ogg]])
    LSM:Register("sound", "|cFF8080FFRange|r", [[Interface\Addons\UnhaltedUI\Sounds\Range.ogg]])
    LSM:Register("sound", "|cFF8080FFReady|r", [[Interface\Addons\UnhaltedUI\Sounds\Ready.ogg]])
    LSM:Register("sound", "|cFF8080FFRed|r", [[Interface\Addons\UnhaltedUI\Sounds\Red.ogg]])
    LSM:Register("sound", "|cFF8080FFReflect|r", [[Interface\Addons\UnhaltedUI\Sounds\Reflect.ogg]])
    LSM:Register("sound", "|cFF8080FFRight|r", [[Interface\Addons\UnhaltedUI\Sounds\Right.ogg]])
    LSM:Register("sound", "|cFF8080FFRoot|r", [[Interface\Addons\UnhaltedUI\Sounds\Root.ogg]])
    LSM:Register("sound", "|cFF8080FFSeed|r", [[Interface\Addons\UnhaltedUI\Sounds\Seed.ogg]])
    LSM:Register("sound", "|cFF8080FFSentry|r", [[Interface\Addons\UnhaltedUI\Sounds\Sentry.ogg]])
    LSM:Register("sound", "|cFF8080FFSelfcd|r", [[Interface\Addons\UnhaltedUI\Sounds\Selfcd.ogg]])
    LSM:Register("sound", "|cFF8080FFShield|r", [[Interface\Addons\UnhaltedUI\Sounds\Shield.ogg]])
    LSM:Register("sound", "|cFF8080FFSoak|r", [[Interface\Addons\UnhaltedUI\Sounds\Soak.ogg]])
    LSM:Register("sound", "|cFF8080FFSoon|r", [[Interface\Addons\UnhaltedUI\Sounds\Soon.ogg]])
    LSM:Register("sound", "|cFF8080FFSpawn|r", [[Interface\Addons\UnhaltedUI\Sounds\Spawn.ogg]])
    LSM:Register("sound", "|cFF8080FFSpellsteal|r", [[Interface\Addons\UnhaltedUI\Sounds\Spellsteal.ogg]])
    LSM:Register("sound", "|cFF8080FFSplit|r", [[Interface\Addons\UnhaltedUI\Sounds\Split.ogg]])
    LSM:Register("sound", "|cFF8080FFSpread|r", [[Interface\Addons\UnhaltedUI\Sounds\Spread.ogg]])
    LSM:Register("sound", "|cFF8080FFStack|r", [[Interface\Addons\UnhaltedUI\Sounds\Stack.ogg]])
    LSM:Register("sound", "|cFF8080FFStop|r", [[Interface\Addons\UnhaltedUI\Sounds\Stop.ogg]])
    LSM:Register("sound", "|cFF8080FFStopcast|r", [[Interface\Addons\UnhaltedUI\Sounds\Stopcast.ogg]])
    LSM:Register("sound", "|cFF8080FFSwitch|r", [[Interface\Addons\UnhaltedUI\Sounds\Switch.ogg]])
    LSM:Register("sound", "|cFF8080FFTargeted|r", [[Interface\Addons\UnhaltedUI\Sounds\Targeted.ogg]])
    LSM:Register("sound", "|cFF8080FFTaunt|r", [[Interface\Addons\UnhaltedUI\Sounds\Taunt.ogg]])
    LSM:Register("sound", "|cFF8080FFTotem|r", [[Interface\Addons\UnhaltedUI\Sounds\Totem.ogg]])
    LSM:Register("sound", "|cFF8080FFTransition|r", [[Interface\Addons\UnhaltedUI\Sounds\Transition.ogg]])
    LSM:Register("sound", "|cFF8080FFTrap|r", [[Interface\Addons\UnhaltedUI\Sounds\Trap.ogg]])
    LSM:Register("sound", "|cFF8080FFTurn|r", [[Interface\Addons\UnhaltedUI\Sounds\Turn.ogg]])
    LSM:Register("sound", "|cFF8080FFWave|r", [[Interface\Addons\UnhaltedUI\Sounds\Wave.ogg]])
    LSM:Register("sound", "|cFF8080FFWinds|r", [[Interface\Addons\UnhaltedUI\Sounds\Winds.ogg]])
    LSM:Register("sound", "|cFF8080FFYellow|r", [[Interface\Addons\UnhaltedUI\Sounds\Yellow.ogg]])
    LSM:Register("sound", "|cFF8080FFZone|r", [[Interface\Addons\UnhaltedUI\Sounds\Zone.ogg]])
    LSM:Register("sound", "|cFF8080FFKick|r", [[Interface\Addons\UnhaltedUI\Sounds\Kick.ogg]])
    LSM:Register("sound", "|cFF8080FFFrontal|r", [[Interface\Addons\UnhaltedUI\Sounds\Frontal.ogg]])
end

UHUI:RegisterSlashCommands()
UHUI:SkipCinematics()
UHUI:HideTalkingHead()
UHUI:RemoveTransforms()
UHUI:RegisterMedia()
UHUI:HideCrafter()
UHUI:FasterAutoLoot()
