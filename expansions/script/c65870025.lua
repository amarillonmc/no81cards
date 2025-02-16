--Protoss·母舰核心
function c65870025.initial_effect(c)
	aux.AddCodeList(c,65870015)
	--连接
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x3a37),2,2)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65870025,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,65870025)
	e1:SetTarget(c65870025.target1)
	e1:SetOperation(c65870025.activate1)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65870025,1))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,65870025)
	e2:SetCondition(c65870025.excondition)
	--e2:SetCost(c65870025.thcost)
	e2:SetTarget(c65870025.target4)
	e2:SetOperation(c65870025.activate4)
	c:RegisterEffect(e2)
end

function c65870025.spfilter(c,e,tp)
	return c:IsSetCard(0x3a37) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER+TYPE_SPELL) and aux.NecroValleyFilter()
end
function c65870025.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65870025.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c65870025.activate1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c65870025.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c65870025.cfilter(c)
	return c:IsCode(65870015) and c:IsFaceup()
end
function c65870025.excondition(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c65870025.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c65870025.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckOrExtraAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c65870025.target4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,1-tp,LOCATION_ONFIELD)
end
function c65870025.activate4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	local tc=g:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	if tc:IsFaceup() and tc:IsCanBeDisabledByEffect(e,false) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
	end
end