--圆环的使徒  晓美焰
function c1000600.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1000600,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,1000600)
	e1:SetTarget(c1000600.sptg2)
	e1:SetOperation(c1000600.spop2)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--atk/lv up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1000600,1))
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,10006000)
	e2:SetCondition(c1000600.con2)
	e2:SetOperation(c1000600.operation)
	c:RegisterEffect(e2)
	--direct atk
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_DIRECT_ATTACK)
	e6:SetCondition(c1000600.con3)
	c:RegisterEffect(e6)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1000600,2))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,10006000)
   e2:SetCondition(c1000600.con)
	e2:SetCost(c1000600.thcost)
	e2:SetTarget(c1000600.thtg)
	e2:SetOperation(c1000600.thop)
	c:RegisterEffect(e2)
end
function c1000600.filter(c,e,tp)
	return ((c:IsType(TYPE_TUNER) and c:IsSetCard(0xc204)) or c:IsSetCard(0x5b23)) and not c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1000600.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c1000600.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c1000600.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c1000600.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c1000600.filter9(c,e,tp)
	return (c:IsSetCard(0xc204) or c:IsSetCard(0x5b23)) and c:IsControler(tp) and not c:IsType(TYPE_PENDULUM) 
end
function c1000600.con(e,tp,eg,ep,ev,re,r,rp)
   local g=Duel.GetMatchingGroup(c1000600.filter9,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,e,tp)
	local ct=g:GetClassCount(Card.GetCode)
   return  ct>=6
end
function c1000600.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c1000600.thfilter(c)
	return c:IsSetCard(0x5b23) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c1000600.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1000600.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c1000600.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1000600.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c1000600.con2(e,tp,eg,ep,ev,re,r,rp)
   local g=Duel.GetMatchingGroup(c1000600.filter9,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,e,tp)
	local ct=g:GetClassCount(Card.GetCode)
   return  ct>=3
end
function c1000600.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		e1:SetValue(800)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_LEVEL)
		e2:SetReset(RESET_EVENT+0x1ff0000)
		e2:SetValue(2)
		c:RegisterEffect(e2)
	end
end
function c1000600.con3(e,tp,eg,ep,ev,re,r,rp)
   local g=Duel.GetMatchingGroup(c1000600.filter9,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,e,tp)
	local ct=g:GetClassCount(Card.GetCode)
   return  ct>=9
end