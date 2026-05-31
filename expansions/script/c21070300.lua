--量产型治安官魔法少女
function c21070300.initial_effect(c)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,21070300)
	e1:SetTarget(c21070300.sptg)
	e1:SetCondition(c21070300.spcon)
	e1:SetOperation(c21070300.extraop)
	e1:SetDescription(aux.Stringid(21070300,0))
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetCondition(c21070300.atcon)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c21070300.atcon2)
	e3:SetCode(EFFECT_SET_DEFENSE)
	e3:SetValue(math.ceil(c:GetAttack()*2))
	c:RegisterEffect(e3)
	local e4=e3:Clone(c)
	e3:SetCode(EFFECT_SET_ATTACK)
	e4:SetValue(math.ceil(c:GetAttack()*2))
	c:RegisterEffect(e4)
end
function c21070300.atfilter(c)
	return c:IsFaceup() and c:IsCode(21070300)
end
function c21070300.atcon(e)
	return not Duel.IsExistingMatchingCard(c21070300.atfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,e:GetHandler())
end
function c21070300.atcon2(e)
	return Duel.IsExistingMatchingCard(c21070300.atfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,2,e:GetHandler())
end
function c21070300.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()~=tp
end
function c21070300.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c21070300.rbfilter(c,e,tp)
	return c:IsCode(21070300) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c21070300.extraop(e,tp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c21070300.rbfilter),tp,LOCATION_DECK,0,nil,e,tp)
	local c=e:GetHandler()
	if c:IsRelateToChain() then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.SelectYesNo(tp,aux.Stringid(21070300,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		local sc=sg:GetFirst()
		if Duel.SpecialSummon(sg,0,tp,tp,false,aux.DrytronSpSummonType(sc),POS_FACEUP)~=0 and aux.DrytronSpSummonType(sc) then
			sc:CompleteProcedure()
		end
	end
	local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c21070300.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
end
function c21070300.splimit(e,c)
	return not (c:IsRace(RACE_FIEND) or c:IsRace(RACE_SPELLCASTER))
end
