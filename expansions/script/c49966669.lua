--希腊咖啡
function c49966669.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_COIN)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c49966669.target)
	e1:SetOperation(c49966669.activate)
	c:RegisterEffect(e1)
end
c49966669.toss_coin=true
function c49966669.filter(c)
	return c:IsFaceup() and c:GetBaseAttack()>0
		and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c49966669.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c49966669.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c49966669.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c49966669.filter,tp,0,LOCATION_MZONE,1,1,nil)
	local atk=g:GetFirst():GetBaseAttack()
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,2)
end
function c49966669.activate(e,tp,eg,ep,ev,re,r,rp)
	 local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		 local atk=tc:GetBaseAttack()
		if atk<0 then atk=0 end
		 local c1,c2=Duel.TossCoin(tp,2)
	 if c1+c2==2 then
		Duel.Damage(1-tp,atk+atk,REASON_EFFECT)
	 elseif c1+c2==0 then
		Duel.Damage(tp,atk+atk,REASON_EFFECT)
   elseif c1+c2==1 then
		Duel.Damage(tp,atk,REASON_EFFECT)
		 Duel.Damage(1-tp,atk,REASON_EFFECT)
	end
end
end