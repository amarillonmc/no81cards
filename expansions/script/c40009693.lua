--柩机之姬 娜比雷姆
function c40009693.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x1f17),6,2)
	c:EnableReviveLimit() 
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009693,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c40009693.cost)
	e1:SetTarget(c40009693.tg)
	e1:SetOperation(c40009693.op)
	c:RegisterEffect(e1) 
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetCondition(c40009693.imcon)
	e2:SetValue(c40009693.efilter)
	c:RegisterEffect(e2) 
	--negate
	local e3=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009693,3))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c40009693.discon)
	e3:SetCost(c40009693.discost)
	e3:SetTarget(c40009693.distg)
	e3:SetOperation(c40009693.disop)
	c:RegisterEffect(e3) 
end
function c40009693.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c40009693.filter(c,e,tp)
	return (c:IsCode(18161786) or c:IsSetCard(0x1f17)) and c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c40009693.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40009693.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
end
function c40009693.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(40009693,1))
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c40009693.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		local te=tc:GetActivateEffect()
		if Duel.SelectYesNo(tp,aux.Stringid(40009693,2)) then
			local fc1=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			if fc1 then
				Duel.SendtoGrave(fc1,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		else
			local fc2=Duel.GetFieldCard(tp,0,LOCATION_FZONE)
			if fc2 then
				Duel.SendtoGrave(fc2,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,1-tp,1-tp,LOCATION_FZONE,POS_FACEUP,true)
		end
		local te=tc:GetActivateEffect()
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
	end
end
function c40009693.imcon(e)
	return e:GetHandler():GetOverlayCount()>0
end
function c40009693.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c40009693.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c40009693.cfilter(c,ft,tp)
	return c:IsCode(40009699)
		and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5)) and (c:IsControler(tp) or c:IsFaceup())
end
function c40009693.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.CheckReleaseGroup(tp,c40009693.cfilter,1,nil,ft,tp) end
	local g=Duel.SelectReleaseGroup(tp,c40009693.cfilter,1,1,nil,ft,tp)
	Duel.Release(g,REASON_COST)
end
function c40009693.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c40009693.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end


