--莜莱妮卡 计划之末
local m=60001075
local cm=_G["c"..m]

function cm.initial_effect(c)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.tgrco)
	e2:SetTarget(cm.tgrtg)
	e2:SetOperation(cm.tgrop)
	c:RegisterEffect(e2)
	--limit
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,160001075)
	e1:SetCost(cm.licost)
	e1:SetOperation(cm.liop)
	c:RegisterEffect(e1)
end

function cm.tgrco(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end

function cm.tgtgrfilter(c,code)
	return c:IsSetCard(0x6621) and c:IsAbleToHand() and not c:IsCode(code)
end

function cm.tgrtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgtgrfilter,tp,LOCATION_DECK,0,1,nil,e:GetHandler():GetCode()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function cm.tgrop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.tgtgrfilter,tp,LOCATION_DECK,0,1,1,nil,e:GetHandler():GetCode())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function cm.costlifilter(c)
	return c:IsSetCard(0x46) and c:IsAbleToGrave()
end

function cm.licost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costlifilter,tp,LOCATION_HAND,0,1,c) and c:IsAbleToGrave() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.costlifilter,tp,LOCATION_HAND,0,1,1,c)
	if g then g:AddCard(c) end
	Duel.SendtoGrave(g,REASON_COST)
end

function cm.liop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,1)
	e1:SetCondition(cm.condition1)
	e1:SetValue(cm.aclimit1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAINING)
	e3:SetReset(RESET_PHASE+PHASE_END)
	e3:SetOperation(cm.negop)
	Duel.RegisterEffect(e3,tp)
end

function cm.condition1(e,tp)
	return Duel.GetFlagEffect(tp,m)==0
end

function cm.aclimit1(e,re,tp)
	return re:GetActivateLocation()==LOCATION_HAND 
end

function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ResetFlagEffect(tp,m)
	local c=e:GetHandler()
	local loc=re:GetActivateLocation()
	if loc==LOCATION_SZONE or loc==LOCATION_MZONE then loc=LOCATION_ONFIELD end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1,loc)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,1)
	e1:SetLabel(LOCATION_HAND)
	e1:SetCondition(cm.condition)
	e1:SetValue(cm.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetLabel(LOCATION_DECK)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetLabel(LOCATION_ONFIELD)
	Duel.RegisterEffect(e3,tp)
	local e4=e1:Clone()
	e4:SetLabel(LOCATION_GRAVE)
	Duel.RegisterEffect(e4,tp)
	local e5=e1:Clone()
	e5:SetLabel(LOCATION_EXTRA)
	Duel.RegisterEffect(e5,tp)
	local e6=e1:Clone()
	e6:SetLabel(LOCATION_REMOVED)
	Duel.RegisterEffect(e6,tp)
end

function cm.condition(e,tp)
	return Duel.GetFlagEffectLabel(tp,m)==e:GetLabel()
end

function cm.aclimit(e,re,tp)
	return re:GetActivateLocation()==e:GetLabel()
end