--炎国·辅助干员-月禾·森廻
function c79029308.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,c79029308.tfilter,aux.NonTuner(nil),1)
	c:EnableReviveLimit()   
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c79029308.descon)
	e1:SetOperation(c.op)
	c:RegisterEffect(e1) 
	--synchro summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79029308,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1)
	e2:SetTarget(c79029308.sptg)
	e2:SetOperation(c79029308.spop)
	c:RegisterEffect(e2)   
end
function c79029308.tfilter(c)
	return c:IsSetCard(0xa900)
end
function c79029308.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c79029308.op(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("比起祈祷，还有更重要的事情要做。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029308,1))
	Duel.Hint(HINT_SELECTMSG,tp,HINGMSG_LVRANK)
	local lv=Duel.AnnounceLevel(tp,1,8)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
end
end
function c79029308.smcon(e)
	return e:GetHandler():GetFlagEffect(79029308)==0
end
function c79029308.filter(tc,c,tp)
	if not tc:IsFaceup() or not tc:IsCanBeSynchroMaterial() then return false end
	c:RegisterFlagEffect(79029308,0,0,1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SYNCHRO_MATERIAL)
	tc:RegisterEffect(e1,true)
	local mg=Group.FromCards(c,tc)
	local res=Duel.IsExistingMatchingCard(c79029308.synfilter,tp,LOCATION_EXTRA,0,1,nil,mg)
	c:ResetFlagEffect(79029308)
	e1:Reset()
	return res
end
function c79029308.synfilter(c,mg)
	return c:IsRace(RACE_CYBERSE) and c:IsSynchroSummonable(nil,mg)
end
function c79029308.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c79029308.filter(chkc,e:GetHandler(),tp) end
	if chk==0 then return Duel.IsExistingTarget(c79029308.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e:GetHandler(),tp) end
	Debug.Message("时辰已到，走吧。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029308,2))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c79029308.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e:GetHandler(),tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c79029308.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsFaceup() and c:IsRelateToEffect(e)
		and tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		c:RegisterFlagEffect(79029308,RESET_EVENT+RESETS_STANDARD,0,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SYNCHRO_MATERIAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local mg=Group.FromCards(c,tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c79029308.synfilter,tp,LOCATION_EXTRA,0,1,1,nil,mg)
		local sc=g:GetFirst()
		if sc then
			Duel.SynchroSummon(tp,sc,nil,mg)
		else
			c:ResetFlagEffect(79029308)
			e1:Reset()
		end
	end
end





















