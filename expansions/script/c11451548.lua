--波动域·共振
--21.07.14
local m=11451548
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--copy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.cptg)
	e2:SetOperation(cm.cpop)
	c:RegisterEffect(e2)
end
function cm.cfilter(c,tp)
	return c:IsRace(RACE_PSYCHO) and c:IsType(TYPE_MONSTER) and c:IsLevelAbove(1) and not c:IsPublic() and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c:GetLevel())
end
function cm.filter(c,lv)
	return c:IsLevelAbove(1) and c:IsFaceup() and not c:IsLevel(lv)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_HAND,0,nil,tp)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg=g:Select(tp,1,1,nil)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleHand(tp)
		e:SetLabel(sg:GetFirst():GetLevel())
	else
		e:SetLabel(0)
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e:GetLabel())
	if e:GetHandler():IsRelateToEffect(e) and e:GetLabel()>0 and #g>0 then
		for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(e:GetLabel())
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		end
	end
end
function cm.copyfilter(c,tp)
	return c:IsFaceup() and c:IsLevelAbove(1) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_PSYCHO) and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,c:GetLevel())
end
function cm.filter2(c,lv)
	return c:IsFaceup() and c:IsLevel(lv) and c:IsType(TYPE_EFFECT)
end
function cm.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and cm.copyfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.copyfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cm.copyfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
end
function cm.cpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,tc,tc:GetLevel())
	if tc and c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and (not tc:IsLocation(LOCATION_MZONE) or tc:IsFaceup()) and not tc:IsType(TYPE_TOKEN) and #g>0 then
		local fc=g:Select(tp,1,1,nil):GetFirst()
		local code=tc:GetOriginalCode()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		fc:RegisterEffect(e1)
		if not tc:IsType(TYPE_TRAPMONSTER) then fc:CopyEffect(code,RESET_EVENT+RESETS_STANDARD,1) end
	end
end