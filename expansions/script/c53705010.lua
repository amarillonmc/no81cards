local m=53705010
local cm=_G["c"..m]
cm.name="幻海袭 模型"
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	SNNM.SeadowRover(c)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
end
function cm.pubfilter(c)
	return c:IsSetCard(0x3534) and c:IsPublic()
end
function cm.rmfilter(c)
	return c:IsPublic() and c:IsAbleToGrave()
end
function cm.thfilter(c)
	return c:IsSetCard(0x3534) and c:IsLevel(6) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsPublic() then return end
	if Duel.IsExistingMatchingCard(cm.pubfilter,tp,LOCATION_HAND,0,1,c) then
		SNNM.SetPublic(c,3,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		if Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(cm.rmfilter,tp,LOCATION_HAND,0,1,c) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g=Duel.SelectMatchingCard(tp,cm.rmfilter,tp,LOCATION_HAND,0,1,1,c)
			local ct=Duel.SendtoGrave(g,REASON_EFFECT)
			if ct==0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g2=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			if g2:GetCount()>0 then
				Duel.SendtoHand(g2,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g2)
			end
		end
	else SNNM.SetPublic(c,4,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2) end
end
