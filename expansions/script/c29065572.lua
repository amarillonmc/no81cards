--方舟之骑士·凯尔希
function c29065572.initial_effect(c)
	c:EnableCounterPermit(0x87ae)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29065572,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,29065572)
	e1:SetCost(c29065572.spcost)
	e1:SetTarget(c29065572.sptg)
	e1:SetOperation(c29065572.spop)
	c:RegisterEffect(e1) 
	--to hand 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29065572,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,19065572)
	e2:SetTarget(c29065572.thtg1)
	e2:SetOperation(c29065572.thop1)
	c:RegisterEffect(e2)  
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	c29065572.summon_effect=e2
	--tohand	
	local e4=Effect.CreateEffect(c)   
	e4:SetDescription(aux.Stringid(29065572,3))  
	e4:SetCategory(CATEGORY_COUNTER)	
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)	
	e4:SetProperty(EFFECT_FLAG_DELAY)   
	e4:SetCode(EVENT_TO_GRAVE)  
	e4:SetCountLimit(1,09065572) 
	e4:SetCondition(c29065572.thcon)	
	e4:SetTarget(c29065572.thtg)	
	e4:SetOperation(c29065572.thop)  
	c:RegisterEffect(e4)	
	local e5=e4:Clone()  
	e5:SetCode(EVENT_TO_HAND)   
	c:RegisterEffect(e5)	 
end
function c29065572.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x87ae,2,REASON_COST) or Duel.IsPlayerAffectedByEffect(tp,29065592) end
	if Duel.IsPlayerAffectedByEffect(tp,29065592) and (not Duel.IsCanRemoveCounter(tp,1,0,0x87ae,2,REASON_COST) or Duel.SelectYesNo(tp,aux.Stringid(29065592,0))) then
	Duel.RegisterFlagEffect(tp,29065592,RESET_PHASE+PHASE_END,0,1)
	else
	Duel.RemoveCounter(tp,1,0,0x87ae,2,REASON_COST)
	end
end
function c29065572.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c29065572.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		Duel.BreakEffect()
	local n=1 
	if Duel.IsPlayerAffectedByEffect(tp,29065580) then
	n=n+1
	end
	e:GetHandler():AddCounter(0x87ae,n)  
	end
end
function c29065572.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) 
end 
function c29065572.thfilter(c)
	return c:IsSetCard(0x87af) and c:IsCanAddCounter(0x87ae,1)
 end 
function c29065572.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
 if chk==0 then return Duel.IsExistingMatchingCard(c29065572.thfilter,tp,LOCATION_ONFIELD,0,1,nil) end 
end
 function c29065572.thop(e,tp,eg,ep,ev,re,r,rp) 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP) 
	local tc=Duel.SelectMatchingCard(tp,c29065572.thfilter,tp,LOCATION_ONFIELD,0,1,1,nil):GetFirst()	
	local n=1 
	if Duel.IsPlayerAffectedByEffect(tp,29065580) then
	n=n+1
	end
	tc:AddCounter(0x87ae,n)
end
function c29065572.xthfilter(c)
	return c:IsSetCard(0x87af) and not c:IsCode(29065572) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c29065572.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29065572.xthfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c29065572.athfilter(c,tp)
	return c:IsSetCard(0x87af) and c:GetType()==0x20002
	and c:GetActivateEffect():IsActivatable(tp)
end
function c29065572.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c29065572.xthfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
	if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,29065577) and Duel.IsExistingMatchingCard(c29065572.athfilter,tp,LOCATION_DECK,0,1,nil,tp) and Duel.SelectYesNo(tp,aux.Stringid(29065572,0)) then
	local tc=Duel.SelectMatchingCard(tp,c29065572.athfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local te=tc:GetActivateEffect()
			local tep=tc:GetControler()
			local cost=te:GetCost()
			local tg=te:GetTarget()
			local op=te:GetOperation()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			if tg then tg(te,tep,eg,ep,ev,re,r,rp,1) end
			if op then op(te,tep,eg,ep,ev,re,r,rp) end
	end
	end
end