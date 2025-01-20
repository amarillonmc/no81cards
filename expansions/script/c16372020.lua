--花信物语 夏之契约
function c16372020.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,16372020)
	e1:SetCost(c16372020.costoath)
	e1:SetTarget(c16372020.target)
	e1:SetOperation(c16372020.operation)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,16372020)
	e2:SetCost(c16372020.bfgcost)
	e2:SetTarget(c16372020.sptg)
	e2:SetOperation(c16372020.spop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(16372020,ACTIVITY_SPSUMMON,c16372020.counterfilter)
end
function c16372020.counterfilter(c)
	return c:IsRace(RACE_PLANT)
end
function c16372020.costoath(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(16372020,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c16372020.splimitoath)
	Duel.RegisterEffect(e1,tp)
end
function c16372020.splimitoath(e,c)
	return not c:IsRace(RACE_PLANT)
end
function c16372020.bfgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.GetCustomActivityCount(16372020,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c16372020.splimitoath)
	Duel.RegisterEffect(e1,tp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c16372020.filter(c)
	return c:IsSetCard(0xdc1) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c16372020.spfilter(c,e,tp,code1,code2)
	return not c:IsCode(code1,code2) and c:IsSetCard(0xdc1) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c16372020.gcheck(g,e,tp)
	if #g~=2 then return false end
	local a=g:GetFirst()
	local d=g:GetNext()
	return Duel.IsExistingMatchingCard(c16372020.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,a:GetCode(),d:GetCode())
end
function c16372020.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local g=Duel.GetMatchingGroup(c16372020.filter,tp,LOCATION_DECK,0,nil)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) and not e:GetHandler():IsLocation(LOCATION_SZONE) then ft=ft-1 end
	if chk==0 then return ft>1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and g:CheckSubGroup(c16372020.gcheck,2,2,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c16372020.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local g=Duel.GetMatchingGroup(c16372020.filter,tp,LOCATION_DECK,0,nil)
	if ft>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local sg=g:SelectSubGroup(tp,c16372020.gcheck,false,2,2,e,tp)
		if not sg then return end
		local ac=sg:GetFirst()
		local bc=sg:GetNext()
		if Duel.MoveToField(ac,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			and Duel.MoveToField(bc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
			local e1=Effect.CreateEffect(c)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			ac:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetCode(EFFECT_CHANGE_TYPE)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e2:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			bc:RegisterEffect(e2)
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
			local rg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c16372020.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp,ac:GetCode(),bc:GetCode())
			if #rg==0 then return end
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tc=rg:Select(tp,1,1,nil):GetFirst()
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c16372020.spfilter2(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0xdc1) and c:GetOriginalType()&TYPE_MONSTER>0 and c:GetSequence()<5
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c16372020.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c16372020.spfilter2,tp,LOCATION_SZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_SZONE)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function c16372020.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c16372020.spfilter2,tp,LOCATION_SZONE,0,1,math.min(ft,2),nil,e,tp)
	if #g==0 then return end
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	local atk=Duel.GetOperatedGroup():GetSum(Card.GetBaseAttack)
	Duel.Recover(tp,atk,REASON_EFFECT)
end