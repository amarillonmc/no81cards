--狂乱乐士 狂邪
function c19209726.initial_effect(c)
	--fusion material
	aux.AddFusionProcFunRep(c,c19209726.mfilter,2,true)
	c:EnableReviveLimit()
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(19209726,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c19209726.atkcon)
	e1:SetOperation(c19209726.atkop)
	c:RegisterEffect(e1)
	--select
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetCondition(c19209726.condition)
	e2:SetTarget(c19209726.target)
	e2:SetOperation(c19209726.operation)
	c:RegisterEffect(e2)
end
function c19209726.mfilter(c)
	return c:IsFusionSetCard(0xb53) and not c:IsFusionType(TYPE_FUSION+TYPE_LINK)
end
function c19209726.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c==Duel.GetAttacker() or c==Duel.GetAttackTarget()
end
function c19209726.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local _,atk=g:GetMaxGroup(Card.GetAttack)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end
function c19209726.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>=2
end
function c19209726.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	local op=aux.SelectFromOptions(tp,
		{true,aux.Stringid(19209726,0)},
		{true,aux.Stringid(19209726,1)})
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_ATKCHANGE)
	else
		e:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DESTROY)
	end
end
function c19209726.desfilter(c)
	return c:IsFaceup() and c:IsAttack(0)
end
function c19209726.operation(e,tp,eg,ep,ev,re,r,rp)
	local atk=e:GetLabel()==1 and 1400 or -1000
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
	if tc then
		Duel.HintSelection(Group.FromCards(tc))
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local g=e:GetLabel()==2 and Duel.GetMatchingGroup(c19209726.desfilter,tp,0,LOCATION_MZONE,nil) or Group.CreateGroup()
		if not tc:IsStatus(STATUS_BATTLE_DESTROYED) and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(19209726,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sc=g:Select(tp,1,1,nil):GetFirst()
			Duel.HintSelection(Group.FromCards(sc))
			Duel.Destroy(sc,REASON_EFFECT)
		end
	end
end
