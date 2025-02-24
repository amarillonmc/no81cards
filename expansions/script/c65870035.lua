--Protoss·星空加速
function c65870035.initial_effect(c)
	aux.AddCodeList(c,65870015)
	--act in hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e3:SetCondition(c65870035.excondition)
	e3:SetDescription(aux.Stringid(65870035,2))
	c:RegisterEffect(e3)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(65870035,0))
	e0:SetCategory(CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION+CATEGORY_SEARCH)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,65870035+EFFECT_COUNT_CODE_OATH)
	e0:SetTarget(c65870035.target0)
	e0:SetOperation(c65870035.operation)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65870035,1))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65870036+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c65870035.drtg)
	e1:SetOperation(c65870035.drop)
	c:RegisterEffect(e1)
end

function c65870035.cfilter(c)
	return c:IsCode(65870015) and c:IsFaceup()
end
function c65870035.excondition(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c65870035.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end

function c65870035.filter(c)
	return c:IsSetCard(0x3a37) and c:IsAbleToHand() and aux.NecroValleyFilter()
end
function c65870035.target0(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c65870035.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c65870035.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c65870035.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end


function c65870035.tdfilter(c,e,tp)
	return c:IsSetCard(0x3a37) and c:IsAbleToDeck()
end
function c65870035.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2)
		and Duel.IsExistingMatchingCard(c65870035.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,5,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,5,tp,LOCATION_GRAVE+LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c65870035.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tg=Duel.SelectMatchingCard(tp,c65870035.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,5,5,e:GetHandler())
	if #tg==0 then return end
	Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct>0 then
		Duel.BreakEffect()
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end