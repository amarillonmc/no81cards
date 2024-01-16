--Kamipro 孔明
function c50213185.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c50213185.xcheck,6,2,c50213185.ovfilter,aux.Stringid(50213185,0),2,c50213185.xyzop)
	c:EnableReviveLimit()
	--attribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(ATTRIBUTE_ALL-ATTRIBUTE_DIVINE-ATTRIBUTE_DARK)
	e1:SetCondition(c50213185.attcon)
	c:RegisterEffect(e1)
	--effect indes
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e11:SetCondition(c50213185.attcon)
	e11:SetValue(1)
	c:RegisterEffect(e11)
	--chainlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c50213185.chaincon)
	e2:SetOperation(c50213185.chainop)
	c:RegisterEffect(e2)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,50213185)
	e3:SetCost(c50213185.discost)
	e3:SetTarget(c50213185.distg)
	e3:SetOperation(c50213185.disop)
	c:RegisterEffect(e3)
	--counter
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c50213185.ctcon)
	e4:SetTarget(c50213185.cttg)
	e4:SetOperation(c50213185.ctop)
	c:RegisterEffect(e4)
end
function c50213185.xcheck(c)
	return c:IsSetCard(0xcbf)
end
function c50213185.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xcbf) and c:IsRank(4)
end
function c50213185.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,50213185)==0 end
	Duel.RegisterFlagEffect(tp,50213185,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c50213185.attcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipCount()>0
end
function c50213185.chaincon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()>0
end
function c50213185.chainop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if not re:IsActiveType(TYPE_MONSTER) or not rc:IsSetCard(0xcbf) then return false end
	Duel.SetChainLimit(c50213185.chainlm)
end
function c50213185.chainlm(e,rp,tp)
	return tp==rp
end
function c50213185.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c50213185.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and (c:GetAttack()>0 or aux.NegateEffectMonsterFilter(c))
end
function c50213185.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c50213185.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c50213185.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	Duel.SelectTarget(tp,c50213185.filter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c50213185.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_UPDATE_ATTACK)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e3:SetValue(-2000)
		tc:RegisterEffect(e3)
	end
end
function c50213185.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattledGroupCount()>0
end
function c50213185.ctfilter(c)
	return c:IsFaceup() and c:IsCanAddCounter(0xcbf,5)
end
function c50213185.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c50213185.ctfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c50213185.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c50213185.ctfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		tc:AddCounter(0xcbf,5)
	end
end