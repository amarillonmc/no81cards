--联协神 绝对武装·盖亚意志
function c62501546.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(c62501546.splimit)
	c:RegisterEffect(e0)
	--unique
	c:SetUniqueOnField(1,0,c62501546.uqfilter,LOCATION_MZONE)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c62501546.imcon)
	e1:SetValue(c62501546.efilter)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(62501546,0))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c62501546.imcon)
	e2:SetTarget(c62501546.distg)
	e2:SetOperation(c62501546.disop)
	c:RegisterEffect(e2)
	--to hand&deck
	local e3=Effect.CreateEffect(c)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)--
	e3:SetDescription(aux.Stringid(62501546,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,62501546)
	e3:SetCost(c62501546.tdcost)
	e3:SetTarget(c62501546.tdtg)
	e3:SetOperation(c62501546.tdop)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(62501546,2))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,62501546+1)
	e4:SetCost(c62501546.ovcost)
	e4:SetTarget(c62501546.ovtg)
	e4:SetOperation(c62501546.ovop)
	c:RegisterEffect(e4)
end
function c62501546.splimit(e,se,sp,st)
	local sc=se:GetHandler()
	return sc and sc:IsSetCard(0xea3)
end
function c62501546.uqfilter(c)
	return c:IsCode(62501546) or c:IsNonAttribute(ATTRIBUTE_LIGHT)
end
function c62501546.imcon(e)
	local g=e:GetHandler():GetOverlayGroup():Filter(Card.IsSetCard,nil,0xea3)
	return g:Filter(Card.IsType,nil,TYPE_XYZ):GetClassCount(Card.GetCode)>=3 and g:Filter(Card.IsType,nil,TYPE_EQUIP):GetClassCount(Card.GetCode)>=3
end
function c62501546.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c62501546.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c62501546.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if Duel.NegateEffect(ev) and c:IsRelateToEffect(e) and rc:IsRelateToEffect(re) and rc:IsCanOverlay() and c:IsType(TYPE_XYZ) then
		rc:CancelToGrave()
		Duel.Overlay(c,Group.FromCards(rc))
	end
end
function c62501546.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,3,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,3,3,REASON_COST)
end
function c62501546.tdfilter(c)
	return (not (c:IsSetCard(0xea3) and c:IsLocation(LOCATION_MZONE)) or c:IsFacedown()) and c:IsAbleToHand()
end
function c62501546.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(c62501546.tdfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0x30,0x30,nil)
	if chk==0 then return #g1>0 and #g2>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,#g1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g2,#g2,0,0)
end
function c62501546.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c62501546.tdfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if Duel.SendtoHand(g1,nil,REASON_EFFECT)==0 or g1:FilterCount(Card.IsLocation,nil,LOCATION_HAND)==0 then return end
	local g2=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0x30,0x30,nil)
	Duel.SendtoDeck(g2,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
function c62501546.chkfilter(c)
	return c:IsSetCard(0xea3) and c:IsRank(6) and c.third_effect
end
function c62501546.ovcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c62501546.chkfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc=Duel.SelectMatchingCard(tp,c62501546.chkfilter,tp,LOCATION_EXTRA,0,1,1,nil):GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	e:SetLabelObject(tc.third_effect)
end
function c62501546.ofilter(c,e)
	return c:IsSetCard(0xea3) and c:IsCanOverlay() and (not e or not c:IsImmuneToEffect(e))
end
function c62501546.ovtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsCostChecked() and e:GetHandler():IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(c62501546.ofilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
end
function c62501546.ovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,c62501546.ofilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e)
		if #g==0 then return end
		Duel.Overlay(c,g)
		Duel.BreakEffect()
		local te=e:GetLabelObject():Clone()
		te:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		c:RegisterEffect(te)
	end
end
