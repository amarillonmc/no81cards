--修罗场
local m=33701522
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.distg)
	e1:SetOperation(cm.disop)
	c:RegisterEffect(e1)
	
end
function cm.cfilter(c,e,p)
	return c:IsControler(p) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 and c:IsCanBeEffectTarget(e)
end
function cm.disfilter(c,e)
	local p=c:GetControler()
	return c:GetSequence()<5 and c:IsCanBeEffectTarget(e) and c:GetColumnGroup(1,1):Filter(cm.cfilter,nil,e,p):GetCount()>=3
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.disfilter,tp,0,LOCATION_MZONE,1,nil,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local tg=Duel.SelectMatchingCard(tp,cm.disfilter,tp,0,LOCATION_MZONE,1,1,nil,e)
	local tc=tg:GetFirst()
	e:SetLabelObject(tc)
	local g=tc:GetColumnGroup(1,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local tg1=g:FilterSelect(tp,cm.cfilter,tp,0,LOCATION_MZONE,2,2,tc,e,1-tp)
	tg:Merge(tg1)
	Duel.SetTargetCard(tg)
end
function cm.filter1(c,p)
	return c:IsControler(p) and c:GetSequence()<5 and c:GetColumnGroup(1,1):Filter(cm.filter2,nil,e,p):GetCount()>=3
end
function cm.filter2(c,p)
	return c:IsControler(p) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()<=0 then return end
	local tc=tg:GetFirst()
	while tc do
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
		tc=tg:GetNext()
	end
	local tc1=e:GetLabelObject()
	local t1=tc1:IsRelateToEffect(e)
	local t2=tc1:IsRelateToEffect(e) and tg:IsExists(cm.filter1,1,nil,1-tp)
	local ct=0
	if t1 or t2 then
		Duel.BreakEffect()
		if t1 and t2 then
			ct=Duel.SelectOption(1-tp,aux.Stringid(m,0),aux.Stringid(m,1))
		elseif t1 then
			ct=Duel.SelectOption(1-tp,aux.Stringid(m,0))
		elseif t2 then
			ct=Duel.SelectOption(1-tp,aux.Stringid(m,1))
		end
		if ct==1 then
			Duel.SendtoGrave(tc1,REASON_RULE)
		elseif ct==2 then
			Duel.SendtoHand(tg,nil,REASON_RULE)
		end
	end
end
