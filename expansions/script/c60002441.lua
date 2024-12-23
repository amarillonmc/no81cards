--无名心音
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,60002438)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.fil1(c)
	return aux.IsCodeListed(c,60002438) and c:IsAbleToHand() and not c:IsCode(m)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=false
	local b2=false
	if Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_MZONE,0,1,nil) then b1=true end
	if Duel.IsExistingMatchingCard(cm.fil1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then b2=true end
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(m,1)},{b2,aux.Stringid(m,2)})
	if op==1 then Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,tp,LOCATION_MZONE)
		and Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE) end
	e:SetLabel(op)
end

function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		if not Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_MZONE,0,1,nil) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSITION)
		local tc=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_MZONE,0,nil):Select(tp,1,1,nil)
		Duel.ChangePosition(tc,POS_FACEUP)
	elseif op==2 then
		if not Duel.IsExistingMatchingCard(cm.fil1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.fil1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
	if c:IsRelateToEffect(e) and c:IsCanTurnSet() and e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.GetCurrentChain()>1 then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end