--神威骑士团出击！
function c24501017.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e0:SetCondition(c24501017.excondition)
	e0:SetDescription(aux.Stringid(24501017,0))
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c24501017.cost)
	e1:SetTarget(c24501017.target)
	e1:SetOperation(c24501017.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c24501017.thcost)
	e2:SetTarget(c24501017.thtg)
	e2:SetOperation(c24501017.thop)
	c:RegisterEffect(e2)
end
function c24501017.exfilter(c)
	return c:IsCode(24501036) and c:IsFaceup()
end
function c24501017.excondition(e)
	return Duel.IsExistingMatchingCard(c24501017.exfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c24501017.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,c,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,1,c,tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function c24501017.cfilter(c,e,tp,chk)
	return (c:IsSetCard(0x501) and Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)) or (c:IsSetCard(0x501) and c:IsType(TYPE_MONSTER) or chk and c:IsRace(RACE_MACHINE)) and c:IsAbleToHand()
end
function c24501017.checkfilter(c)
	return c:IsSetCard(0x501) and c:IsFaceup()
end
function c24501017.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local check=Duel.IsExistingMatchingCard(c24501017.checkfilter,tp,LOCATION_MZONE,0,1,nil)
	if chk==0 then return
		Duel.IsExistingMatchingCard(c24501017.cfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,check)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c24501017.activate(e,tp,eg,ep,ev,re,r,rp)
	local check=Duel.IsExistingMatchingCard(c24501017.checkfilter,tp,LOCATION_MZONE,0,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local sc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c24501017.cfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,check):GetFirst()
	if not (sc:IsSetCard(0x501) and Duel.GetMZoneCount(tp)>0 and sc:IsCanBeSpecialSummoned(e,0,tp,false,false)) and sc:IsAbleToHand() or Duel.SelectOption(tp,1190,1152)==0 then
		Duel.SendtoHand(sc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sc)
	else
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c24501017.tdfilter(c)
	return c:IsSetCard(0x501) and c:IsAbleToDeckAsCost()
end
function c24501017.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c24501017.tdfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c24501017.tdfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.SendtoDeck(g,nil,SEQ_DECKBOTTOM,REASON_COST)
end
function c24501017.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c24501017.thfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsAbleToHand()
end
function c24501017.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SendtoHand(c,nil,REASON_EFFECT)==0 then return end
	Duel.ConfirmCards(1-tp,c)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c24501017.thfilter),tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(24501017,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
