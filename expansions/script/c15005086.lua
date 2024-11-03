local m=15005086
local cm=_G["c"..m]
cm.name="方舟·三终渊之针"
function cm.initial_effect(c)
	--spsummon self
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.rmcon)
	e1:SetCost(cm.rmcost)
	e1:SetTarget(cm.rmtg)
	e1:SetOperation(cm.rmop)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_REMOVED)
	e4:SetCountLimit(1,m+1)
	e4:SetHintTiming(0,TIMING_CHAIN_END)
	e4:SetCondition(cm.spcon)
	e4:SetTarget(cm.sptg)
	e4:SetOperation(cm.spop)
	c:RegisterEffect(e4)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetCode(EVENT_REMOVE)
	e3:SetOperation(cm.regop)
	c:RegisterEffect(e3)
end
function cm.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function cm.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,3)
	if chk==0 then return g:FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==3 end
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove(tp,POS_FACEDOWN) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
function cm.setfilter(c,ft)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0xcf3e)
		and c:IsSSetable(true) and (c:IsType(TYPE_FIELD) or ft>0) and c:IsFacedown()
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if c:IsRelateToEffect(e) and Duel.Remove(c,POS_FACEDOWN,REASON_EFFECT) and Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_REMOVED,0,1,nil,ft) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local tc=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_REMOVED,0,1,1,nil,ft):GetFirst()
		if tc and Duel.SSet(tp,tc)>0 then
			if tc:IsType(TYPE_QUICKPLAY) then
				local e1=Effect.CreateEffect(c)
				e1:SetDescription(aux.Stringid(m,2))
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
			end
			if tc:IsType(TYPE_TRAP) then
				local e1=Effect.CreateEffect(c)
				e1:SetDescription(aux.Stringid(m,2))
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
			end
		end
	end
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=c:GetControler()
	local rc=re:GetHandler()
	if c:IsFacedown() and c:IsReason(REASON_COST) and re and re:IsActivated() and (rc:IsSetCard(0xcf3e) or (rc:IsAttribute(ATTRIBUTE_DARK) and re:IsActiveType(TYPE_MONSTER))) then
		local id=c:GetFieldID()
		Duel.RegisterFlagEffect(p,15005086,RESET_CHAIN,0,1,id)
	end
	if c:IsFacedown() then
		local id=c:GetFieldID()
		Duel.RegisterFlagEffect(p,15005087,RESET_PHASE+PHASE_END,0,1,id)
	end
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=c:GetControler()
	local id=c:GetFieldID()
	local b1=false
	local b2=false
	if Duel.GetFlagEffect(p,15005086)~=0 then
		for _,i in ipairs{Duel.GetFlagEffectLabel(p,15005086)} do
			if i==id then b1=true end
		end
	end
	if Duel.GetFlagEffect(p,15005087)~=0 then
		for _,i in ipairs{Duel.GetFlagEffectLabel(p,15005087)} do
			if i==id then b2=true end
		end
	end
	return c:IsFacedown() and (b1 or (Duel.IsPlayerAffectedByEffect(p,15005084) and b2))
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummon(tp,0,POS_FACEUP,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end