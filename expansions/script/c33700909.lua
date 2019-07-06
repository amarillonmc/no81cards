--捉鬼萝莉队
function c33700909.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DETACH_EVENT)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c33700909.condition)
	e1:SetTarget(c33700909.target)
	e1:SetOperation(c33700909.activate)
	c:RegisterEffect(e1)
	if not c33700909.global_check then
		c33700909.global_check=true
		c33700909[0]=nil
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DISCARD)
		ge1:SetOperation(c33700909.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_TO_GRAVE)
		Duel.RegisterEffect(ge2,0)
	end 
end
function c33700909.cfilter(c)
	return c:IsPreviousLocation(LOCATION_HAND) and c:IsReason(REASON_COST) 
end
function c33700909.checkop(e,tp,eg,ep,ev,re,r,rp)
	local cid=Duel.GetCurrentChain()
	for tc in aux.Next(eg) do
		local p=tc:GetPreviousControler()
		if tc:IsPreviousLocation(LOCATION_HAND) and tc:IsReason(REASON_COST) then
			if cid>0 then
				c33700909[p]=Duel.GetChainInfo(cid,CHAININFO_CHAIN_ID)
			end
		end
	end
end
function c33700909.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)==c33700909[rp] and Duel.IsChainDisablable(ev)
end
function c33700909.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c33700909.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(1,1)
		e1:SetCode(re:GetHandler():GetCode())
		e1:SetValue(c33700909.aclimit)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
	end
end
function c33700909.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel()) and not re:GetHandler():IsImmuneToEffect(e)
end
