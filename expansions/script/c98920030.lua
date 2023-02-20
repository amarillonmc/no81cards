--凶导枢机 神龙四教导 
function c98920030.initial_effect(c)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,0,98920030)
 --damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920030,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c98920030.condition)
	e2:SetTarget(c98920030.target)
	e2:SetOperation(c98920030.operation)
	c:RegisterEffect(e2)
--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920030,1))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c98920030.con)
	e2:SetTarget(c98920030.target1)
	e2:SetOperation(c98920030.operation1)
	c:RegisterEffect(e2)
end
function c98920030.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst():IsSummonType(SUMMON_TYPE_FUSION) or eg:GetFirst():IsSummonType(SUMMON_TYPE_SYNCHRO) or eg:GetFirst():IsSummonType(SUMMON_TYPE_XYZ) or eg:GetFirst():IsSummonType(SUMMON_TYPE_LINK)
end
function c98920030.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,1-tp,500)
end
function c98920030.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Damage(p,d,REASON_EFFECT)
	end
end
function c98920030.con(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)  
end
function c98920030.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsDisabled() and c:IsSummonLocation(LOCATION_EXTRA)
end
function c98920030.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c98920030.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c98920030.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and e:GetHandler():GetFlagEffect(98920030)==0 end
	e:GetHandler():RegisterFlagEffect(98920030,RESET_CHAIN,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c98920030.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c98920030.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsDisabled() then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		if tc:IsFaceup() and tc:IsLocation(LOCATION_MZONE) and tc:IsControler(tp) then
		   Duel.BreakEffect()
		   Duel.NegateEffect(ev)
		   Duel.Destroy(eg,REASON_EFFECT)
		end 
	end
end