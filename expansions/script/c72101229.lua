--深空的普雷斯堡和约
function c72101229.initial_effect(c)

	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c72101229.condition)
	e1:SetCost(c72101229.cost)
	e1:SetTarget(c72101229.target)
	e1:SetOperation(c72101229.activate)
	c:RegisterEffect(e1)

end

--Activate
function c72101229.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>=2
end
function c72101229.costfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and c:IsAttribute(ATTRIBUTE_DIVINE) and c:IsLevel(10) and c:IsSetCard(0xcea)
	and c:IsAbleToRemoveAsCost() and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c72101229.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c72101229.costfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c72101229.costfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if Duel.Remove(g,0,REASON_COST+REASON_TEMPORARY)~=0 then
		local rc=g:GetFirst()
		if rc:IsType(TYPE_TOKEN) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(rc)
		e1:SetCountLimit(1)
		e1:SetOperation(c72101229.retop)
		Duel.RegisterEffect(e1,tp)
	end
end

function c72101229.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function c72101229.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ng=Group.CreateGroup()
	local dg=Group.CreateGroup()
	for i=1,ev do
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		if te:IsHasType(EFFECT_TYPE_ACTIVATE) or te:IsActiveType(TYPE_MONSTER) then
			local tc=te:GetHandler()
			ng:AddCard(tc)
			if tc:IsRelateToEffect(te) then
				dg:AddCard(tc)
			end
		end
	end
	Duel.SetTargetCard(dg)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,ng,ng:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
end
function c72101229.activate(e,tp,eg,ep,ev,re,r,rp)
	local dg=Group.CreateGroup()
	for i=1,ev do
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		local tc=te:GetHandler()
		if (te:IsHasType(EFFECT_TYPE_ACTIVATE) or te:IsActiveType(TYPE_MONSTER))
			and Duel.NegateActivation(i) and tc:IsRelateToEffect(e) and tc:IsRelateToEffect(te) then
			dg:AddCard(tc)
		end
	end
	if Duel.IsExistingMatchingCard(c72101229.czfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil) and Duel.Destroy(dg,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		local mc=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)
		if #mc>0 and Duel.SelectOption(tp,aux.Stringid(72101229,0),aux.Stringid(72101229,1))==0 then
			--immune
			local mcg=Duel.GetMatchingGroup(c72101229.mfilter,tp,LOCATION_MZONE,0,nil)
			local mcf=mcg:GetFirst()
			while mcf do
				local e3=Effect.CreateEffect(mcf)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
				e3:SetRange(LOCATION_MZONE)
				e3:SetCode(EFFECT_IMMUNE_EFFECT)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				e3:SetValue(c72101229.mcffilter)
				e3:SetOwnerPlayer(tp)
				mcf:RegisterEffect(e3)
				mcf=mcg:GetNext()
			end
		else  --cannnot chain  
				local tct=1
				if Duel.GetTurnPlayer()~=tp then tct=2
				elseif Duel.GetCurrentPhase()==PHASE_END then tct=3 end
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_CHAINING)
				e1:SetOperation(c72101229.actop)
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
				Duel.RegisterFlagEffect(tp,72101230,RESET_PHASE+PHASE_END,0,tct)
		end
	end
end
function c72101229.czfilter(c)
	return c:IsCode(72101215) and (c:IsLocation(LOCATION_ONFIELD) and c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c72101229.mfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c72101229.mcffilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c72101229.actop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp and re:GetHandler():IsSetCard(0xcea) and (re:IsHasType(EFFECT_TYPE_ACTIVATE) or re:IsActiveType(TYPE_MONSTER)) then
		Duel.SetChainLimit(c72101229.chainlm)
	end
end
function c72101229.chainlm(e,rp,tp)
	return tp==rp
end