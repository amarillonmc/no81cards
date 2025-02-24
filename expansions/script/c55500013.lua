--雄辩者的咒言
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,55500000)
	--level up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.condition)
	e1:SetCost(s.cost)
	e1:SetTarget(s.lvtg)
	e1:SetOperation(s.lvop)
	c:RegisterEffect(e1)
	--to deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,id+1)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetTarget(s.e3tg)
	e3:SetOperation(s.e3op)
	c:RegisterEffect(e3)
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_ONFIELD,0,1,nil,55500000)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x189c,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x189c,2,REASON_COST)
end
function s.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_HAND,1,nil) end
end
function s.upfilter(c)
	return c:IsCode(55500000) and c:IsFaceup()
end
function s.lvop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()>0 then
		Duel.ConfirmCards(tp,g)
		if Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_HAND,1,nil,TYPE_MONSTER) and Duel.IsExistingMatchingCard(s.upfilter,tp,LOCATION_ONFIELD,0,1,nil) then
			local tc=Duel.SelectMatchingCard(tp,s.upfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp):GetFirst()
			tc:AddCounter(0x189c,math.ceil(g:GetCount()/2))
		end
		Duel.ShuffleHand(1-tp)
	end
	local ct=Duel.GetCurrentChain()
	if ct<2 then return end
	local te,tep=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	if tep==1-tp then
		Duel.NegateEffect(ct-1)
	end
end


function s.tdfilter(c)
	return aux.IsCodeListed(c,55500000) and c:IsAbleToDeck()
end
function s.e3tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and s.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.tdfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,2,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,s.tdfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,2,2,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
end
function s.e3op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		sg:AddCard(e:GetHandler())
		aux.PlaceCardsOnDeckBottom(tp,sg,REASON_EFFECT)
	end
end