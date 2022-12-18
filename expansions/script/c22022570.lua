--人理之基 陈宫
function c22022570.initial_effect(c)
	aux.AddCodeList(c,22022540)
	--act limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c22022570.limval)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22022570,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,22022570)
	e2:SetTarget(c22022570.target)
	e2:SetOperation(c22022570.operation)
	c:RegisterEffect(e2)
end
function c22022570.limval(e,re,rp)
	local rc=re:GetHandler()
	return rc:IsLocation(LOCATION_MZONE) and re:IsActiveType(TYPE_MONSTER) and rc:IsCode(22022540)
end
function c22022570.filter(c,tp)
	return c:IsFaceup() and (c:IsSetCard(0x2ff1) and not c:IsCode(22022570))
		and Duel.IsExistingMatchingCard(c22022570.filter2,tp,0,LOCATION_MZONE,1,nil,c:GetAttack())
end
function c22022570.filter2(c,atk)
	return c:IsFaceup() and c:IsAttackBelow(atk)
end
function c22022570.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c22022570.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c22022570.filter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectOption(tp,aux.Stringid(22022570,1))
	local g=Duel.SelectTarget(tp,c22022570.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	local dg=Duel.GetMatchingGroup(c22022570.filter2,tp,0,LOCATION_MZONE,nil,g:GetFirst():GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dg:GetCount()*500)
end
function c22022570.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local g=Duel.GetMatchingGroup(c22022570.filter2,tp,0,LOCATION_MZONE,nil,tc:GetAttack())
		Duel.SelectOption(tp,aux.Stringid(22022570,2))
		if g:GetCount()==0 then return end
		local oc=Duel.Destroy(g,REASON_EFFECT)
		if oc>0 then Duel.Damage(1-tp,oc*500,REASON_EFFECT) end
	end
	Duel.BreakEffect()
	Duel.SelectOption(tp,aux.Stringid(22022570,3))
	Duel.SendtoGrave(tc,REASON_RULE)
end