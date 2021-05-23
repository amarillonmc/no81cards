--人理之诗 幻想的铁处女
function c22020890.initial_effect(c)
	aux.AddCodeList(c,22020880)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22020890+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c22020890.cost)
	e1:SetTarget(c22020890.target)
	e1:SetOperation(c22020890.operation)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c22020890.condition)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c22020890.target1)
	e2:SetOperation(c22020890.operation1)
	c:RegisterEffect(e2)
end
function c22020890.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SelectOption(tp,aux.Stringid(22020890,0))
end
function c22020890.atkfilter(c)
	return c:IsPosition(POS_FACEUP_ATTACK)
end
function c22020890.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c22020890.atkfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(c22020890.atkfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c22020890.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g2=Duel.SelectTarget(tp,c22020890.atkfilter,tp,0,LOCATION_MZONE,1,1,nil)
	e:SetLabelObject(g2:GetFirst())
end
function c22020890.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()==2 then
		local c1=g:GetFirst()
		local c2=g:GetNext()
		if c1~=e:GetLabelObject() then c1,c2=c2,c1 end
		if c1:IsControler(1-tp) and c2:IsPosition(POS_FACEUP_ATTACK) and not c1:IsImmuneToEffect(e)
			and c2:IsControler(tp) then
			Duel.SelectOption(tp,aux.Stringid(22020890,1))
			Duel.CalculateDamage(c2,c1,true)
			Duel.SelectOption(tp,aux.Stringid(22020890,2))
		end
	end
end
function c22020890.cfilter(c)
	return c:IsFaceup() and c:IsCode(22020880)
end
function c22020890.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22020890.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c22020890.filter(c)
	return c:IsFaceup()
end
function c22020890.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c22020890.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22020890.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c22020890.filter,tp,0,LOCATION_MZONE,1,1,nil)
	local atk=g:GetFirst():GetTextAttack()
	if atk<0 then atk=0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
end
function c22020890.operation1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local atk=tc:GetTextAttack()
		if atk<0 then atk=0 end
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
			Duel.Damage(1-tp,atk,REASON_EFFECT)
		end
	end
end
