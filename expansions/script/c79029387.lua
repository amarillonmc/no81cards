--B003-医疗干员·凯尔希
function c79029387.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c79029387.splimit)
	c:RegisterEffect(e2)
	--SpecialSummon 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c79029387.psptg)
	e1:SetOperation(c79029387.pspop)
	c:RegisterEffect(e1) 
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCondition(c79029387.descon)
	e3:SetTarget(c79029387.destg)
	e3:SetOperation(c79029387.desop)
	c:RegisterEffect(e3) 
	--Summon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_HAND)
	e4:SetCountLimit(1,79029387)  
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e4:SetCost(c79029387.smcost)
	e4:SetTarget(c79029387.smtg)
	e4:SetOperation(c79029387.smop)
	c:RegisterEffect(e4)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DISABLE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e5:SetRange(LOCATION_EXTRA)
	e5:SetCountLimit(1,09029387)  
	e5:SetCondition(c79029387.condition)
	e5:SetCost(c79029387.cost)
	e5:SetTarget(c79029387.target)
	e5:SetOperation(c79029387.operation)
	c:RegisterEffect(e5)	 

end
function c79029387.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0xa900) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c79029387.ppfil(c,e,tp,lsc,rsc)
	local lv=c:GetLevel()
	return c:IsSetCard(0xa900) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,false,false) and lv>lsc and lv<rsc 
end
function c79029387.psptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.GetFieldGroupCount(tp,LOCATION_PZONE,0)~=2 then return end
	local lsc=Duel.GetFieldCard(tp,LOCATION_PZONE,0):GetLeftScale()
	local rsc=Duel.GetFieldCard(tp,LOCATION_PZONE,1):GetRightScale()
	if lsc>rsc then lsc,rsc=rsc,lsc end
	if chk==0 then return Duel.IsExistingMatchingCard(c79029387.ppfil,tp,LOCATION_DECK,0,1,nil,e,tp,lsc,rsc) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c79029387.pspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFieldGroupCount(tp,LOCATION_PZONE,0)~=2 then return end
	local lsc=Duel.GetFieldCard(tp,LOCATION_PZONE,0):GetLeftScale()
	local rsc=Duel.GetFieldCard(tp,LOCATION_PZONE,1):GetRightScale()
	if lsc>rsc then lsc,rsc=rsc,lsc end
	local g=Duel.GetMatchingGroup(c79029387.ppfil,tp,LOCATION_DECK,0,nil,e,tp,lsc,rsc)
	if g:GetCount()<=0 or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local sg=g:Select(tp,1,1,nil)
	Duel.SpecialSummon(sg,SUMMON_TYPE_PENDULUM,tp,tp,false,false,POS_FACEUP)
end
function c79029387.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function c79029387.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL)
end
function c79029387.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.GetFieldGroup(1-tp,LOCATION_MZONE,0):Filter(Card.IsPosition,nil,POS_ATTACK):GetCount()>0
	local b2=Duel.GetMatchingGroupCount(Card.IsType,tp,0,LOCATION_ONFIELD,c,TYPE_SPELL+TYPE_TRAP)>0
	if chk==0 then return b1 or b2 end
	local s=0
	if b1 and not b2 then
		s=Duel.SelectOption(tp,aux.Stringid(79029387,0))
	end
	if not b1 and b2 then
		s=Duel.SelectOption(tp,aux.Stringid(79029387,1))+1
	end
	if b1 and b2 then
		s=Duel.SelectOption(tp,aux.Stringid(79029387,0),aux.Stringid(79029387,1))
	end
	e:SetLabel(s)
	local g=nil
	if s==0 then
		g=Duel.GetMatchingGroup(Card.IsPosition,tp,0,LOCATION_MZONE,nil,POS_ATTACK)
	end
	if s==1 then
		g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,c,TYPE_SPELL+TYPE_TRAP)
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c79029387.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=nil
	if e:GetLabel()==0 then
		g=Duel.GetMatchingGroup(Card.IsPosition,tp,0,LOCATION_MZONE,nil,POS_ATTACK)
	end
	if e:GetLabel()==1 then
		g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,aux.ExceptThisCard(e),TYPE_SPELL+TYPE_TRAP)
	end
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c79029387.ctfil(c)
	return c:IsSetCard(0xa900) and c:IsAbleToHandAsCost() 
end
function c79029387.smcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029387.ctfil,tp,LOCATION_PZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c79029387.ctfil,tp,LOCATION_PZONE,0,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_COST)
end
function c79029387.smtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsSummonable(true,nil) or c:IsMSetable(true,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,c,1,0,0)
end
function c79029387.smop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsSummonable(true,nil) and (not c:IsMSetable(true,nil) or Duel.SelectPosition(tp,c,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) then
	Duel.Summon(tp,c,true,nil)
	else 
	Duel.MSet(tp,c,true,nil) 
	end
end
function c79029387.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()~=tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c79029387.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsFaceup() and e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),tp,2,REASON_COST)
end
function c79029387.filter(c)
	return c:IsFaceup() and not c:IsDisabled() 
end
function c79029387.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil)
	local b2=Duel.IsExistingMatchingCard(c79029387.filter,tp,0,LOCATION_ONFIELD,1,nil)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
	op=Duel.SelectOption(tp,aux.Stringid(79029387,2),aux.Stringid(79029387,3))
	elseif b1 then
	op=Duel.SelectOption(tp,aux.Stringid(79029387,2))
	else
	op=Duel.SelectOption(tp,aux.Stringid(79029387,3))
	end
	e:SetLabel(op)
	if op==0 then
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
	else
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,0,0)
	end
end
function c79029387.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=e:GetLabel()
	if op==0 then
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,1,nil) 
	if g:GetCount()<=0 then return end  
	local dg=g:Select(tp,1,1,nil)
	Duel.Destroy(dg,REASON_EFFECT)
	else
	local g=Duel.GetMatchingGroup(c79029387.filter,tp,0,LOCATION_ONFIELD,1,nil)
	if g:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	Duel.NegateRelatedChain(tc,RESET_TURN_SET)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetValue(RESET_TURN_SET)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e2)
	end
end
















