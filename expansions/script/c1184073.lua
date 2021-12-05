--饮食艺术·肉桂卷
function c1184073.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1184073,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c1184073.tg1)
	e1:SetOperation(c1184073.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1184073,1))
	e2:SetCategory(CATEGORY_LEAVE_GRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c1184073.cost2)
	e2:SetTarget(c1184073.tg2)
	e2:SetOperation(c1184073.op2)
	c:RegisterEffect(e2)
--
end
--
function c1184073.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsFacedown() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFacedown,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	Duel.SelectTarget(tp,Card.IsFacedown,tp,0,LOCATION_ONFIELD,1,1,nil)
end
function c1184073.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local e1_1=Effect.CreateEffect(e:GetHandler())
		e1_1:SetType(EFFECT_TYPE_SINGLE)
		e1_1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1_1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
		e1_1:SetRange(LOCATION_ONFIELD)
		e1_1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1_1,true)
	end
end
--
function c1184073.cfilter2(c,tc)
	return bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0
		and c:IsSetCard(0x3e12)
		and c:IsAbleToDeckAsCost() and c:IsFaceup()
		and (tc:IsSSetable() or c:IsLocation(LOCATION_SZONE))
end
function c1184073.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c1184073.cfilter2,tp,LOCATION_ONFIELD,0,1,nil,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=Duel.SelectMatchingCard(tp,c1184073.cfilter2,tp,LOCATION_ONFIELD,0,1,1,nil,c)
	Duel.SendtoDeck(sg,nil,2,REASON_COST)
end
function c1184073.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsSSetable()
		or (c:IsSSetable(false) and Duel.IsExistingMatchingCard(c1184073.cfilter2,tp,LOCATION_SZONE,0,1,nil)) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c1184073.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsSSetable() and c:IsRelateToEffect(e) then Duel.SSet(tp,c) end
end
--