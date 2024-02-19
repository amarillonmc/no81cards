--灵光 魔猪
function c21692414.initial_effect(c)
	--revive
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,21692414) 
	e1:SetCost(c21692414.spcost)
	e1:SetTarget(c21692414.sptg)
	e1:SetOperation(c21692414.spop)
	c:RegisterEffect(e1) 
	--to grave 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)  
	e2:SetTarget(c21692414.tgtg)
	e2:SetOperation(c21692414.tgop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3) 
	--des 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e3:SetCode(EVENT_DISCARD)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET) 
	e3:SetCountLimit(1,11692414)  
	e3:SetTarget(c21692414.destg)
	e3:SetOperation(c21692414.desop)
	c:RegisterEffect(e3)
end
c21692414.SetCard_ZW_ShLight=true 
function c21692414.costfilter(c)
	return not c:IsCode(21692414) and c:IsSetCard(0x555) and c:IsDiscardable()
end
function c21692414.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21692414.costfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c21692414.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c21692414.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c21692414.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end 
function c21692414.tgtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local fc=Duel.GetFirstMatchingCard(nil,tp,0,LOCATION_FZONE,nil)
	if chk==0 then return fc end 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,fc,1,0,0) 
end 
function c21692414.tgop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local fc=Duel.GetFirstMatchingCard(nil,tp,0,LOCATION_FZONE,nil) 
	if fc then 
		Duel.SendtoGrave(fc,REASON_RULE) 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE) 
		e1:SetTargetRange(0,1) 
		e1:SetValue(function(e,re,tp)
		return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsType(TYPE_FIELD) end) 
		e1:SetReset(RESET_PHASE+PHASE_END,2)  
		Duel.RegisterEffect(e1,tp) 
	end  
end 
function c21692414.destg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil) end 
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0) 
end 
function c21692414.desop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) then 
		Duel.Destroy(tc,REASON_EFFECT) 
	end 
end  






