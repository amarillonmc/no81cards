--无形噬体枯竭体
function c49811232.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,49811232)
	e1:SetTarget(c49811232.sttg)
	e1:SetOperation(c49811232.stop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,49811332)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c49811232.sptg)
	e2:SetOperation(c49811232.spop)
	c:RegisterEffect(e2)
end
function c49811232.stfilter(c,tp)
	return ((c:IsType(TYPE_CONTINUOUS) and c:IsSetCard(0xe0) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
		or c:IsCode(23160024)) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c49811232.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c49811232.stfilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c49811232.stop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c49811232.stfilter,tp,LOCATION_DECK,0,1,nil,tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c49811232.stfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()		
	if tc:IsType(TYPE_CONTINUOUS) then 
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	elseif tc:IsType(TYPE_FIELD) then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	end
end
function c49811232.spfilter(c,e,tp)
	local lsc=Duel.GetFieldCard(tp,LOCATION_PZONE,0):GetLeftScale()
	local rsc=Duel.GetFieldCard(tp,LOCATION_PZONE,1):GetRightScale()	
	if lsc>rsc then lsc,rsc=rsc,lsc end
	return c:IsSetCard(0xe0) and c:GetLevel()<rsc and c:GetLevel()>lsc and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c49811232.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.GetFieldCard(tp,LOCATION_PZONE,0)~=nil and Duel.GetFieldCard(tp,LOCATION_PZONE,1)~=nil
		and Duel.IsExistingMatchingCard(c49811232.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c49811232.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c49811232.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)~=0 then
		Duel.ConfirmCards(1-tp,tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e1:SetCondition(c49811232.adcon)
		e1:SetTarget(c49811232.adtg)
		e1:SetValue(c49811232.adval)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE)
		e2:SetValue(c49811232.deval)
		Duel.RegisterEffect(e2,tp)
	end
end
function c49811232.adcon(e)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL
end
function c49811232.adtg(e,c)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return d~=nil and (c==a or c==d)
end
function c49811232.adval(e,c)
	return c:GetAttack()%100
end
function c49811232.deval(e,c)
	return c:GetDefense()%100
end