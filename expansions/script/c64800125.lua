--游离于深层幻夜的巨鲸
function c64800125.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(64800125,0))
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,64800125)
	e1:SetCondition(c64800125.thcon)
	e1:SetTarget(c64800125.thtg)
	e1:SetOperation(c64800125.thop)
	c:RegisterEffect(e1)
end
function c64800125.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c64800125.tgfilter(c,lv)
	return c:IsAbleToGrave() and c:IsSetCard(0x341a) and not c:IsLevel(lv) 
end
function c64800125.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) or Duel.IsExistingMatchingCard(c64800125.tgfilter,tp,LOCATION_DECK,0,1,nil,e:GetHandler():GetLevel()) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	if not Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) then 
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	end
end
function c64800125.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)~=0 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local g=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			if Duel.SendtoGrave(tc,REASON_DISCARD) and tc:GetLevel()~=e:GetHandler():GetLevel() and e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsFaceup() and Duel.SelectYesNo(tp,aux.Stringid(64800125,0)) then 
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_LEVEL)
				e1:SetValue(tc:GetLevel())
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e:GetHandler():RegisterEffect(e1)
			end
		end
	else
		if Duel.IsExistingMatchingCard(c64800125.tgfilter,tp,LOCATION_DECK,0,1,nil) and e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsFaceup() then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g=Duel.SelectMatchingCard(tp,c64800125.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
			local tc=g:GetFirst()
			if tc then
				if Duel.SendtoGrave(tc,REASON_EFFECT) and tc:GetLevel()~=e:GetHandler():GetLevel() and Duel.SelectYesNo(tp,aux.Stringid(64800125,0)) then 
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_CHANGE_LEVEL)
					e1:SetValue(tc:GetLevel())
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					e:GetHandler():RegisterEffect(e1)
				end
			end
		end
	end
end