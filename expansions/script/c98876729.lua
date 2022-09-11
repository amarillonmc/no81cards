--寻芳精之落雨
function c98876729.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_PLANT))
	e2:SetValue(500)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3) 
	--SpecialSummon 
	local e4=Effect.CreateEffect(c)  
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e4:SetCode(EVENT_LEAVE_FIELD) 
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_SZONE)  
	e4:SetCountLimit(1,98876729) 
	e4:SetTarget(c98876729.sptg) 
	e4:SetOperation(c98876729.spop)
	c:RegisterEffect(e4)
end 
function c98876729.sckfil(c,e,tp) 
	return c:IsLocation(LOCATION_EXTRA) and c:GetReasonEffect():GetHandler():IsCode(95286165,32441317,78610936)   
end  
function c98876729.spfil(c,e,tp) 
	local b1=c:IsSetCard(0x988) 
	if Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_MZONE,1,nil) then 
	b1=c:IsRace(RACE_PLANT) 
	end 
	return b1 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end 
function c98876729.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c98876729.sckfil,1,nil,e,tp) and Duel.IsExistingMatchingCard(c98876729.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98876729.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c98876729.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp) 
	if g:GetCount()>0 then 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON) 
	local sg=g:Select(tp,1,1,nil) 
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
	end 
end 







