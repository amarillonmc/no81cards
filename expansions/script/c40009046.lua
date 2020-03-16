--伏魔忍妖 深夜火车
function c40009046.initial_effect(c)
	c:EnableReviveLimit()
	--xyz summon
	aux.AddXyzProcedure(c,nil,10,3,c40009046.ovfilter,aux.Stringid(40009046,0),2,c40009046.xyzop)
	--Back to Deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40009046,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(c40009046.tdcost)
	e2:SetTarget(c40009046.tdtg)
	e2:SetOperation(c40009046.tdop)
	c:RegisterEffect(e2)	
end
function c40009046.ovfilter(c)
	return c:IsFaceup() and c:IsXyzType(TYPE_XYZ) and c:IsSetCard(0x2b)
end
function c40009046.cfilter1(c,tp)
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x2b) and c:IsCanOverlay()
		and Duel.IsExistingMatchingCard(c40009046.cfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,c,c)
end
function c40009046.cfilter2(c)
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsSetCard(0x61) and c:IsCanOverlay()
end
function c40009046.xyzop(e,tp,chk,mc)
	if chk==0 then return Duel.IsExistingMatchingCard(c40009046.cfilter1,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,tp) and Duel.GetFlagEffect(tp,40009046)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c40009046.cfilter1,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,tp)
	local cc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,c40009046.cfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,cc,cc)
	g1:Merge(g2)
	if g1:GetCount()>0 then
		Duel.Overlay(mc,g1)
	end
	Duel.RegisterFlagEffect(tp,40009046,RESET_PHASE+PHASE_END,0,1)
end
function c40009046.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c40009046.tdfilter(c)
	return c:IsFaceup() and c:IsAbleToDeck()
end
function c40009046.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c40009046.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c40009046.tdfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c40009046.tdfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c40009046.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end