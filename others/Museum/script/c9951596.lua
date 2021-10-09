--暗黑界的混沌王 卡拉雷斯
function c9951596.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,99458769,aux.FilterBoolFunction(Card.IsFusionSetCard,0x6),2,true,true)
	aux.AddContactFusionProcedure(c,c9951596.cfilter,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,0,aux.tdcfop(c)):SetValue(1)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c9951596.splimit)
	c:RegisterEffect(e1)
 --return
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c9951596.rettg)
	e2:SetOperation(c9951596.retop)
	c:RegisterEffect(e2)
end
function c9951596.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c9951596.cfilter(c)
	return (c:IsFusionCode(99458769) or c:IsFusionSetCard(0x6) and c:IsType(TYPE_MONSTER))
		and c:IsAbleToDeckOrExtraAsCost()
end
function c9951596.retfilter1(c)
	return c:IsSetCard(0x6) and c:IsAbleToDeck()
end
function c9951596.retfilter2(c)
	return c:IsAbleToHand()
end
function c9951596.rettg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c9951596.retfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,nil)
		and Duel.IsExistingTarget(c9951596.retfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectTarget(tp,c9951596.retfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,2,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g2=Duel.SelectTarget(tp,c9951596.retfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,g1:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g2,1,0,0)
end
function c9951596.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local g1=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	if Duel.SendtoDeck(g1,nil,0,REASON_EFFECT)~=0 then
		local og=Duel.GetOperatedGroup()
		if og:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
		local g2=g:Filter(Card.IsLocation,nil,LOCATION_ONFIELD)
		Duel.SendtoHand(g2,nil,REASON_EFFECT)
	end
end