--『星光歌剧』台本-命运Revue
function c65010121.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,65010121+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c65010121.condition)
	e1:SetCost(c65010121.cost)
	e1:SetTarget(c65010121.target)
	e1:SetOperation(c65010121.activate)
	c:RegisterEffect(e1)
end
function c65010121.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev) and ep~=tp
end
function c65010121.cfilter(c)
	return c:IsSetCard(0x9da0) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c65010121.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c65010121.cfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c65010121.cfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c65010121.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c65010121.activate(e,tp,eg,ep,ev,re,r,rp)
	local ty=re:GetActiveType()
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetLabel(ty)
			e1:SetTargetRange(0,1)
			e1:SetValue(c65010121.aclimit)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
	end
end
function c65010121.aclimit(e,re,tp)
	return re:GetActiveType()==e:GetLabel()
end
