--公园岂是如此不便之物
local s,id,o=GetID()
if not s.name_effects then s.name_effects={} end
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_FZONE+LOCATION_GRAVE)
	e2:SetCondition(s.namecon)
	e2:SetOperation(s.nameop)
	c:RegisterEffect(e2)
end
function s.namecon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()==tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function s.nameop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,id)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp)
	if s.name_effects[c] then
		pcall(function() s.name_effects[c]:Reset() end)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(ac)
	local reset_val=RESETS_STANDARD
	if c:IsLocation(LOCATION_GRAVE) then
		reset_val=RESETS_STANDARD-RESET_TOGRAVE
	end
	e1:SetReset(RESET_EVENT+reset_val)
	c:RegisterEffect(e1)
	s.name_effects[c]=e1
end