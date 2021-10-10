--生于黑夜
function c82568013.initial_effect(c)
	--HAnd Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_DRAW)
	e1:SetCondition(c82568013.regcon)
	e1:SetOperation(c82568013.regop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c82568013.handcon)
	c:RegisterEffect(e2)
	--Activate1
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(82568013,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,82568013+EFFECT_COUNT_CODE_DUEL)
	e3:SetTarget(c82568013.sptg)
	e3:SetOperation(c82568013.spop)
	c:RegisterEffect(e3)
	--Activate2
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(82568013,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,82568013+EFFECT_COUNT_CODE_DUEL)
	e4:SetTarget(c82568013.sptg2)
	e4:SetOperation(c82568013.spop2)
	c:RegisterEffect(e4)
	--draw
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(82568013,3))
	e5:SetCategory(CATEGORY_COUNTER)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCost(c82568013.drcost)
	e5:SetOperation(c82568013.drop)
	c:RegisterEffect(e5) 
end
function c82568013.regcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetFlagEffect(tp,82568013)==0  and Duel.GetLP(e:GetHandlerPlayer())<=4000 and Duel.GetCurrentPhase()==PHASE_DRAW and c:IsReason(REASON_RULE)
end
function c82568013.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectYesNo(tp,aux.Stringid(82568013,0)) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_MAIN1)
		c:RegisterEffect(e1)
		c:RegisterFlagEffect(82568013,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_MAIN1,EFFECT_FLAG_CLIENT_HINT,1,0,66)
	end
end
function c82568013.handcon(e)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and not Duel.CheckPhaseActivity() and e:GetHandler():GetFlagEffect(82568013)~=0 
end
function c82568013.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,true)
  and c:IsRace(RACE_FIEND) and c:IsSetCard(0x825) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and not c:IsFaceup()
end
function c82568013.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c82568013.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_DECK)
end
function c82568013.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c82568013.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if Duel.GetLocationCountFromEx(tp,tp,nil,tc)<=0 then return end
	local atk=tc:GetAttack()
	local def=tc:GetDefense()
	local val=math.max(atk,def)
	if Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)~=0
	then
	Duel.BreakEffect()
	if  Duel.GetLP(e:GetHandlerPlayer())>=4000 then
	Duel.Damage(tp,val,REASON_EFFECT)
   end
end
end
function c82568013.spfilter2(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,true) and 
		   c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL)  
				  and c:IsRace(RACE_FIEND) and c:IsSetCard(0x825) and (c:IsLevelBelow(9) or c:IsRankBelow(6))
end
function c82568013.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c82568013.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_DECK)
end
function c82568013.spop2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c82568013.spfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0  then return end
	if Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)~=0 then
	local atk=tc:GetAttack()
	local def=tc:GetDefense()
	local val=math.max(atk,def)
	tc:CompleteProcedure() 
	Duel.BreakEffect()
	if  Duel.GetLP(e:GetHandlerPlayer())>=4000  then
	Duel.Damage(tp,val,REASON_EFFECT)
end
end
end
function c82568013.costfilter(c,e,tp,lv)
	return  c:IsRace(RACE_FIEND) and c:IsAbleToRemoveAsCost()
end
function c82568013.ctfilter(c,e,tp,lv)
	return  c:IsRace(RACE_FIEND) and c:IsFaceup()
end
function c82568013.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c82568013.costfilter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(c82568013.ctfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c82568013.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	g:AddCard(c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c82568013.drop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c82568013.ctfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	  while tc do   
	  tc:AddCounter(0x5825,2)
	 tc=g:GetNext()
   end
end