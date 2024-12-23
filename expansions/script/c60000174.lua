--律法先驱
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,60000163)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e0:SetCondition(cm.handcon)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.confil(c)
	return c:IsCode(60000163) and c:IsFaceup()
end
function cm.handcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.confil,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function cm.filter1(c)
	return c:IsCode(m) and c:IsAbleToHand()
end
function cm.filter2(c)
	return c:IsCode(m) and c:IsAbleToDeck()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=false
	local b2=false
	if Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_DECK,0,1,nil) then b1=true end
	if Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_GRAVE,0,2,nil) then b2=true end
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(m,1)},{b2,aux.Stringid(m,2)})
	if op==1 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	elseif op==2 then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
	e:SetLabel(op)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.filter1,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_GRAVE,0,2,2,nil)
		if g:GetCount()==2 and Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then
			Duel.Draw(tp,1,REASON_EFFECT)
			Duel.BreakEffect()
			e:GetHandler():CancelToGrave()
			Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_RULE)
		end
	end
end











