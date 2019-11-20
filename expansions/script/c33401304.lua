--D.A.L 空间震
function c33401304.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33401304,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,33401304+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c33401304.target)
	e1:SetOperation(c33401304.activate)
	c:RegisterEffect(e1)
	 --spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33401304,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,33401304+10000)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c33401304.cost)
	e2:SetTarget(c33401304.sptg)
	e2:SetOperation(c33401304.spop)
	c:RegisterEffect(e2)
end
function c33401304.chkfilter1(c,e,tp)
	return (not c:IsSetCard(0xc342)) and  c:IsSetCard(0x341) and c:IsType(TYPE_MONSTER) and 
		not c:IsHasEffect(EFFECT_REVIVE_LIMIT) and Duel.IsPlayerCanSpecialSummon(tp,0,POS_FACEUP,tp,c)
		and Duel.IsExistingMatchingCard(c33401304.chkfilter2,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function c33401304.chkfilter2(c,e,tp,cd)
	return (not c:IsSetCard(0xc342)) and c:IsSetCard(0x341) and c:IsType(TYPE_MONSTER) and not c:IsCode(cd)
		and not c:IsHasEffect(EFFECT_REVIVE_LIMIT) and Duel.IsPlayerCanSpecialSummon(tp,0,POS_FACEUP,1-tp,c)
end
function c33401304.filter1(c,e,tp)
	return (not c:IsSetCard(0xc342)) and c:IsSetCard(0x341) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c33401304.filter2,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function c33401304.filter2(c,e,tp,cd)
	return (not c:IsSetCard(0xc342)) and  c:IsSetCard(0x341) and c:IsType(TYPE_MONSTER) and not c:IsCode(cd)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK,1-tp)
end
function c33401304.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)			 
		and Duel.IsExistingMatchingCard(c33401304.chkfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
	if g then Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c33401304.activate(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
	if dg then   Duel.Destroy(dg,REASON_EFFECT) end
	local sg=Duel.GetMatchingGroup(c33401304.filter1,tp,LOCATION_DECK,0,nil,e,tp)
	if sg:GetCount()>0 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(33401304,2))
		local g1=sg:Select(tp,1,1,nil)
		local tc1=g1:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(33401304,3))
		local g2=Duel.SelectMatchingCard(tp,c33401304.filter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc1:GetCode())
		local tc2=g2:GetFirst()
		Duel.SpecialSummonStep(tc1,0,tp,tp,false,false,POS_FACEUP_ATTACK)
		Duel.SpecialSummonStep(tc2,0,tp,1-tp,false,false,POS_FACEUP_ATTACK) 
		Duel.SpecialSummonComplete()		
	end 
	local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetTargetRange(1,0)
		e3:SetTarget(c33401304.splimit)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
end
function c33401304.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x341)
end

function c33401304.cfilter(c,e,tp)
	return c:IsSetCard(0x341) and c:IsAbleToRemoveAsCost()
end
function c33401304.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c33401304.cfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c33401304.cfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp)
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c33401304.spfilter(c,e,tp)
	return c:IsSetCard(0x341) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33401304.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_DECK) and c33401304.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c33401304.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c33401304.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c33401304.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then Duel.SpecialSummon(tc,0,tp,1-tp,false,false,POS_FACEUP) end   
end
