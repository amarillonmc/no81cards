--方舟骑士-陈
c29065505.named_with_Arknight=1
function c29065505.initial_effect(c)
	aux.AddCodeList(c,29065500)
	c:EnableCounterPermit(0x1ae)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29065505,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,29065505)
	e2:SetTarget(c29065505.sptg1)
	e2:SetOperation(c29065505.spop1)
	c:RegisterEffect(e2)  
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	c29065505.summon_effect=e2
	--tohand	
	local e4=Effect.CreateEffect(c)   
	e4:SetDescription(aux.Stringid(29065505,1))  
	e4:SetCategory(CATEGORY_COUNTER)	
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)	
	e4:SetProperty(EFFECT_FLAG_DELAY)   
	e4:SetCode(EVENT_LEAVE_FIELD)  
	e4:SetCondition(c29065505.thcon)	
	e4:SetTarget(c29065505.thtg)	
	e4:SetOperation(c29065505.thop)  
	c:RegisterEffect(e4)	
end
function c29065505.spfilter(c,e,tp)
	return aux.IsCodeListed(c,29065500) and not c:IsCode(29065505) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (c:IsLocation(LOCATION_HAND) or (c:IsLocation(LOCATION_DECK) and  Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,29065500)))
end
function c29065505.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c29065505.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c29065505.spop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c29065505.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c29065505.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) 
end 
function c29065505.thfilter(c)
	return c:IsSetCard(0x87af) or _G["c"..c:GetCode()].named_with_Arknight
 end 
function c29065505.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
 if chk==0 then return Duel.IsExistingMatchingCard(c29065505.thfilter,tp,LOCATION_ONFIELD,0,1,nil) end 
end
 function c29065505.thop(e,tp,eg,ep,ev,re,r,rp) 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP) 
	local tc=Duel.SelectMatchingCard(tp,c29065505.thfilter,tp,LOCATION_ONFIELD,0,1,1,nil):GetFirst()	
	local n=1 
	if Duel.IsPlayerAffectedByEffect(tp,29065580) then
	n=n+1
	end
	tc:AddCounter(0x1ae,n)
end