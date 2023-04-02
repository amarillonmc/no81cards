--永夏的倾覆
require("expansions/script/c9910950")
function c9910971.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9910971)
	e1:SetTarget(c9910971.target)
	e1:SetOperation(c9910971.activate)
	c:RegisterEffect(e1)
	--position
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910971,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,9910982)
	e2:SetCondition(c9910971.poscon)
	e2:SetTarget(c9910971.postg)
	e2:SetOperation(c9910971.posop)
	c:RegisterEffect(e2)
end
function c9910971.tgfilter(c)
	return c:IsSetCard(0x5954) and c:IsAbleToGrave() and not c:IsCode(9910971)
end
function c9910971.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910971.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c9910971.activate(e,tp,eg,ep,ev,re,r,rp)
	local res=false
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9910971.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		res=Duel.SendtoGrave(g,REASON_EFFECT)>0
	end
	QutryYx.ExtraEffectSelect(e,tp,res)
end
function c9910971.remfilter(c)
	return not c:IsType(TYPE_TOKEN)
end
function c9910971.poscon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9910971.remfilter,1,nil)
end
function c9910971.posfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c9910971.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(QutryYx.Filter0,tp,LOCATION_REMOVED,0,1,nil)
		and Duel.IsExistingMatchingCard(c9910971.posfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,1-tp,LOCATION_MZONE)
end
function c9910971.posop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c9910971.posfilter,tp,0,LOCATION_MZONE,nil)
	if ct==0 then return end
	if ct>3 then ct=3 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,QutryYx.Filter0,tp,LOCATION_REMOVED,0,1,ct,nil)
	if #g==0 then return end
	local oct=Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
	if oct==0 then return end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local sg=Duel.SelectMatchingCard(tp,c9910971.posfilter,tp,0,LOCATION_MZONE,oct,oct,nil)
	if #sg>0 then
		Duel.HintSelection(sg)
		Duel.ChangePosition(sg,POS_FACEDOWN_DEFENSE)
	end
end
