--人理之诗 磔刑之雷树
function c22025110.initial_effect(c)
	aux.AddCodeList(c,3285552)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,22025110+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c22025110.target)
	e1:SetOperation(c22025110.operation)
	c:RegisterEffect(e1)
end
function c22025110.tgfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xff1) and Duel.IsExistingMatchingCard(c22025110.desfilter,tp,0,LOCATION_MZONE,1,nil,c:GetAttack())
end
function c22025110.desfilter(c,atk)
	return c:IsFaceup() and c:IsAttackBelow(atk)
end
function c22025110.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c22025110.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22025110.tgfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c22025110.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	local dg=Duel.GetMatchingGroup(c22025110.desfilter,tp,0,LOCATION_MZONE,nil,g:GetFirst():GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
	if dg:GetCount()~=0 then
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dg:GetCount()*500)
	end
end
function c22025110.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local dg=Duel.GetMatchingGroup(c22025110.desfilter,tp,0,LOCATION_MZONE,nil,tc:GetAttack())
		local ct=Duel.Destroy(dg,REASON_EFFECT)
		Duel.Damage(1-tp,ct*500,REASON_EFFECT)
	end
end
