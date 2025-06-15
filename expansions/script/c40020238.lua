--假面骑士 极狐Ⅸ
local m=40020238
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,40020225)
	--Synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--mat check
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(cm.matcheck)
	c:RegisterEffect(e0)
	--synchro summon success
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.regcon)
	e1:SetOperation(cm.regop)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,m)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetTarget(cm.tdtg)
	e2:SetOperation(cm.tdop)
	c:RegisterEffect(e2)
end
function cm.matcheck(e,c)
	local c=e:GetHandler()
	local g=c:GetMaterial()
	local check=0
	if g:IsExists(Card.IsCode,1,nil,40020226) then
		check=1
	end
	e:SetLabel(check)
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local check=e:GetLabelObject():GetLabel()
	if check>0 then
		--cannot target
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(m,2))
		e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetCode(EVENT_CHAINING)
		e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCountLimit(1)
		e1:SetCondition(cm.negcon)
		e1:SetTarget(cm.negtg)
		e1:SetOperation(cm.negop)
		c:RegisterEffect(e1)
	end
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		if Duel.Destroy(eg,REASON_EFFECT) and Duel.IsExistingMatchingCard(cm.ctfilter,tp,LOCATION_ONFIELD,0,1,nil) then
			local g=Duel.SelectMatchingCard(tp,cm.ctfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
			local tc=g:GetFirst()
			tc:AddCounter(0xf12,1)
			if tc:GetCounter(0xf12)==1 or tc:GetCounter(0xf12)==2 or tc:GetCounter(0xf12)==3 or tc:GetCounter(0xf12)==4 then
				Duel.RaiseEvent(tc,EVENT_CUSTOM+40020225,e,0,tp,tp,0)
			end
			if tc:GetCounter(0xf12)==3 or tc:GetCounter(0xf12)==4 or tc:GetCounter(0xf12)==5 then
				Duel.RaiseEvent(tc,EVENT_CUSTOM+40020235,e,0,tp,tp,0)
			end
			if tc:GetCounter(0xf12)==4 or tc:GetCounter(0xf12)==6 then
				Duel.RaiseEvent(tc,EVENT_CUSTOM+40020325,e,0,tp,tp,0)
			end
		end
	end
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return #g>0 end
	if g:GetCount()>0 then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	end
end
function cm.ctfilter(c)
	return c:IsFaceup() and c:IsCode(40020225) and c:IsCanAddCounter(0xf12,1)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g1:GetCount()>0 then
		if Duel.SendtoDeck(g1,nil,2,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(cm.ctfilter,tp,LOCATION_ONFIELD,0,1,nil) then
			local g=Duel.SelectMatchingCard(tp,cm.ctfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
			local tc=g:GetFirst()
			tc:AddCounter(0xf12,1)
			if tc:GetCounter(0xf12)==1 or tc:GetCounter(0xf12)==2 or tc:GetCounter(0xf12)==3 or tc:GetCounter(0xf12)==4 then
				Duel.RaiseEvent(tc,EVENT_CUSTOM+40020225,e,0,tp,tp,0)
			end
			if tc:GetCounter(0xf12)==3 or tc:GetCounter(0xf12)==4 or tc:GetCounter(0xf12)==5 then
				Duel.RaiseEvent(tc,EVENT_CUSTOM+40020235,e,0,tp,tp,0)
			end
			if tc:GetCounter(0xf12)==4 or tc:GetCounter(0xf12)==6 then
				Duel.RaiseEvent(tc,EVENT_CUSTOM+40020325,e,0,tp,tp,0)
			end
		end
	end
end