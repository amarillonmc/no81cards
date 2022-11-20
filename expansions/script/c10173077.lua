--混乱纷争·激化
function c10173077.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCost(c10173077.cost)
	e1:SetTarget(c10173077.target)
	e1:SetOperation(c10173077.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2) 
end
function c10173077.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local bool=e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND)
	if chk==0 then return not bool or Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	if bool then
		Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	end
end 
function c10173077.cfilter(c,tp)
	return Duel.IsPlayerCanSendtoHand(tp,c)
end
function c10173077.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(1-tp,1)
	if chk==0 then return #g==1 and g:IsExists(c10173077.cfilter,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,1-tp,LOCATION_DECK)
end
function c10173077.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetDecktopGroup(1-tp,1)
	if #g~=1 or Duel.SendtoHand(g,tp,REASON_EFFECT)~=1 then return end
	c10173077.pubfun(c,g)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c10173077.drcon1)
	e1:SetOperation(c10173077.drop1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--sp_summon effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c10173077.regcon)
	e2:SetOperation(c10173077.regop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetCondition(c10173077.drcon2)
	e3:SetOperation(c10173077.drop2)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
	local e4=e1:Clone()
	e4:SetCode(EVENT_TO_HAND)
	Duel.RegisterEffect(e4,tp)
	local e5=e2:Clone()
	e5:SetCode(EVENT_TO_HAND)
	Duel.RegisterEffect(e5,tp)
end
function c10173077.pubfun(c,g)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function c10173077.filter(c,sp)
	return ((c:GetSummonPlayer()==sp and c:IsLocation(LOCATION_MZONE)) or (c:IsLocation(LOCATION_HAND) and c:GetReasonPlayer()==sp)) and c:IsPreviousLocation(LOCATION_DECK+LOCATION_EXTRA) and c:GetPreviousControler()==sp
end
function c10173077.drcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10173077.filter,1,nil,1-tp)
		and (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
end
function c10173077.drop1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(1-tp,1)	
	if #g>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		c10173077.pubfun(e:GetHandler(),g)
	end
end
function c10173077.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10173077.filter,1,nil,1-tp)
		and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
function c10173077.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,10173077,RESET_CHAIN,0,1)
end
function c10173077.drcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,10173077)>0
end
function c10173077.drop2(e,tp,eg,ep,ev,re,r,rp)
	local n=Duel.GetFlagEffect(tp,10173077)
	Duel.ResetFlagEffect(tp,10173077)
	local g=Duel.GetDecktopGroup(1-tp,n)	
	if #g>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		c10173077.pubfun(e:GetHandler(),g)
	end
end
