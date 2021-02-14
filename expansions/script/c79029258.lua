--杰西卡·生命之地收藏-燃灰
function c79029258.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x1904),aux.NonTuner(nil),1)
	c:EnableReviveLimit()   
	--add code
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ADD_CODE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(79029045)
	c:RegisterEffect(e2) 
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,79029258)
	e2:SetCondition(c79029258.thcon)
	e2:SetCost(c79029258.thcost)
	e2:SetTarget(c79029258.thtg)
	e2:SetOperation(c79029258.thop)
	c:RegisterEffect(e2)	
	--SpecialSummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetTarget(c79029258.sptg)
	e4:SetCost(c79029258.spcost)
	e4:SetCountLimit(1,09029258)
	e4:SetOperation(c79029258.spop)
	c:RegisterEffect(e4)  
end
function c79029258.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c79029258.cofil(c)
	return c:IsAbleToGraveAsCost() and c:IsSetCard(0x1904) and c:IsType(TYPE_TRAP)
end
function c79029258.thcost(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029258.cofil,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c79029258.cofil,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c79029258.thfil(c)
	return c:IsAbleToHand() and c:IsSetCard(0x1904)
end
function c79029258.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029258.thfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c79029258.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c79029258.thfil,tp,LOCATION_DECK,0,nil)
	if g:GetCount()<=0 then return end
	Debug.Message("不会退缩。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029258,0))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	Duel.SendtoHand(tc,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
end
function c79029258.rfilter(c,tp)
	return c:IsType(TYPE_TRAP) and c:IsSetCard(0x1904) and c:IsAbleToGraveAsCost()
end
function c79029258.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c79029258.rfilter,c:GetControler(),LOCATION_ONFIELD+LOCATION_REMOVED+LOCATION_HAND,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c79029258.rfilter,tp,LOCATION_ONFIELD+LOCATION_REMOVED+LOCATION_HAND,0,2,2,nil)
	Duel.SendtoGrave(g,REASON_COST)
	Debug.Message("这次我要证明自己......！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029045,1))
end
function c79029258.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c79029258.spop(e,tp,eg,ep,ev,re,r,rp,c)
   local c=e:GetHandler()
   Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end








