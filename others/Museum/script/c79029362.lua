--黑钢国际·行动-任务接收
function c79029362.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,79029362)
	e1:SetTarget(c79029362.actg)
	e1:SetOperation(c79029362.acop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,09029362)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c79029362.bgtg)
	e2:SetOperation(c79029362.bgop)
	c:RegisterEffect(e2)   
end
function c79029362.ssfil(c,e)
	return c:IsSSetable(true) and c:IsSetCard(0x1904) and c:IsType(TYPE_TRAP) and not c:IsCode(79029362)
end
function c79029362.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(c79029362.ssfil,tp,LOCATION_DECK,0,1,nil,e) end
end
function c79029362.acop(e,tp,eg,ep,ev,re,r,rp)
	local s1=Duel.GetMatchingGroupCount(c79029362.ssfil,tp,LOCATION_DECK,0,nil)
	local s2=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if s1<s2 then s1,s2=s2,s1 end
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND,0,1,s2,nil)
	local x=Duel.SendtoGrave(g,REASON_EFFECT)
	if x>0 then
	sg=Duel.SelectMatchingCard(tp,c79029362.ssfil,tp,LOCATION_DECK,0,x,x,nil,e)
	end
	if Duel.SSet(tp,sg)~=0 then
	local tc=sg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	tc=sg:GetNext()
	end
end
end
function c79029362.xxfil(c)
	 return c:IsType(TYPE_TRAP) and c:IsSetCard(0x1904)
end
function c79029362.bgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	 local c=e:GetHandler()
	 local x=Duel.GetMatchingGroupCount(c79029362.xxfil,tp,LOCATION_GRAVE,0,c)
	 if chk==0 then return x>0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=x end
end
function c79029362.ccfil(c,e,tp)
	 return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x1904)
end
function c79029362.bgop(e,tp,eg,ep,ev,re,r,rp)
	 local x=Duel.GetMatchingGroupCount(c79029362.xxfil,tp,LOCATION_GRAVE,0,nil)
	 local g=Duel.GetDecktopGroup(tp,x) 
	 Duel.ConfirmDecktop(tp,x)
	 if g:GetCount()>0 then
	 Duel.DisableShuffleCheck()
	 if g:IsExists(c79029362.ccfil,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(79029362,0)) then
	 sg=g:FilterSelect(tp,c79029362.ccfil,1,1,nil,e,tp)
	 Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
	 end
end
end








