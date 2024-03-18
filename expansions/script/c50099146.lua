--仗剑走天涯 金晶石
function c50099146.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,50099146)
	e1:SetCondition(c50099146.condition) 
	e1:SetTarget(c50099146.target)
	e1:SetOperation(c50099146.activate)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,10099146) 
	e2:SetTarget(c50099146.thtg)
	e2:SetOperation(c50099146.thop)
	c:RegisterEffect(e2) 
end
function c50099146.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c50099146.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) then 
		Duel.SendtoHand(c,nil,REASON_EFFECT) 
	end 
end 
function c50099146.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x998) and c:IsType(TYPE_SYNCHRO)
end
function c50099146.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c50099146.cfilter,tp,LOCATION_MZONE,0,1,nil) 
end
function c50099146.spfil(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE,1-tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
end
function c50099146.target(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c50099146.spfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(c50099146.spfil,tp,0,LOCATION_GRAVE,1,nil,e,1-tp) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_GRAVE)
end
function c50099146.activate(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(c50099146.spfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(c50099146.spfil,tp,0,LOCATION_GRAVE,1,nil,e,1-tp) then 
		local sc1=Duel.SelectMatchingCard(tp,c50099146.spfil,tp,0,LOCATION_GRAVE,1,1,nil,e,1-tp):GetFirst()
		local sc2=Duel.SelectMatchingCard(1-tp,c50099146.spfil,tp,LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst() 
		Duel.SpecialSummonStep(sc1,0,tp,1-tp,false,false,POS_FACEDOWN_DEFENSE)
		Duel.SpecialSummonStep(sc2,0,1-tp,tp,false,false,POS_FACEDOWN_DEFENSE) 
		Duel.SpecialSummonComplete()
	end 
end










