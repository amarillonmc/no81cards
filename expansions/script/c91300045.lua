--俏丽魔发师
local s,id,o=GetID()
function s.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(TIMING_END_PHASE,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(s.spcost)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
function s.filter1(c,tp,tc)
	return c:IsType(TYPE_MONSTER) and not c:IsPublic() and not c:IsCode(tc:GetCode()) and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_DECK,0,1,nil,tp,c,tc)
end
function s.filter2(c,tp,mc,tc)
	local g=Group.FromCards(c,mc,tc)
	return c:IsType(TYPE_MONSTER) and g:GetClassCount(Card.GetCode)==3 and g:GetClassCount(Card.GetLevel)==2 and g:GetClassCount(Card.GetRace)==2 and g:GetClassCount(Card.GetAttribute)==2
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_HAND,0,1,nil,tp,c) and not c:IsPublic() end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	local pc=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_HAND,0,1,1,c,tp,c):GetFirst()
	Duel.ConfirmCards(1-tp,pc)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	pc:RegisterEffect(e1)
	local e2=e1:Clone()
	c:RegisterEffect(e2)
	e:SetLabel(pc:GetOriginalCode())
	e:SetLabelObject(pc)
	Duel.SetTargetCard(pc)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local code=e:GetLabel()
	local name=e:GetLabelObject():GetOriginalCodeRule()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g1=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_DECK,0,1,1,nil,tp,c,tc)
	if g1:GetCount()==0 then return end
	Duel.ConfirmCards(1-tp,g1)
	if c:IsRelateToEffect(e) and c:IsPublic() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(name)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		c:ReplaceEffect(code,RESET_EVENT+RESETS_STANDARD)
	end
	if tc:IsRelateToEffect(e) and tc:IsPublic() then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_CODE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(g1:GetFirst():GetOriginalCode())
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		tc:ReplaceEffect(g1:GetFirst():GetOriginalCode(),RESET_EVENT+RESETS_STANDARD)
	end
end