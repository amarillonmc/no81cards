--寻血者Elise
function c33740040.initial_effect(c)
	aux.EnableDualAttribute(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33740040,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c33740040.atkcon)
	e1:SetTarget(c33740040.atktg)
	e1:SetOperation(c33740040.atkop)
	c:RegisterEffect(e1)
end
function c33740040.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return e:GetHandler():IsDualState() and (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
end
function c33740040.tfilter(c)
	return (c:IsAttackAbove(1) or c:IsDefenseAbove(1)) and c:IsFaceupEx()
end
function c33740040.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and c33740040.tfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c33740040.tfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c33740040.tfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil)
end
function c33740040.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToChain() and tc:IsFaceupEx() and c:IsRelateToChain() and c:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		--e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetValue(tc:GetAttack())
		--e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_DISABLE,2)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(tc:GetDefense())
		c:RegisterEffect(e2)
		if Duel.SelectOption(1-tp,aux.Stringid(33740040,0),aux.Stringid(33740040,1))==1 then return end
		c:CopyEffect(tc:GetOriginalCodeRule(),RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
		Duel.Recover(tp,c:GetDefense(),REASON_EFFECT,true)
		Duel.Recover(1-tp,c:GetDefense(),REASON_EFFECT,true)
		Duel.RDComplete()
	end
end
