--URBEX HINDER-祈灵者
function c65010517.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,99,c65010517.lcheck)
	c:EnableReviveLimit()
	--yazhi
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,65010517)
	e1:SetCondition(c65010517.con)
	e1:SetOperation(c65010517.op)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,65010518)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCondition(c65010517.condition)
	e2:SetTarget(c65010517.target)
	e2:SetOperation(c65010517.operation)
	c:RegisterEffect(e2)
end
c65010517.setname="URBEX"
function c65010517.lcfil(c)
	return c.setname=="URBEX"
end
function c65010517.lcheck(g)
	return g:IsExists(c65010517.lcfil,1,nil) 
end

function c65010517.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev) and rp~=tp
end
function c65010517.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c65010517.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,nil)
	if Duel.IsChainDisablable(0) and g:GetCount()>3
		and Duel.SelectYesNo(1-tp,aux.Stringid(65010517,0)) then
		local sg=g:RandomSelect(1-tp,4)
		Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
		Duel.NegateEffect(0)
		return
	end
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end

function c65010517.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c65010517.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(65010517,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	--activate cost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_ACTIVATE_COST)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetLabelObject(c)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetCost(c65010517.costchk)
	e2:SetOperation(c65010517.costop)
	Duel.RegisterEffect(e2,tp)
	--accumulate
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(0x10000000+65010517)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetReset(RESET_PHASE+PHASE_END)
	e7:SetTargetRange(0,1)
	Duel.RegisterEffect(e7,tp)
end
function c65010517.costchk(e,te_or_c,tp)
	local tc=e:GetLabelObject()
	local ct=Duel.GetFlagEffect(tp,65010517)
	local g=Duel.GetDecktopGroup(tp,ct*4)
	return g:FilterCount(Card.IsAbleToRemoveAsCost,nil)==ct*4 and tc:GetFlagEffect(65010517)~=0 and tc:IsLocation(LOCATION_MZONE)
end
function c65010517.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,65010517)
	local g=Duel.GetDecktopGroup(tp,4)
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end