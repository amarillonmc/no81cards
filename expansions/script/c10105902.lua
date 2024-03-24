--虫融姬战国·先登蠊切
function c10105902.initial_effect(c)
	--SpecialSummon
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetRange(LOCATION_DECK) 
	e1:SetCondition(c10105902.dspcon) 
	e1:SetOperation(c10105902.dspop) 
	c:RegisterEffect(e1) 
	--to hand 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,10105902) 
	e2:SetCost(c10105902.thcost)
	e2:SetTarget(c10105902.thtg)
	e2:SetOperation(c10105902.thop)
	c:RegisterEffect(e2) 
	--race 
	local e3=Effect.CreateEffect(c) 
	e3:SetType(EFFECT_TYPE_SINGLE) 
	e3:SetCode(EFFECT_ADD_RACE)  
	e3:SetValue(RACE_WARRIOR)
	e3:SetCondition(function(e) 
	return e:GetHandler():IsLocation(LOCATION_MZONE) end)
	c:RegisterEffect(e3) 
	--negate
	local e4=Effect.CreateEffect(c) 
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,20105902)
	e4:SetCondition(c10105902.descon)
	e4:SetCost(c10105902.descost)
	e4:SetTarget(c10105902.destg)
	e4:SetOperation(c10105902.desop)
	c:RegisterEffect(e4) 
	local e5=e4:Clone() 
	e5:SetCode(EVENT_SPSUMMON_SUCCESS) 
	c:RegisterEffect(e5)
end
function c10105902.dsck(c) 
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and c:IsSetCard(0x8cdd)   
end 
function c10105902.dspcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10105902.dsck,1,nil) and Duel.GetFlagEffect(tp,10105902)==0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0   
end 
function c10105902.dspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,10105902)==0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectEffectYesNo(tp,c,aux.Stringid(10105902,0)) then 
		Duel.RegisterFlagEffect(tp,10105902,RESET_PHASE+PHASE_END,0,1)
		Duel.Hint(HINT_CARD,0,10105902)
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end 
end
function c10105902.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end 
function c10105902.thfil(c)
	return c:IsAbleToHand() and c:IsSetCard(0x8cdd) and c:IsType(TYPE_MONSTER)
end
function c10105902.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10105902.thfil,tp,LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK) 
end
function c10105902.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.SelectMatchingCard(tp,c10105902.thfil,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then 
		Duel.SendtoHand(tc,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,tc) 
	end
end
function c10105902.fckfil(c) 
	return c:IsFaceup() and c:IsSetCard(0x8cdd) and c:IsType(TYPE_FUSION) 
end 
function c10105902.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp) and Duel.IsExistingMatchingCard(c10105902.fckfil,tp,LOCATION_MZONE,0,1,nil)
end
function c10105902.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST) 
end
function c10105902.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD)
end
function c10105902.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil):GetFirst() 
	if tc then 
		Duel.Destroy(tc,REASON_EFFECT) 
	end 
end


