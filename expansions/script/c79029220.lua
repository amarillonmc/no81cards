--黑钢国际·行动-代号·灰烬
function c79029220.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,79029220)
	e1:SetCost(c79029220.cost)
	e1:SetTarget(c79029220.target)
	e1:SetOperation(c79029220.activate)
	c:RegisterEffect(e1)   
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCountLimit(1,09029220)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCost(c79029220.acost)
	e2:SetTarget(c79029220.atarget)
	e2:SetOperation(c79029220.aactivate)
	c:RegisterEffect(e2)   
end
function c79029220.fil(c)
	return c:IsSetCard(0x1904) and c:IsAbleToGraveAsCost() and c:IsType(TYPE_TRAP)
end
function c79029220.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,3000) and Duel.IsExistingMatchingCard(c79029220.fil,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_REMOVED,0,2,nil) end
	Duel.PayLPCost(tp,3000)
	local g=Duel.SelectMatchingCard(tp,c79029220.fil,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_REMOVED,0,2,2,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c79029220.sfil(c,e,tp)
	return c:IsSetCard(0x1904) and c:IsLevel(9)
end
function c79029220.fcheck(c,g)
	return g:IsExists(Card.IsOriginalCodeRule,1,c,c:GetOriginalCodeRule())
end
function c79029220.fselect(g)
	return not g:IsExists(c79029220.fcheck,1,nil,g)
end
function c79029220.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c79029220.sfil,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_REMOVED,0,2,2,nil,e,tp)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetLocationCount(tp,LOCATION_MZONE)>=2 and g:CheckSubGroup(c79029220.fselect,2,2) end
	local sg=g:SelectSubGroup(tp,c79029220.fselect,false,2,2,e,tp)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,2,tp,0)
end
function c79029220.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
end
function c79029220.acost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c79029220.atfil(c,e,tp)
	return c:IsSetCard(0x1904) 
end
function c79029220.satfil(c,e,tp)
	return c:IsSetCard(0x1904) and c:IsType(TYPE_TRAP)
end
function c79029220.atarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029220.atfil,tp,LOCATION_MZONE,0,1,nil,e,tp) and  Duel.IsExistingMatchingCard(c79029220.satfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler(),e,tp) end
	local g=Duel.SelectMatchingCard(tp,c79029220.atfil,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
end
function c79029220.aactivate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroupCount(c79029220.satfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(g*1000)
	tc:RegisterEffect(e1)
end








