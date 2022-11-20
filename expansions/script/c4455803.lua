--西洋棋 战车
function c4455803.initial_effect(c)
	--SpecialSummon 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCountLimit(1,4455803) 
	e1:SetTarget(c4455803.sptg) 
	e1:SetOperation(c4455803.spop) 
	c:RegisterEffect(e1) 
	local e2=e1:Clone() 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	c:RegisterEffect(e2) 
	--to hand 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_TOHAND) 
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e3:SetCode(EVENT_LEAVE_FIELD) 
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)  
	e3:SetRange(LOCATION_GRAVE)  
	e3:SetCountLimit(1,1455803)
	e3:SetCondition(c4455803.thcon)
	e3:SetTarget(c4455803.thtg) 
	e3:SetOperation(c4455803.thop) 
	c:RegisterEffect(e3) 
	--extra summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(43034264,0))
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e4:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e4:SetTarget(function(e,c) 
	return c.SetCard_YLchess end) 
	c:RegisterEffect(e4)
end
c4455803.SetCard_YLchess=true 
function c4455803.spfil(c,e,tp)  
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCode(4455800) 
end 
function c4455803.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c4455803.spfil,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK) 
end 
function c4455803.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE) 
	local g=Duel.GetMatchingGroup(c4455803.spfil,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp) 
	if ft>0 and g:GetCount()>0 then  
	local sg=g:Select(tp,1,1,nil) 
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
	end 
end 
function c4455803.ckfil(c,tp) 
	return c:IsPreviousControler(tp) and c.SetCard_YLchess and (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp))  
end 
function c4455803.thcon(e,tp,eg,ep,ev,re,r,rp)  
	return eg:IsExists(c4455803.ckfil,1,nil,tp)  
end   
function c4455803.thtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsAbleToHand() end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0) 
end 
function c4455803.thop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) then 
	Duel.SendtoHand(c,nil,REASON_EFFECT) 
	end 
end  









