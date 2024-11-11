local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,s.mfilter,aux.FilterBoolFunction(Card.IsFusionSetCard,0xc),2,127,false)
	aux.AddContactFusionProcedure(c,s.cfilter,LOCATION_MZONE,LOCATION_MZONE,Duel.Release,REASON_SPSUMMON+REASON_MATERIAL)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetCondition(s.adcon)
	e1:SetTarget(s.adtg)
	e1:SetValue(0)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_DISABLE_FIELD)
	e3:SetCondition(s.discon)
	e3:SetValue(s.disval)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(s.sptg)
	e4:SetOperation(s.spop)
	c:RegisterEffect(e4)
end
s.counter_add_list={0x100e}
function s.mfilter(c)
	return c:IsCode(51192573) and c:IsSummonType(SUMMON_TYPE_ADVANCE)
end
function s.cfilter(c,fc)
	return c:IsReleasable(REASON_SPSUMMON) and (c:IsControler(fc:GetControler()) or c:IsFaceup())
end
function s.adcon(e)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL and Duel.GetAttackTarget()
end
function s.adtg(e,c)
	local bc=c:GetBattleTarget()
	return bc and c:GetCounter(0x100e)~=0 and bc:IsSetCard(0xc)
end
function s.cfilter2(c)
	return c:GetCounter(0x100e)>0
end
function s.discon(e)
	local ph=Duel.GetCurrentPhase()
	return Duel.IsExistingMatchingCard(s.cfilter2,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil) and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function s.disval(e)
	local tp=e:GetHandlerPlayer()
	local zone=0
	for i=0,4 do
		if Duel.CheckLocation(1-tp,LOCATION_MZONE,i) then zone=zone|(1<<i) end
		if Duel.CheckLocation(1-tp,LOCATION_SZONE,i) then zone=zone|(1<<(i+8)) end
	end
	if tp==0 then zone=zone<<16 end
	return zone
end
function s.spfilter(c,e,tp)
	return c:IsRace(RACE_REPTILE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp) and Duel.IsCanAddCounter(tp,0x100e,1,c)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x100e)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,1-tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2,true)
		Duel.SpecialSummonComplete()
		tc:AddCounter(0x100e,1)
	end
end
