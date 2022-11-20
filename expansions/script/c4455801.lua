--西洋棋 骑士
function c4455801.initial_effect(c)
	--extra att
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetValue(1)
	c:RegisterEffect(e1)	
	--to hand 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_LEAVE_FIELD) 
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)  
	e2:SetRange(LOCATION_GRAVE)  
	e2:SetCountLimit(1,4455801)
	e2:SetCondition(c4455801.thcon)
	e2:SetTarget(c4455801.thtg) 
	e2:SetOperation(c4455801.thop) 
	c:RegisterEffect(e2) 
	--SpecialSummon 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e3:SetCode(EVENT_SUMMON_SUCCESS) 
	e3:SetProperty(EFFECT_FLAG_DELAY) 
	e3:SetCountLimit(1,1455801) 
	e3:SetTarget(c4455801.sptg) 
	e3:SetOperation(c4455801.spop) 
	c:RegisterEffect(e3) 
	local e4=e3:Clone() 
	e4:SetCode(EVENT_SPSUMMON_SUCCESS) 
	c:RegisterEffect(e4) 
end
c4455801.SetCard_YLchess=true 
function c4455801.ckfil(c,tp) 
	return c:IsPreviousControler(tp) and c.SetCard_YLchess and (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp))  
end 
function c4455801.thcon(e,tp,eg,ep,ev,re,r,rp)  
	return eg:IsExists(c4455801.ckfil,1,nil,tp)  
end   
function c4455801.thtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsAbleToHand() end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0) 
end 
function c4455801.thop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) then 
	Duel.SendtoHand(c,nil,REASON_EFFECT) 
	end 
end  
function c4455801.spfil(c,e,tp)  
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCode(4455800) 
end 
function c4455801.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c4455801.spfil,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK) 
end 
function c4455801.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE) 
	local g=Duel.GetMatchingGroup(c4455801.spfil,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp) 
	if ft>0 and g:GetCount()>0 then 
	if ft>2 then ft=2 end 
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end 
	local sg=g:Select(tp,1,ft,nil) 
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
	end 
end 






