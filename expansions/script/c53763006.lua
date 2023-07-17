local m=53763006
local cm=_G["c"..m]
cm.name="黑色泥泞艾克萨希德隆"
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	SNNM.Ranclock(c,CATEGORY_TOHAND+CATEGORY_SEARCH,ATTRIBUTE_EARTH,cm.op,ATTRIBUTE_DARK)
end
function cm.dfilter(c)
	return c:IsFaceupEx() and c:IsRace(RACE_FIEND) and c:IsLevelAbove(7)
end
function cm.thfilter(c)
	return c:IsRace(RACE_FIEND) and c:IsAbleToHand()
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local tc=Duel.SelectMatchingCard(tp,cm.dfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil):GetFirst()
	local attr=tc:GetAttribute()
	if Duel.Destroy(tc,REASON_EFFECT)~=0 and bit.band(attr,ATTRIBUTE_WIND)~=0 then
		Duel.BreakEffect()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCountLimit(1)
		if Duel.GetCurrentPhase()==PHASE_STANDBY then
			e1:SetLabel(Duel.GetTurnCount())
			e1:SetCondition(cm.thcon2)
			e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
		else
			e1:SetCondition(cm.thcon)
			e1:SetReset(RESET_PHASE+PHASE_STANDBY)
		end
		e1:SetOperation(cm.thop)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil)
end
function cm.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return cm.thcon(e,tp,eg,ep,ev,re,r,rp) and Duel.GetTurnCount()~=e:GetLabel()
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message(2)
	if not Duel.SelectYesNo(tp,aux.Stringid(m,0)) then return end
	Duel.Hint(HINT_CARD,0,m)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
