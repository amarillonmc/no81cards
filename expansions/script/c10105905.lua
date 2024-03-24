--虫融姬战国·寄雀蜂鬼
function c10105905.initial_effect(c)
	--SpecialSummon
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetRange(LOCATION_DECK) 
	e1:SetCondition(c10105905.dspcon) 
	e1:SetOperation(c10105905.dspop) 
	c:RegisterEffect(e1) 
	--to hand 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,10105905) 
	e2:SetCost(c10105905.thcost)
	e2:SetTarget(c10105905.thtg)
	e2:SetOperation(c10105905.thop)
	c:RegisterEffect(e2) 
	--race 
	local e3=Effect.CreateEffect(c) 
	e3:SetType(EFFECT_TYPE_SINGLE) 
	e3:SetCode(EFFECT_ADD_RACE)  
	e3:SetValue(RACE_WINDBEAST)
	e3:SetCondition(function(e) 
	return e:GetHandler():IsLocation(LOCATION_MZONE) end)
	c:RegisterEffect(e3) 
	--negate
	local e4=Effect.CreateEffect(c) 
	e4:SetCategory(CATEGORY_DISABLE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,20105905)
	e4:SetCondition(c10105905.discon)
	e4:SetCost(c10105905.discost)
	e4:SetTarget(c10105905.distg)
	e4:SetOperation(c10105905.disop)
	c:RegisterEffect(e4)
end
function c10105905.dsck(c) 
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and c:IsSetCard(0x8cdd)   
end 
function c10105905.dspcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10105905.dsck,1,nil) and Duel.GetFlagEffect(tp,10105905)==0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0   
end 
function c10105905.dspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,10105905)==0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectEffectYesNo(tp,c,aux.Stringid(10105905,0)) then 
		Duel.RegisterFlagEffect(tp,10105905,RESET_PHASE+PHASE_END,0,1)
		Duel.Hint(HINT_CARD,0,10105905)
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end 
end
function c10105905.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end 
function c10105905.thfil(c)
	return c:IsAbleToHand() and c:IsSetCard(0x8cdd) and c:IsType(TYPE_TRAP)
end
function c10105905.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10105905.thfil,tp,LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK) 
end
function c10105905.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.SelectMatchingCard(tp,c10105905.thfil,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then 
		Duel.SendtoHand(tc,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,tc) 
	end
end
function c10105905.fckfil(c) 
	return c:IsFaceup() and c:IsSetCard(0x8cdd) and c:IsType(TYPE_FUSION) 
end 
function c10105905.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and re:IsActiveType(TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev) and Duel.IsExistingMatchingCard(c10105905.fckfil,tp,LOCATION_MZONE,0,1,nil)
end
function c10105905.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST) 
end
function c10105905.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,0,LOCATION_ONFIELD)
end
function c10105905.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.SelectMatchingCard(tp,aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil):GetFirst() 
	if tc then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)  
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=e1:Clone()
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			tc:RegisterEffect(e3)
		end
	end
end



