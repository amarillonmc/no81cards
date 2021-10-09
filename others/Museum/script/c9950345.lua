--异界女神·纯白之心
function c9950345.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xbc8),2,2)
	c:EnableReviveLimit()
--recover
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950345,0))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,9950345)
	e1:SetTarget(c9950345.rectg)
	e1:SetOperation(c9950345.recop)
	c:RegisterEffect(e1)
 --todeck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9950345,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,99503450)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9950345.tdtg)
	e2:SetOperation(c9950345.tdop)
	c:RegisterEffect(e2)
--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950345.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950345.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950345,0))
end
function c9950345.recfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xbc8) 
end
function c9950345.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950345.recfilter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c9950345.recfilter,tp,LOCATION_MZONE,0,nil)
	local rec=g:GetClassCount(Card.GetCode)*1000
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,1-tp,rec)
end
function c9950345.recop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9950345.recfilter,tp,LOCATION_MZONE,0,nil)
	local rec=g:GetClassCount(Card.GetCode)*1000
	Duel.Recover(tp,rec,REASON_EFFECT)
end 
function c9950345.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c9950345.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)~=0
		and tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then
		if tc:IsLocation(LOCATION_DECK) then Duel.ShuffleDeck(tc:GetControler()) end
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end