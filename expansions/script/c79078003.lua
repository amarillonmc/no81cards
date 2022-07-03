--大群之刺 喷溅者
function c79078003.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetCountLimit(1,79078003)
	e1:SetCost(c79078003.thcost)
	e1:SetOperation(c79078003.operation1)
	c:RegisterEffect(e1)
	c79078003.remove_effect=e1

	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCountLimit(1,79078003+1500)
	e2:SetCondition(c79078003.condition)
	e2:SetTarget(c79078003.target)
	e2:SetOperation(c79078003.operation)
	c:RegisterEffect(e2)
	
end
c79078003.named_with_Massacre=true
function c79078003.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemove() and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and Duel.GetFlagEffect(tp,19078003)==0 end  
	Duel.RegisterFlagEffect(tp,19078003,RESET_CHAIN,0,1) 
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function c79078003.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_DECK)
	e1:SetCondition(c79078003.drcon1)
	e1:SetOperation(c79078003.drop1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--sp_summon effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_TO_DECK)
	e2:SetCondition(c79078003.regcon)
	e2:SetOperation(c79078003.regop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetCondition(c79078003.drcon2)
	e3:SetOperation(c79078003.drop2)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c79078003.filter(c,sp)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsPreviousLocation(LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND+LOCATION_REMOVED)
end
function c79078003.drcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c79078003.filter,1,nil,tp)
		and (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
end
function c79078003.drop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,200,REASON_EFFECT)
end
function c79078003.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c79078003.filter,1,nil,tp)
		and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
function c79078003.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,79078003,RESET_CHAIN,0,1)
end
function c79078003.drcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,79078003)>0
end
function c79078003.drop2(e,tp,eg,ep,ev,re,r,rp)
	local n=Duel.GetFlagEffect(tp,79078003)
	local n2=n*200
	Duel.ResetFlagEffect(tp,79078003)
	Duel.Damage(1-tp,n2,REASON_EFFECT)
end

function c79078003.condition(e,tp,eg,ep,ev,re,r,rp)
	local race=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_RACE)
	return re:IsActiveType(TYPE_MONSTER) and race&RACE_FISH>0
end
function c79078003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() and Duel.GetFlagEffect(tp,19078003)==0 end  
	Duel.RegisterFlagEffect(tp,19078003,RESET_CHAIN,0,1) 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0) 
end
function c79078003.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	if Duel.IsPlayerCanDiscardDeck(tp,2) and Duel.SelectYesNo(tp,aux.Stringid(79078003,1)) then 
	Duel.DiscardDeck(tp,2,REASON_EFFECT) 
	end 
end

