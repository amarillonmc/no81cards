-- 龙裔幻殇反击
local s, id = GetID()

function s.initial_effect(c)
	-- Counter Trap type
	
	
	-- ①: Negate and return to deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK+CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.negcon)
	e1:SetCost(s.negcost)
	e1:SetTarget(s.negtg)
	e1:SetOperation(s.negop)
	c:RegisterEffect(e1)
	
	-- ②: Change control when sent to GY
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.ctcon)
	e2:SetTarget(s.cttg)
	e2:SetOperation(s.ctop)
	c:RegisterEffect(e2)
end

-- ①: Negate condition
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and Duel.IsChainNegatable(ev)
end
function s.cfilter(c,type)
	return c:IsType(type) and (c:IsAbleToGraveAsCost() or c:IsAbleToRemoveAsCost())
end
-- ①: Cost function
function s.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local type=bit.band(re:GetActiveType(),0x7)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil,type) end
	Duel.DiscardHand(tp,s.cfilter,1,1,REASON_COST+REASON_DISCARD,nil,type)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,type)
	local tc=g:GetFirst()
	if tc:IsAbleToGraveAsCost() and (not tc:IsAbleToRemoveAsCost() or Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))==0) then
		Duel.SendtoGrave(g,REASON_COST)
	else
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end

function s.costfilter(c,ctype)
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and 
		   (c:IsAbleToGrave() or c:IsAbleToRemove()) and
		   c:IsType(ctype & (TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP))
end

-- ①: Target function
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	end
	if re:GetActivateLocation()==LOCATION_GRAVE then
		e:SetCategory(e:GetCategory()|CATEGORY_GRAVE_ACTION)
	else
		e:SetCategory(e:GetCategory()&~CATEGORY_GRAVE_ACTION)
	end
end

-- ①: Operation
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then 
		Duel.SendtoDeck(eg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end

-- ②: Condition for being sent to GY
function s.ctfilter(c)
	return c:IsSetCard(0x3450) or c:IsSetCard(0x6450) -- "Dragonborn" or "Phantom Sorrow"
end

function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return (e:GetHandler():IsPreviousLocation(LOCATION_DECK+LOCATION_ONFIELD) and s.ctfilter(re:GetHandler()))
end

-- ②: Target for control change
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,0,0)
end

-- ②: Operation for control change
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectMatchingCard(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.GetControl(g:GetFirst(),tp,PHASE_END,1)
	end
end
