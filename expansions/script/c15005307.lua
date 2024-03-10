local m=15005307
local cm=_G["c"..m]
cm.name="晶傀溶解"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.trfilter(c,tp)
	return c:IsOriginalSetCard(0xcf38) and not c:IsSetCard(0xcf38) and c:IsFaceup() and Duel.IsExistingTarget(cm.filter,tp,0,LOCATION_MZONE,1,nil) and aux.NegateMonsterFilter(c)
end
function cm.filter(c)
	return not c:IsSetCard(0xcf38) and c:IsType(TYPE_MONSTER) and c:IsFaceup() and aux.NegateMonsterFilter(c)
end
function cm.gcheck(g,tp)
	if g:GetCount()~=2 then return false end
	local tc1=g:Filter(Card.IsControler,nil,tp):GetFirst()
	local tc2=g:Filter(Card.IsControler,nil,1-tp):GetFirst()
	return g:GetClassCount(Card.GetControler)==2 and tc1 and tc2 and cm.trfilter(tc1,tp) and cm.filter(tc2)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.trfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.trfilter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local ag=g:SelectSubGroup(tp,cm.gcheck,false,2,2,tp)
	Duel.SetTargetCard(ag)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	while tc do
		if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsCanBeDisabledByEffect(e) then
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
			local e5=Effect.CreateEffect(c)
			e5:SetType(EFFECT_TYPE_SINGLE)
			e5:SetCode(EFFECT_CHANGE_CODE)
			e5:SetValue(15005301)
			e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e5)
		end
		tc=g:GetNext()
	end
end