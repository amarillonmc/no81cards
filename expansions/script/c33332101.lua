--澄炎之霜语 克利斯
function c33332101.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCountLimit(1,33332101)
	e1:SetCondition(c33332101.spcon)
	e1:SetTarget(c33332101.sptg)
	e1:SetOperation(c33332101.spop)
	c:RegisterEffect(e1) 
	--SpecialSummon
	local e2=Effect.CreateEffect(c)  
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_TO_GRAVE) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetCountLimit(1,13332101) 
	e2:SetTarget(c33332101.gsptg)
	e2:SetOperation(c33332101.gspop)
	c:RegisterEffect(e2) 
end
function c33332101.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsReason(REASON_DRAW)
end
function c33332101.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end 
function c33332101.sthfil(c) 
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()  
end 
function c33332101.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsLocation(LOCATION_HAND) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(c33332101.sthfil,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(33332101,0)) then
		Duel.BreakEffect() 
		local sg=Duel.SelectMatchingCard(tp,c33332101.sthfil,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil)  
		Duel.SendtoHand(sg,nil,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,sg)		  
	end 
end 
function c33332101.gspfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x6567)  
end 
function c33332101.gsptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c33332101.gspfil,tp,LOCATION_HAND+LOCATION_PZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_PZONE)
end 
function c33332101.gspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c33332101.gspfil,tp,LOCATION_HAND+LOCATION_PZONE,0,nil,e,tp) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)	
	end 
end 




