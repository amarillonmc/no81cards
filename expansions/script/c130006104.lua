--他人格 ～嫉妒～
local cm,m=GetID()
if not pcall(function() require("expansions/script/c130006111") end) then require("script/c130006111") end
cm.AlterEgo=true
function cm.initial_effect(c)
	ae.initial(c)
	--activate cost
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_ACTIVATE_COST)
	e1:SetRange(LOCATION_SZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetCondition(cm.costcon)
	e1:SetCost(cm.costchk)
	e1:SetOperation(cm.costop)
	c:RegisterEffect(e1)
	--immune
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,1))
	e6:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCountLimit(1,m)
	e6:SetCode(EVENT_CHAINING)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(cm.spcon)
	e6:SetTarget(cm.sptg)
	e6:SetOperation(cm.spop)
	c:RegisterEffect(e6)
end
function cm.costcon(e)
	local tp=e:GetHandlerPlayer()
	if e:GetHandler():GetFlagEffect(m)==0 then return false end
	cm[0]=false
	return true
end
function cm.filter(c,tpe)
	return c:IsType(tpe) and c:IsDiscardable()
end
function cm.costchk(e,re,tp)
	local rtype=bit.band(re:GetActiveType(),0x7)
	if not Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,re:GetHandler(),rtype) then return false end
	e:SetLabel(rtype)
	return true
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	if cm[0] then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	Duel.DiscardHand(tp,cm.filter,1,1,REASON_COST+REASON_DISCARD,nil,e:GetLabel())
	cm[0]=true
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function cm.thfilter(c,tpe)
	return c:IsType(tpe) and c:IsAbleToHand()
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rtype=bit.band(re:GetActiveType(),0x7)
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil,rtype)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local rtype=bit.band(re:GetActiveType(),0x7)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,rtype)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end