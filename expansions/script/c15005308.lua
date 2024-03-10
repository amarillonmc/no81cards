local m=15005308
local cm=_G["c"..m]
cm.name="晶傀不对称"
function cm.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e0:SetCost(cm.cost)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(cm.chcon)
	e1:SetValue(cm.chval)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.destg)
	e2:SetOperation(cm.desop)
	c:RegisterEffect(e2)
end
function cm.sgfilter(c)
	return c:IsAbleToGraveAsCost() and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and c:IsFaceupEx()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if chk==0 then return true end
	local b=Duel.IsExistingMatchingCard(cm.sgfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,c)
	if b and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tc=Duel.SelectMatchingCard(tp,cm.sgfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,c):GetFirst()
		Duel.SendtoGrave(tc,REASON_COST)
		local code=tc:GetOriginalCodeRule()
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1,code)
	end
end
function cm.chcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	return c:GetFlagEffect(m)~=0
end
function cm.chval(e)
	local c=e:GetHandler()
	local tp=c:GetControler()
	return c:GetFlagEffectLabel(m)
end
function cm.trfilter(c)
	return cm.tr1filter(c) or cm.tr2filter(c)
end
function cm.tr1filter(c)
	return c:IsOriginalSetCard(0xcf38) and not c:IsSetCard(0xcf38) and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function cm.tr2filter(c)
	return c:IsSetCard(0xcf38) and not c:IsCode(c:GetOriginalCodeRule()) and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.trfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.trfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.trfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local ag=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,ag,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and cm.trfilter(tc) then
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_CHANGE_CODE)
		e5:SetValue(tc:GetOriginalCodeRule())
		e5:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e5)
		local ag=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
		if #ag~=0 and tc:IsCode(tc:GetOriginalCodeRule()) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
			if #g>0 then
				Duel.BreakEffect()
				Duel.HintSelection(g)
				Duel.Destroy(g,REASON_EFFECT)
			end
		end
	end
end