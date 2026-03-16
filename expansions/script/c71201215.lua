--闪烁初星 藤田琴音·校园模式!!
function c71201215.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71201215,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,11201215)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c71201215.thtg)
	e1:SetOperation(c71201215.thop)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71201215,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,71201215)
	e2:SetCondition(c71201215.con)
	e2:SetTarget(c71201215.tg)
	e2:SetOperation(c71201215.op)
	c:RegisterEffect(e2)
	--negate
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(71201215,2))
	e5:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetCountLimit(1,21201215)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c71201215.negcon)
	e5:SetCost(c71201215.negcost)
	e5:SetTarget(c71201215.negtg)
	e5:SetOperation(c71201215.negop)
	c:RegisterEffect(e5)
end
function c71201215.thfilter(c)
	return c:IsSetCard(0x7121) and c:IsAbleToHand() and not c:IsCode(71201215)
end
function c71201215.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71201215.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c71201215.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c71201215.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g~=0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c71201215.cfilter(c)
	return c:IsSetCard(0x7121) and c:IsFaceup()
end
function c71201215.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT) and Duel.IsExistingMatchingCard(c71201215.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c71201215.filter(c)
	return c:IsSetCard(0x7121) and c:IsType(TYPE_SPELL+TYPE_TRAP) and (c:IsAbleToHand() or c:IsAbleToRemove())
end
function c71201215.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71201215.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c71201215.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c71201215.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()<=0 then return end
	local tc=g:GetFirst()
	if tc:IsAbleToHand() and (not tc:IsAbleToRemove() or Duel.SelectOption(tp,1190,1192)==0) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	else
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c71201215.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep==tp or c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c71201215.costfilter(c)
	return c:IsSetCard(0x7121) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemoveAsCost() and c:IsFaceup()
end
function c71201215.linkfilter(c)
	return c:IsSetCard(0x7121) and c:IsType(TYPE_LINK) and c:IsFaceup()
end
function c71201215.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71201215.costfilter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c71201215.costfilter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c71201215.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c71201215.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.Recover(tp,500,REASON_EFFECT)~=0 then return end
	if Duel.IsExistingMatchingCard(c71201215.linkfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsChainNegatable(ev)
		and Duel.SelectYesNo(tp,aux.Stringid(71201215,4)) then
		Duel.NegateActivation(ev)
		Duel.BreakEffect()
	end
end