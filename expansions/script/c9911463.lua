--闪蝶幻乐曲-『绽放』
function c9911463.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--attack limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c9911463.tglimit)
	c:RegisterEffect(e2)
	--cannot target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(c9911463.imcon)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3952))
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMING_MAIN_END)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,9911463)
	e4:SetCondition(c9911463.spcon)
	e4:SetTarget(c9911463.sptg)
	e4:SetOperation(c9911463.spop)
	c:RegisterEffect(e4)
end
function c9911463.tglimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
end
function c9911463.cfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and c:IsSummonLocation(LOCATION_EXTRA)
end
function c9911463.imcon(e)
	return Duel.IsExistingMatchingCard(c9911463.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c9911463.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c9911463.spfilter(c,e,tp)
	return c:IsSetCard(0x3952) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9911463.rlfilter(c,e,tp)
	return c:IsReleasableByEffect() and Duel.GetMZoneCount(tp,c)>0
		and Duel.IsExistingMatchingCard(c9911463.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp)
end
function c9911463.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,c9911463.rlfilter,1,REASON_EFFECT,false,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c9911463.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroupEx(tp,c9911463.rlfilter,1,1,REASON_EFFECT,false,nil,e,tp)
	if g:GetCount()==0 then
		g=Duel.SelectReleaseGroupEx(tp,Card.IsReleasableByEffect,1,1,REASON_EFFECT,false,nil)
	end
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		if Duel.Release(g,REASON_EFFECT)~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,c9911463.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
			if sg:GetCount()>0 then
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
