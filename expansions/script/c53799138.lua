local m=53799138
local cm=_G["c"..m]
cm.name="热浪"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.cfilter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_HAND,0,nil)
	if chk==0 then return g:GetClassCount(Card.GetCode)>1 end
	local ct=Duel.GetTargetCount(Card.IsFacedown,tp,0,LOCATION_SZONE,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local cg=g:SelectSubGroup(tp,aux.dncheck,false,2,ct)
	Duel.ConfirmCards(1-tp,cg)
	Duel.ShuffleHand(tp)
	e:SetLabel(cg:GetCount())
end
function cm.thfilter(c)
	return c:IsFacedown() and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(1-tp) and chkc:IsFacedown() and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(cm.thfilter,tp,0,LOCATION_SZONE,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,cm.thfilter,tp,0,LOCATION_SZONE,e:GetLabel(),e:GetLabel(),nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		for tc in aux.Next(g) do
			Duel.SetChainLimit(cm.limit(tc))
		end
	end
end
function cm.limit(c)
	return  function (e,lp,tp)
				return e:GetHandler()~=c
			end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
