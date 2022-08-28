--拉菲改
function c25800005.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,25800104,aux.FilterBoolFunction(Card.IsFusionSetCard,0x6211),1,false,false)

	 local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(25800005,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c25800005.settg)
	e1:SetOperation(c25800005.setop)
	c:RegisterEffect(e1)
end
function c25800005.setfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c25800005.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c25800005.setfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c25800005.setfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c25800005.setfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c25800005.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
end