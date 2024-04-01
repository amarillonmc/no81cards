--奇 点 哥 斯 拉
local m=43990066
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,43990067)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c43990066.spcon)
	e1:SetOperation(c43990066.spop)
	c:RegisterEffect(e1)

	
end
function c43990066.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c43990066.tcgfilter(c)
	return c:IsPreviousPosition(POS_FACEUP)
end
function c43990066.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lv=c:GetLevel()
	if lv and lv>12 then
		local dg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
		if Duel.Destroy(dg,REASON_EFFECT)~=0 then
		local tg=Duel.GetOperatedGroup()
		local tcg=tg:Filter(c43990066.tcgfilter,nil)
		local tc=tcg:GetFirst()
		while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e1:SetCondition(c43990066.discon1)
		e1:SetTarget(c43990066.distg)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetCondition(c43990066.discon2)
		e2:SetOperation(c43990066.disop)
		e2:SetLabelObject(tc)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		tc=tcg:GetNext()
		end
		end
	end
	if lv and lv>24 then
		local rg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,nil,tp,POS_FACEDOWN)
		if Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)~=0 then
		local trg=Duel.GetOperatedGroup()
		if #trg>0 then
		local trcg=trg:Filter(c43990066.tcgfilter,nil)
		local trc=trcg:GetFirst()
		while trc do
		local e11=Effect.CreateEffect(c)
		e11:SetType(EFFECT_TYPE_FIELD)
		e11:SetCode(EFFECT_DISABLE)
		e11:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e11:SetCondition(c43990066.discon1)
		e11:SetTarget(c43990066.distg)
		e11:SetLabelObject(trc)
		e11:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e11,tp)
		local e12=Effect.CreateEffect(c)
		e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e12:SetCode(EVENT_CHAIN_SOLVING)
		e12:SetCondition(c43990066.discon2)
		e12:SetOperation(c43990066.disop)
		e12:SetLabelObject(trc)
		e12:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e12,tp)
		trc=trcg:GetNext()
		end
		end
		end
	local e10=Effect.CreateEffect(e:GetHandler())
	e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e10:SetCode(EVENT_PHASE+PHASE_END)
	e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e10:SetCountLimit(1)
	e10:SetOperation(c43990066.bdop)
	e10:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e10,tp)
	end
	if lv and lv>36 then
	--SpecialSummon
	local e21=Effect.CreateEffect(c)
	e21:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e21:SetCode(EVENT_CUSTOM+43990066)
	e21:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE)
	e21:SetReset(RESET_PHASE+PHASE_END)
	e21:SetCondition(c43990066.sptcon)
	e21:SetOperation(c43990066.sptop)
	Duel.RegisterEffect(e21,tp)
	local e22=Effect.CreateEffect(c)
	e22:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e22:SetCode(EVENT_ADJUST)
	e22:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE)
	e22:SetReset(RESET_PHASE+PHASE_END)
	e22:SetCondition(c43990066.sptcon)
	e22:SetOperation(c43990066.sptop)
	Duel.RegisterEffect(e22,tp)
	end
end
function c43990066.bdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,43990066)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_REMOVED,LOCATION_REMOVED)
	if Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 then
	Duel.Draw(tp,5,REASON_EFFECT)
	Duel.Draw(1-tp,5,REASON_EFFECT)
	end
end
function c43990066.distg(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule()) and (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0)
end
function c43990066.discon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffectLabel(1,43990064)
end
function c43990066.discon2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return Duel.GetFlagEffectLabel(1,43990064) and re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c43990066.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c43990066.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x670b)
end
function c43990066.sptcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	local tp=e:GetHandler():GetControler()
	local ad=Duel.GetMatchingGroupCount(Card.IsFacedown,0,LOCATION_REMOVED,LOCATION_REMOVED,nil)*100
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and not ((ph==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or ph==PHASE_DAMAGE_CAL) and Duel.IsPlayerCanSpecialSummonMonster(tp,43990068,0,TYPES_TOKEN_MONSTER,ad,ad,8,RACE_DINOSAUR,ATTRIBUTE_DARK,POS_FACEUP,tp)
end
function c43990066.sptop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ad=Duel.GetMatchingGroupCount(Card.IsFacedown,0,LOCATION_REMOVED,LOCATION_REMOVED,nil)*100
		if Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,43990068,0,TYPES_TOKEN_MONSTER,ad,ad,8,RACE_DINOSAUR,ATTRIBUTE_DARK,POS_FACEUP,tp) then
			local token=Duel.CreateToken(tp,43990068)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_BASE_ATTACK)
			e1:SetValue(ad)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			token:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_SET_BASE_DEFENSE)
			e2:SetValue(ad)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			token:RegisterEffect(e2)
			Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	   end
		Duel.RaiseEvent(c,EVENT_CUSTOM+22348280,e,0,0,0,0)
end