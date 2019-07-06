--绝命时刻
function c33700146.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,33700146+EFFECT_COUNT_CODE_OATH)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,0x1e0)
	e1:SetTarget(c33700146.target)
	e1:SetOperation(c33700146.activate)
	c:RegisterEffect(e1)
end
function c33700146.filter(c)
	return c:IsFaceup() and c:IsPosition(POS_ATTACK)
end
function c33700146.filter2(c,def)
	return c:IsFaceup() and c:IsPosition(POS_ATTACK) and c:GetAttack()<def
end
function c33700146.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	 local g=Duel.GetMatchingGroup(c33700146.filter,tp,LOCATION_MZONE,0,nil)
	local tg=g:GetMaxGroup(Card.GetDefense)
	if chkc then return c33700146.filter(chkc) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and tg:IsContains(chkc) end
	if chk==0 then return tg:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g1=tg:Select(tp,1,1,nil)
	 local g2=Duel.GetMatchingGroup(c33700146.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,g1:GetDefense())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g2,g2:GetCount(),0,0)
end
function c33700146.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	  local g=Duel.GetMatchingGroup(c33700146.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tc:GetDefense())
   if g:GetCount()>0 then
	Duel.Destroy(g,REASON_EFFECT)
	end
end
end