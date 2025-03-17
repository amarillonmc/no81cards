--波动·宇宙共振
function c10200027.initial_effect(c)
	-- Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetTarget(c10200027.tg1)
	e1:SetOperation(c10200027.op1)
	c:RegisterEffect(e1)
end
function c10200027.filter1(c)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
end
function c10200027.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c10200027.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10200027.filter1,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c10200027.filter1,tp,LOCATION_MZONE,0,1,1,nil)
end
function c10200027.same_check(c,mc)
	local flag=0
	if c:GetRace()==mc:GetRace() then flag=flag+1 end
	if c:GetAttribute()==mc:GetAttribute() then flag=flag+1 end
	if c:GetLevel()==mc:GetLevel() then flag=flag+1 end
	if c:GetTextAttack()==mc:GetTextAttack() then flag=flag+1 end
	if c:GetTextDefense()==mc:GetTextDefense() then flag=flag+1 end
	return flag > 0
end
function c10200027.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c10200027.same_check,tp,LOCATION_MZONE,LOCATION_MZONE,tc,tc)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end