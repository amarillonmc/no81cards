--奇妙物语 邪恶小人
function c10128003.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10128003,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c10128003.target)
	e1:SetOperation(c10128003.activate)
	c:RegisterEffect(e1) 
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10128003,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCost(c10128003.thcost)
	e2:SetTarget(c10128003.thtg)
	e2:SetOperation(c10128003.thop)
	c:RegisterEffect(e2)  
	--remain field
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e3) 
end
function c10128003.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c10128003.thfilter(c,code)
	return c:IsAbleToHand() and c:IsCode(code)
end
function c10128003.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=re:GetHandler()
	if chk==0 then return bit.band(tc:GetType(),0x10002)==0x10002 and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsExistingMatchingCard(c10128003.thfilter,tp,LOCATION_DECK,0,1,nil,tc:GetCode()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)   
end
function c10128003.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)   
	local g=Duel.SelectMatchingCard(tp,c10128003.thfilter,tp,LOCATION_DECK,0,1,1,nil,re:GetHandler():GetCode())
	if g:GetCount()>0 then
	   Duel.SendtoHand(g,nil,REASON_EFFECT)
	   Duel.ConfirmCards(1-tp,g)
	end
end
function c10128003.spfilter(c,tp)
	return ((c:IsFaceup() and c:GetSequence()<5) or c:IsLocation(LOCATION_HAND)) and c:IsSetCard(0x6336) and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),0x6336,0x21,0,0,1,RACE_SPELLCASTER,ATTRIBUTE_FIRE) and c:IsType(TYPE_SPELL)
end
function c10128003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_SZONE+LOCATION_HAND)
end
function c10128003.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(c10128003.spfilter,tp,LOCATION_SZONE+LOCATION_HAND,0,c,tp)
	if sg:GetCount()<=0 or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not Duel.SelectYesNo(tp,aux.Stringid(10128003,2)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)   
	local tc=sg:Select(tp,1,1,nil):GetFirst()
	tc:AddMonsterAttribute(TYPE_EFFECT,ATTRIBUTE_FIRE,RACE_SPELLCASTER,1,0,0)
	Duel.SpecialSummonStep(tc,1,tp,tp,true,false,POS_FACEUP)
	tc:AddMonsterAttributeComplete()
	Duel.SpecialSummonComplete()
end