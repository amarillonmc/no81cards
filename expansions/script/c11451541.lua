--结界守护者 辛歇耳
local cm,m=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,11451544)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetCondition(cm.adcon)
	e1:SetCost(cm.adcost)
	e1:SetTarget(cm.adtg)
	e1:SetOperation(cm.adop)
	c:RegisterEffect(e1)
	local e4=e1:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--barrier
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(cm.sccon)
	e2:SetCost(cm.sccost)
	e2:SetTarget(cm.sctg)
	e2:SetOperation(cm.scop)
	c:RegisterEffect(e2)
	if not PNFL_ETARGET_CHECK then
		PNFL_ETARGET_CHECK=true
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_BECOME_TARGET)
		ge3:SetOperation(cm.checkop3)
		Duel.RegisterEffect(ge3,0)
		local ge6=Effect.CreateEffect(c)
		ge6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge6:SetCode(EVENT_ADJUST)
		ge6:SetOperation(cm.checkop6)
		Duel.RegisterEffect(ge6,0)
	end
end
function cm.checkop3(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg
	if #tg>0 then
		for tc in aux.Next(eg) do
			local prop=EFFECT_FLAG_SET_AVAILABLE
			if PNFL_ETARGET_HINT or PNFL_DEBUG then prop=prop|EFFECT_FLAG_CLIENT_HINT end
			tc:RegisterFlagEffect(11451541,RESET_EVENT+0x1fc0000,prop,1,0,aux.Stringid(11451541,5))
		end
	end
end
function cm.checkop6(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(cm.ctgfilter,0,0x3c,0x3c,nil)
	if #tg>0 then
		for tc in aux.Next(tg) do
			local prop=EFFECT_FLAG_SET_AVAILABLE
			if PNFL_ETARGET_HINT or PNFL_DEBUG then prop=prop|EFFECT_FLAG_CLIENT_HINT end
			tc:RegisterFlagEffect(11451541,RESET_EVENT+0x1fc0000,prop,1,0,aux.Stringid(11451541,5))
		end
	end
end
function cm.ctgfilter(c)
	return c:GetOwnerTargetCount()>0 and c:GetFlagEffect(11451541)==0
end
function cm.filter(c,tp)
	return c:IsControler(tp)
end
function cm.adcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter,1,nil,1-tp)
end
function cm.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(m,4))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e:GetHandler():RegisterEffect(e1)
end
function cm.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.actfilter(c,tp)
	return c:IsCode(11451544) and c:GetActivateEffect() and c:GetActivateEffect():IsActivatable(tp,true,true) and (c:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
end
function cm.adop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if #sg>0 and Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)>0 and Duel.IsExistingMatchingCard(cm.actfilter,tp,LOCATION_HAND,0,1,nil,tp) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=Duel.SelectMatchingCard(tp,cm.actfilter,tp,LOCATION_HAND,0,1,1,nil,tp):GetFirst()
		if tc:IsType(TYPE_FIELD) then
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			local te=tc:GetActivateEffect()
			te:UseCountLimit(tp,1,true)
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		else
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local te=tc:GetActivateEffect()
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		end
	end
end
function cm.sccon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function cm.sccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function cm.cfilter(c)
	return c:IsFaceup() and c:GetFlagEffect(11451541)==0
end
function cm.shfilter(c)
	return c:GetFlagEffect(11451541)>0
end
function cm.sctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then
		if not PNFL_ETARGET_HINT then
			PNFL_ETARGET_HINT=true
			local shg=Duel.GetMatchingGroup(cm.shfilter,tp,0x3c,0x3c,nil)
			for tc in aux.Next(shg) do
				tc:RegisterFlagEffect(11451541,RESET_EVENT+0x1fc0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(11451541,5))
			end
		end
		return Duel.IsExistingTarget(cm.cfilter,tp,0,LOCATION_MZONE,2,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.cfilter,tp,0,LOCATION_MZONE,2,2,nil)
end
function cm.tfilter(c,e)
	return c:IsRelateToEffect(e) and c:IsFaceup()
end
function cm.scop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(cm.tfilter,nil,e)
	if #g<2 then return end
	local ac=g:GetFirst()
	local bc=g:GetNext()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetCondition(cm.con)
	Duel.RegisterEffect(e1,tp)
	local eid=e1:GetFieldID()
	e1:SetLabel(eid)
	if ac:IsAttribute(bc:GetAttribute()) and (ac:GetAttribute()==bc:GetAttribute() or Duel.SelectOption(tp,aux.Stringid(m,2),aux.Stringid(m,3))==0) then
		ac:RegisterFlagEffect(m+1,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,eid,aux.Stringid(m,2))
		bc:RegisterFlagEffect(m+1,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,eid,aux.Stringid(m,2))
		e1:SetTarget(cm.sumlimit)
	else
		ac:RegisterFlagEffect(m+1,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,eid,aux.Stringid(m,3))
		bc:RegisterFlagEffect(m+1,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,eid,aux.Stringid(m,3))
		e1:SetTarget(cm.sumlimit2)
	end
end
function cm.cfilter2(c,eid)
	return c:IsFaceup() and c:GetFlagEffect(m+1)~=0 and c:GetFlagEffectLabel(m+1)==eid
end
function cm.con(e)
	return Duel.IsExistingMatchingCard(cm.cfilter2,0,LOCATION_MZONE,LOCATION_MZONE,1,nil,e:GetLabel())
end
function cm.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	local g=Duel.GetMatchingGroup(cm.cfilter2,0,LOCATION_MZONE,LOCATION_MZONE,nil,e:GetLabel())
	local ac=g:GetFirst()
	local bc=g:GetNext()
	return not (c:IsAttribute(ac:GetAttribute()) and (not bc or c:IsAttribute(bc:GetAttribute())))
end
function cm.sumlimit2(e,c,sump,sumtype,sumpos,targetp)
	local g=Duel.GetMatchingGroup(cm.cfilter2,0,LOCATION_MZONE,LOCATION_MZONE,nil,e:GetLabel())
	local ac=g:GetFirst()
	local bc=g:GetNext()
	return not (c:GetAttribute()~=ac:GetAttribute() and (not bc or c:GetAttribute()~=bc:GetAttribute()))
end