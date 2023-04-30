--基格尔德核心
function c75011873.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75011873,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,75011873) 
	e1:SetTarget(c75011873.sptg)
	e1:SetOperation(c75011873.spop)
	c:RegisterEffect(e1) 
	--Gains Effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_EVENT_PLAYER) 
	e2:SetCondition(c75011873.efcon)
	e2:SetOperation(c75011873.efop)
	c:RegisterEffect(e2) 
	--to hand 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_LEAVE_FIELD) 
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY) 
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,15011873) 
	e2:SetCondition(c75011873.thcon)
	e2:SetTarget(c75011873.thtg) 
	e2:SetOperation(c75011873.thop) 
	c:RegisterEffect(e2) 
end 
c75011873.SetCard_TT_JGRD=true 
function c75011873.spfil(c,e,tp) 
	return c:IsCode(75011870) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end 
function c75011873.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=2 
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(c75011873.spfil,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c75011873.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(c75011873.spfil,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.BreakEffect()
		local sg=Duel.SelectMatchingCard(tp,c75011873.spfil,tp,LOCATION_DECK,0,1,1,nil,e,tp) 
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)   
	end
end
function c75011873.efcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return r==REASON_XYZ and c:GetReasonCard().SetCard_TT_JGRD 
end
function c75011873.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(75011873,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c75011873.xthtg)
	e1:SetOperation(c75011873.xthop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2,true)
	end
end
function c75011873.xthfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c.SetCard_TT_JGRD and c:IsAbleToHand()
end
function c75011873.xthtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75011873.xthfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c75011873.xthop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c75011873.xthfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c75011873.ckfil(c,tp) 
	return c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp and c.SetCard_TT_JGRD  
end 
function c75011873.thcon(e,tp,eg,ep,ev,re,r,rp)  
	return eg:IsExists(c75011873.ckfil,1,nil,tp)   
end 
function c75011873.tdfil(c) 
	return c:IsCode(75011870) and c:IsAbleToDeck()  
end 
function c75011873.thtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsAbleToHand() and Duel.IsExistingMatchingCard(c75011873.tdfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0) 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end 
function c75011873.thop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) then 
		Duel.SendtoHand(c,nil,2,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,c)   
		if Duel.IsExistingMatchingCard(c75011873.tdfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) then 
			local sg=Duel.SelectMatchingCard(tp,c75011873.tdfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
			Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)  
		end 
	end 
end 




