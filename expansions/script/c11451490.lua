--序列纪时者
--21.04.10
local m=11451490
local cm=_G["c"..m]
function cm.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DECK_REVERSE_CHECK)
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.redcon)
	e1:SetCost(cm.redcost)
	e1:SetOperation(cm.redop)
	c:RegisterEffect(e1)
end
function cm.redcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function cm.redcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function cm.redop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_REVERSE_DECK)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_DRAW)
	e2:SetTarget(cm.cttg)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_TO_GRAVE)
	Duel.RegisterEffect(e3,tp)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_CANNOT_TO_HAND)
	Duel.RegisterEffect(e4,tp)
	local e5=e2:Clone()
	e5:SetCode(EFFECT_CANNOT_REMOVE)
	Duel.RegisterEffect(e5,tp)
	local e6=e2:Clone()
	e6:SetCode(EFFECT_CANNOT_DISCARD_DECK)
	Duel.RegisterEffect(e6,tp)
end
function cm.cttg(e,c)
	return c:IsLocation(LOCATION_DECK) and Duel.GetDecktopGroup(c:GetControler(),1):IsContains(c) and Duel.GetCurrentPhase()~=PHASE_DRAW
end