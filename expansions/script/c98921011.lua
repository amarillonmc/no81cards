--核成核心机构
function c98921011.initial_effect(c)
		aux.AddCodeList(c,36623431)
		--change name
	aux.EnableChangeCode(c,36623431,LOCATION_HAND)   
 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)	  
--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98921011,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,98921011)
	e2:SetCost(c98921011.thcost)
	e2:SetTarget(c98921011.thtg)
	e2:SetOperation(c98921011.thop)
	c:RegisterEffect(e2)   
 --destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98921011,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,98921011)
	e2:SetCost(c98921011.spcost)
	e2:SetTarget(c98921011.sptg)
	e2:SetOperation(c98921011.spop)
	c:RegisterEffect(e2)
 --tohand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,98931011)
	e3:SetCondition(c98921011.thcon1)   
	e3:SetCost(c98921011.thcost1)
	e3:SetTarget(c98921011.thtg1)
	e3:SetOperation(c98921011.thop1)
	c:RegisterEffect(e3)
end
function c98921011.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c98921011.thfilter(c)
	return c:IsSetCard(0x1d) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c98921011.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98921011.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98921011.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98921011.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c98921011.cfilter(c)
	return c:IsCode(36623431) and not c:IsPublic()
end
function c98921011.spcost(e,tp,eg,ep,ev,re,r,rp,chk)	
	if chk==0 then return Duel.IsExistingMatchingCard(c98921011.cfilter,tp,LOCATION_HAND,0,1,nil) and Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)   
	local g=Duel.SelectMatchingCard(tp,c98921011.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c98921011.spfilter(c,e,tp)
	return c:IsSetCard(0x1d) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98921011.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98921011.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c98921011.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c98921011.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()~=0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c98921011.thcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c98921011.thcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c98921011.filter(c)
	return (c:IsCode(36623431) or aux.IsCodeListed(c,36623431) and c:IsType(TYPE_SPELL+TYPE_TRAP)) and c:IsAbleToHand()
end
function c98921011.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98921011.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c98921011.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98921011.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)   
		local kg=Duel.GetMatchingGroup(c98921011.drfilter,tp,LOCATION_HAND,0,nil)
			 if kg:GetCount()>0 and Duel.IsPlayerCanDraw(tp,1)
			 and Duel.SelectYesNo(tp,aux.Stringid(98921011,1)) then
			 Duel.BreakEffect()
			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
			 local sg=kg:Select(tp,1,1,nil)
			 Duel.ConfirmCards(1-tp,sg)
			 Duel.ShuffleHand(tp)
			 Duel.Draw(tp,1,REASON_EFFECT)
		end   
	end
end
function c98921011.drfilter(c)
	return c:IsCode(36623431) and not c:IsPublic()
end