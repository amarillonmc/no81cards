--彩虹小队·部署-全员出击
function c79029469.initial_effect(c)
	--t and s
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,79029469)
	e1:SetTarget(c79029469.tstg)
	e1:SetOperation(c79029469.tsop)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(36970611,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,19029469)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c79029469.sstg)
	e2:SetOperation(c79029469.ssop)
	c:RegisterEffect(e2)  
end
c79029469.named_with_RainbowOperator=true 
function c79029469.tsfil(c)
	return c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and c.named_with_RainbowOperator
end
function c79029469.tstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029469.tsfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c79029469.tsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c79029469.tsfil,tp,LOCATION_DECK,0,nil)
	if g:GetCount()<=0 then return end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	tc:RegisterFlagEffect(79029469,0,0,0)
	Duel.SendtoHand(tc,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
	if tc:IsSpecialSummonable(SUMMON_TYPE_SPECIAL+1) and Duel.SelectYesNo(tp,aux.Stringid(79029469,0)) then 
	Duel.SpecialSummonRule(tp,tc,SUMMON_TYPE_SPECIAL+1)
	end 
end
function c79029469.ssfil(c,e)
	return c:IsSSetable() and c.named_with_RainbowOperator
end
function c79029469.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(c79029469.ssfil,tp,LOCATION_DECK,0,nil,e)>=1 end
end
function c79029469.ssop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.SelectMatchingCard(tp,c79029469.ssfil,tp,LOCATION_DECK,0,1,1,nil,e):GetFirst()
	if Duel.SSet(tp,tc)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
   end
end



