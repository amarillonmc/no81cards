--混沌病毒-光子龙
function c49951006.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c49951006.mfilter,c49951006.xyzcheck,2,2)  
	  --rankup
   local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UPDATE_RANK)
	e4:SetValue(c49951006.rkval)
	c:RegisterEffect(e4)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_SET_ATTACK)
	e2:SetValue(c49951006.value)
	c:RegisterEffect(e2)
	 --atk down
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(49951006,0))
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_REMOVE+CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,49951006)
	e3:SetCondition(aux.dscon)
	e3:SetTarget(c49951006.atktg)
	e3:SetOperation(c49951006.atkop2)
	c:RegisterEffect(e3)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(49951006,1))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,499510015)
	e1:SetCondition(c49951006.negcon)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(c49951006.negtg)
	e1:SetOperation(c49951006.negop)
	c:RegisterEffect(e1)
end
function c49951006.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_XYZ) and not c:IsSetCard(0x48)
end
function c49951006.xyzcheck(g)
	return g:GetClassCount(Card.GetRank)==1
end
function c49951006.rkval(e,c)
	local g=e:GetHandler():GetOverlayGroup()
	return g:GetSum(Card.GetRank)
end
function c49951006.value(e,c)
	return c:GetRank()*1000
end
function c49951006.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return e:GetHandler():IsAbleToRemove() and e:GetHandler():GetAttack()>0
		and Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
function c49951006.atkop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and c:IsFaceup() then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		Duel.AdjustInstantly(tc)
		local atk=c:GetAttack()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		if c:IsRelateToEffect(e) and not tc:IsHasEffect(EFFECT_REVERSE_UPDATE) then
			Duel.BreakEffect()
			if Duel.Remove(c,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
				e2:SetCountLimit(1)
				e2:SetLabel(Duel.GetTurnCount())
				e2:SetLabelObject(c)
				e2:SetCondition(c49951006.retcon)
				e2:SetOperation(c49951006.retop)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
				Duel.RegisterEffect(e2,tp)
			end
		end
	end
end
function c49951006.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()>e:GetLabel()
end
function c49951006.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function c49951006.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c49951006.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c49951006.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
