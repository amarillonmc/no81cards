--自我思想
local m=60000053
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chkc then return chkc:IsOnField() and cm.tf21(chkc) and chkc:IsControler(1-tp) end
		if chk==0 then return Duel.IsExistingMatchingCard(cm.tf22,tp,LOCATION_DECK,0,1,nil)
			and Duel.IsExistingTarget(cm.tf21,tp,0,LOCATION_MZONE,1,nil) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local tc=Duel.SelectTarget(tp,cm.tf21,tp,0,LOCATION_MZONE,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.tf22,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,g)
			local tc=Duel.GetFirstTarget()
			if tc:IsRelateToEffect(e) then
				Duel.BreakEffect()
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_LEVEL)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(-5)
				tc:RegisterEffect(e1)
			end
		end
	end)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,m)
	e2:SetRange(LOCATION_GRAVE) 
	e2:SetCondition(aux.exccon)
	e2:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
		Duel.SendtoDeck(e:GetHandler(),tp,2,REASON_COST)
	end)
	e2:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(cm.tf22,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
		local g=Duel.GetMatchingGroup(cm.tf22,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
	end)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.tf22,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end)
	c:RegisterEffect(e2)
end
--e2
function cm.tf21(c)
	return c:IsLevelAbove(6) and c:IsFaceup()
end
function cm.tf22(c)
	return c:IsSetCard(0x628) and c:GetType()==0x10002 and c:IsAbleToHand()
end