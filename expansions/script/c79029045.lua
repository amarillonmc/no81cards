--黑钢国际·狙击干员-杰西卡
function c79029045.initial_effect(c)
	--remove and SpecialSummon 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,79029045)
	e1:SetTarget(c79029045.thtg)
	e1:SetOperation(c79029045.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)	
	--SpecialSummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e4:SetTarget(c79029045.sptg)
	e4:SetCost(c79029045.spcost)
	e4:SetCountLimit(1,790290459999999)
	e4:SetOperation(c79029045.spop)
	c:RegisterEffect(e4)  
end
function c79029045.thfilter(c)
	return c:IsSetCard(0x1904) and c:IsType(TYPE_TRAP)
end
function c79029045.thfilter2(c)
	return c:IsSetCard(0xa900) and c:IsLevelBelow(4)
end
function c79029045.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c79029045.thfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(c79029045.thfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c79029045.thfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function c79029045.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c79029045.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
	 Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c79029045.rfilter(c,tp)
	return c:IsType(TYPE_TRAP) and c:IsSetCard(0x1904)
end
function c79029045.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c79029045.rfilter,c:GetControler(),LOCATION_ONFIELD+LOCATION_REMOVED+LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c79029045.rfilter,tp,LOCATION_ONFIELD+LOCATION_REMOVED+LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c79029045.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c79029045.spop(e,tp,eg,ep,ev,re,r,rp,c)
   local c=e:GetHandler()
   Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
