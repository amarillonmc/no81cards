--淘气精灵 百江渚
Duel.LoadScript("c60152900.lua")
local s,id,o = GetID()
function s.initial_effect(c)
	local e1 = Scl.CreateIgnitionEffect(c, "AttachXyzMaterial", {1, id}, 
		"AttachXyzMaterial", "Target", "Hand,GY", nil, nil, 
		{ "Target", s.mfilter, "Self", "MonsterZone" }, s.atop)
	local e2 = Scl.CreateSingleBuffConditionGainedByXyzMaterial(c, 
		"!BeTribute,!BeSpecialSummonMaterial", 1)
	local e3 = Scl.CreateSingleTriggerOptionalEffect(c, EVENT_TO_GRAVE, {id, 2},
		nil, nil, nil, s.skipcon, nil, nil, s.skipop)
end
function s.mfilter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:GetOverlayGroup():IsExists(Card.IsType, 1, nil, TYPE_NORMAL) and e:GetHandler():IsCanOverlay()
end
function s.atop(e,tp)
	local _, c = Scl.GetActivateCard()
	local _, tc = Scl.GetTargetsReleate2Chain()
	if c and tc and tc:IsType(TYPE_XYZ) and c:IsCanOverlay() then
		Duel.Overlay(tc, Group.FromCards(c))
	end
end
function s.skipcon(e,tp)
	return e:GetHandler():IsPreviousLocation(LOCATION_OVERLAY)
end
function s.skipop(e,tp)
	local ph=Duel.GetCurrentPhase()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SKIP_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	if Duel.GetTurnPlayer()~=tp and ph>PHASE_MAIN1 and ph<PHASE_MAIN2 then
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetCondition(s.skipcon)
		e1:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_OPPO_TURN,2)
	else
		e1:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_OPPO_TURN,1)
	end
	Duel.RegisterEffect(e1,tp)
end
function s.skipcon(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end