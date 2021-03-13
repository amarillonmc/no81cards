--黑钢国际·狙击干员-杰西卡
function c79029045.initial_effect(c)
	--remove and SpecialSummon 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
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
	e4:SetCondition(c79029045.spcon1)
	e4:SetTarget(c79029045.sptg)
	e4:SetCost(c79029045.spcost)
	e4:SetCountLimit(1,19029045)
	e4:SetOperation(c79029045.spop)
	c:RegisterEffect(e4)  
	local e5=e4:Clone()
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0,TIMING_END_PHASE)
	e5:SetCondition(c79029045.spcon2)
	c:RegisterEffect(e5)
end
function c79029045.thfilter(c)
	return c:IsSetCard(0x1904) and c:IsType(TYPE_TRAP)
end
function c79029045.thfilter2(c,e,tp)
	return c:IsSetCard(0xa900) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c79029045.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c79029045.thfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(c79029045.thfilter2,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c79029045.thop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c79029045.thfilter,tp,LOCATION_DECK+LOCATION_HAND,0,nil)
	if g1:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=g1:Select(tp,1,1,nil)
	if Duel.Remove(rg,POS_FACEUP,REASON_EFFECT) then
	Debug.Message("我一定......不会辜负您的信任。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029045,0))
	local g2=Duel.GetMatchingGroup(c79029045.thfilter2,tp,LOCATION_DECK,0,nil,e,tp)
	if g2:GetCount()<=0 then return end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g2:Select(tp,1,1,nil)
	if sg:GetCount()>0 then
	 Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
	end
end
function c79029045.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,79029436)
end
function c79029045.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,79029436)
end
function c79029045.rfilter(c,tp)
	return c:IsType(TYPE_TRAP) and c:IsSetCard(0x1904) and c:IsAbleToGraveAsCost()
end
function c79029045.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c79029045.rfilter,c:GetControler(),LOCATION_ONFIELD+LOCATION_REMOVED+LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c79029045.rfilter,tp,LOCATION_ONFIELD+LOCATION_REMOVED+LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	Debug.Message("这次我要证明自己......！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029045,1))
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
