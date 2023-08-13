--辉神谕令
local m=60002302
local cm=_G["c"..m]
function cm.initial_effect(c)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_DECK)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.con)
	e1:SetCost(cm.cost)
	e1:SetOperation(cm.op0)
	c:RegisterEffect(e1)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_SPSUMMON)
	e1:SetRange(LOCATION_DECK)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.con)
	e1:SetCost(cm.cost)
	e1:SetOperation(cm.op0)
	c:RegisterEffect(e1)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_SUMMON)
	e1:SetRange(LOCATION_DECK)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.con)
	e1:SetCost(cm.cost)
	e1:SetOperation(cm.op0)
	c:RegisterEffect(e1)
end
function cm.cpfilter(c)
	return (c:IsType(TYPE_TRAP) or c:IsType(TYPE_SPELL)) 
		and c:CheckActivateEffect(false,false,false)~=nil
end
function cm.con(e,c)
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(cm.cpfilter,tp,LOCATION_DECK,0,1,nil)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c,REASON_COST)
end
function cm.op0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,m)==0 then
		Duel.SendtoGrave(c,REASON_COST)
		local g1=Duel.GetMatchingGroup(cm.cpfilter,tp,LOCATION_DECK,0,nil)
		local gm1=g1:Select(tp,1,1,nil)
		local e11=gm1:GetFirst():GetActivateEffect()
		Duel.Activate(e11)
	end
	if Duel.GetFlagEffect(tp,m)~=0 then
		Duel.Win(1-tp,WIN_REASON_DRAW_OF_FATE)
	else
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	end
end
