--蒙昧神迹-洪流的脉动
function c9911111.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--tribute summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9911111,0))
	e2:SetCategory(CATEGORY_RECOVER+CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,9911111)
	e2:SetTarget(c9911111.sumtg)
	e2:SetOperation(c9911111.sumop)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9911111,1))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,9911112)
	e3:SetCondition(c9911111.drcon)
	e3:SetTarget(c9911111.drtg)
	e3:SetOperation(c9911111.drop)
	c:RegisterEffect(e3)
end
function c9911111.sumfilter(c)
	return c:IsSetCard(0xa954) and c:IsSummonable(true,nil,1)
end
function c9911111.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911111.sumfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,400)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c9911111.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Recover(tp,400,REASON_EFFECT)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c9911111.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil,1)
	end
end
function c9911111.cfilter0(c,tp)
	return c:IsSummonPlayer(tp) and c:IsSummonType(SUMMON_TYPE_ADVANCE)
end
function c9911111.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9911111.cfilter0,1,nil,tp)
end
function c9911111.cfilter(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsType(TYPE_NORMAL)
end
function c9911111.tdfilter(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsSetCard(0xa954) and c:IsAbleToDeck()
end
function c9911111.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local sc=Duel.GetMatchingGroupCount(c9911111.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c9911111.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9911111.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c9911111.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,sc+2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c9911111.drop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		local ct=Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		local g=Duel.GetOperatedGroup()
		if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
		local ht=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
		if ct>0 and ht<ct and Duel.IsPlayerCanDraw(tp,ct-ht) and Duel.SelectYesNo(tp,aux.Stringid(9911111,2)) then
			Duel.Draw(tp,ct-ht,REASON_EFFECT)
		end
	end
end
