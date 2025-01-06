--悪虫瘤－鑽孔龍
function c49811380.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,7,3)
	c:EnableReviveLimit()
	--negate chain
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(49811380,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c49811380.necon)
	e1:SetCost(c49811380.necost)
	e1:SetTarget(c49811380.netg)
	e1:SetOperation(c49811380.neop)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(49811380,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,49811380)
	e2:SetCondition(c49811380.tdcon)
	e2:SetTarget(c49811380.tdtg)
	e2:SetOperation(c49811380.tdop)
	c:RegisterEffect(e2)
end
function c49811380.necon(e,tp,eg,ep,ev,re,r,rp)
	local attr=re:GetHandler():GetAttribute()
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and re:GetActivateLocation()==LOCATION_MZONE and Duel.IsChainNegatable(ev)
end

function c49811380.necost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local attr=re:GetHandler():GetAttribute()
	if chk==0 then return Duel.IsExistingMatchingCard(c49811380.nefilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,c,attr) end
	e:SetLabel(attr)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetLabel(attr)
	e1:SetOperation(c49811380.chainop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c49811380.chainlm(e,c,tp,r,re)
	return not (e:GetHandler():IsCode(49811380) and e and e:IsActiveType(TYPE_MONSTER) and e:GetHandler():GetLocation()==LOCATION_MZONE)
end
function c49811380.chainop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsAttribute(e:GetLabel()) then
		Duel.SetChainLimit(c49811380.chainlm)
	end
end
function c49811380.netg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end	
	local tc=re:GetHandler()
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if Duel.IsPlayerCanSendtoDeck(tp,tc) and tc:IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	end	
end
function c49811380.nefilter(c,sc,attr)
	return c:IsRace(RACE_DRAGON) and (c:IsFaceup() or c:GetLocation()&(LOCATION_GRAVE+LOCATION_HAND)~=0) and c:IsCanBeXyzMaterial(sc) and c:IsAttribute(attr)
end
function c49811380.neop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local attr=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,c49811380.nefilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,c,attr)
	Duel.Overlay(c,g)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.SendtoDeck(eg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
function c49811380.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD)
		and c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp
end
function c49811380.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_ONFIELD)
end
function c49811380.setfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_QUICKPLAY) and c:IsSSetable()
end
function c49811380.setfilter2(c,att)
	return c:IsAttribute(att)
end
function c49811380.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()==0 then return end
	if Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c49811380.setfilter),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_DECK,0,1,nil) 
		and Duel.IsExistingMatchingCard(c49811380.setfilter2,tp,LOCATION_GRAVE,0,1,nil,ATTRIBUTE_WIND)
		and Duel.IsExistingMatchingCard(c49811380.setfilter2,tp,LOCATION_GRAVE,0,1,nil,ATTRIBUTE_WATER)
		and Duel.IsExistingMatchingCard(c49811380.setfilter2,tp,LOCATION_GRAVE,0,1,nil,ATTRIBUTE_FIRE)
		and Duel.IsExistingMatchingCard(c49811380.setfilter2,tp,LOCATION_GRAVE,0,1,nil,ATTRIBUTE_EARTH) 
		and Duel.SelectYesNo(tp,aux.Stringid(49811380,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local sc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c49811380.setfilter),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_DECK,0,1,1,nil):GetFirst()
			Duel.SSet(tp,sc,tp,true)
	end
end