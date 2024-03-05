function c10105676.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10105676,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,10105676)
	e1:SetTarget(c10105676.sptg1)
	e1:SetOperation(c10105676.spop1)
	c:RegisterEffect(e1)
    	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_EVENT_PLAYER) 
	e2:SetCondition(c10105676.effcon)
	e2:SetOperation(c10105676.effop)
	c:RegisterEffect(e2)
    	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(aux.exccon)
	e3:SetCountLimit(1,101056760)
	e3:SetCost(c10105676.cost)
	e3:SetTarget(c10105676.sptg)
	e3:SetOperation(c10105676.spop)
	c:RegisterEffect(e3) 
    end
    function c10105676.spfilter1(c,e,tp)
	return c:IsSetCard(0x1084) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10105676.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10105676.spfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c10105676.spop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10105676.spfilter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c10105676.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c10105676.splimit(e,c)
	return not (c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_FIRE))
end
function c10105676.effcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ and e:GetHandler():GetReasonCard():IsSetCard(0x1084) 
end
function c10105676.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(10105676,0))   
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)  
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1) 
	e1:SetCondition(c10105676.descon)
	e1:SetTarget(c10105676.destg) 
	e1:SetOperation(c10105676.desop) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)   
end
function c10105676.dckfil(c,tp) 
	return c:IsSummonLocation(LOCATION_HAND) and c:IsPreviousControler(1-tp)  
end 
function c10105676.descon(e,tp,eg,ep,ev,re,r,rp)  
	return eg:IsExists(c10105676.dckfil,1,nil,tp) 
end 
function c10105676.destg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end 
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil) 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0) 
end   
function c10105676.desop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e) 
	if g:GetCount()>0 then 
		Duel.Destroy(g,REASON_EFFECT)   
	end  
end
function c10105676.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c10105676.spfilter(c,e,tp)
	return c:IsSetCard(0x1084) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10105676.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10105676.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c10105676.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c10105676.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end