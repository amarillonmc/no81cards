--飞球之天界
local m=13254046
local cm=_G["c"..m]
xpcall(function() require("expansions/script/tama") end,function() require("script/tama") end)
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(cm.tdcon)
	e2:SetTarget(cm.tdtg)
	e2:SetOperation(cm.tdop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_REMOVE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(cm.tdcon)
	e3:SetTarget(cm.tdtg)
	e3:SetOperation(cm.tdop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_DECKDES)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_TO_DECK)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCondition(cm.tdcon1)
	e4:SetTarget(cm.tdtg1)
	e4:SetOperation(cm.tdop1)
	c:RegisterEffect(e4)
	
end
function cm.tdfilter(c,e)
	return c:IsSetCard(0x356) and c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsAbleToDeck() and (not c:IsReason(REASON_EFFECT) or c:GetReasonEffect():GetHandler()~=e:GetHandler())
end
function cm.tdfilter1(c,e)
	return c:IsSetCard(0x356) and c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsRelateToEffect(e)
end
function cm.tgfilter(c)
	return c:IsSetCard(0x3356) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function cm.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.tdfilter,1,nil,e)
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(cm.tdfilter,nil,e)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,g:GetCount(),nil) end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local ct1=0
	local ct2=0
	local rg=eg:Filter(cm.tdfilter1,nil,e)
	local ct=Duel.SendtoDeck(rg,nil,2,REASON_EFFECT)
	rg=Duel.GetOperatedGroup()
	local tc=rg:GetFirst()
	while tc do
		if tc:IsLocation(LOCATION_DECK) and tc:IsType(TYPE_MONSTER) then
			if tc:GetControler()==tp then ct1=ct1+1
			else ct2=ct2+1 end
		end
		tc=rg:GetNext()
	end
	if ct1>0 then Duel.ShuffleDeck(tp) end
	if ct2>0 then Duel.ShuffleDeck(1-tp) end
	if ct>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,ct,ct,nil)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end

function cm.cfilter(c,e)
	return bit.band(c:GetPreviousLocation(),LOCATION_GRAVE+LOCATION_REMOVED)>0 and c:IsRace(RACE_FAIRY) and c:IsLevelBelow(1) and (not c:IsReason(REASON_EFFECT) or c:GetReasonEffect():GetHandler()~=e:GetHandler())
end
function cm.tdcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,e)
end
function cm.tdtg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=eg:FilterCount(cm.cfilter,nil,e)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,ct,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,ct,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,ct)
end
function cm.tdop1(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)<=0 then return end
	local ct=Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
	Duel.ShuffleDeck(tp)
	if ct>0 then
		Duel.BreakEffect()
		Duel.DiscardDeck(tp,ct,REASON_EFFECT)
	end
end
