--幻影叛逆超量龙
function c40009284.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),3,2)
	c:EnableReviveLimit()  
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009284,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCountLimit(1)
	e1:SetCondition(aux.dscon)
	e1:SetCost(c40009284.atkcost1)
	e1:SetTarget(c40009284.atktg1)
	e1:SetOperation(c40009284.atkop1)
	c:RegisterEffect(e1)  
	--atk down
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40009284,2))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,40009284)
	e2:SetCondition(c40009284.atkcon)
	e2:SetOperation(c40009284.atkop2)
	c:RegisterEffect(e2)
end
function c40009284.atkcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c40009284.atktg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and aux.nzatk(chkc) end
	if chk==0 then return Duel.IsExistingTarget(aux.nzatk,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,aux.nzatk,tp,0,LOCATION_MZONE,1,1,nil)
end
function c40009284.atkop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local atk=tc:GetAttack()
		if Duel.SelectYesNo(tp,aux.Stringid(40009284,1)) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetValue(math.ceil(atk/2))
			tc:RegisterEffect(e1)
		else
		if c:IsRelateToEffect(e) and c:IsFaceup() then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e2:SetValue(math.ceil(atk/2))
			c:RegisterEffect(e2)
			end
		end
	end
end
function c40009284.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetAttack()>0 and e:GetHandler():GetOverlayCount()~=0
end
function c40009284.atkop2(e,tp,eg,ep,ev,re,r,rp)
	local dg=Group.CreateGroup()
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
	local atk=c:GetAttack()
	local sc=g:GetFirst()
		while sc do
			local preatk=sc:GetAttack()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetValue(-atk)
			sc:RegisterEffect(e1)
			if preatk~=0 and sc:IsAttack(0) then dg:AddCard(sc) end
			sc=g:GetNext()
		end
		Duel.Destroy(dg,REASON_EFFECT)
		if c:IsRelateToEffect(e) then
			Duel.BreakEffect()
			if Duel.Remove(c,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
				e2:SetCountLimit(1)
				e2:SetLabel(Duel.GetTurnCount())
				e2:SetLabelObject(c)
				e2:SetCondition(c40009284.retcon)
				e2:SetOperation(c40009284.retop)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
				Duel.RegisterEffect(e2,tp)
			end
		end
	end
end
function c40009284.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()>e:GetLabel()
end
function c40009284.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end





