--入魂一刀
function c11570000.initial_effect(c)
	--act in hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e1:SetCondition(c11570000.handcon)
	c:RegisterEffect(e1) 
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_CHAINING)   
	e1:SetCountLimit(1,11570000+EFFECT_COUNT_CODE_OATH) 
	e1:SetCondition(c11570000.accon) 
	e1:SetTarget(c11570000.actg) 
	e1:SetOperation(c11570000.acop)  
	c:RegisterEffect(e1) 
end
function c11570000.handcon(e)
	return Duel.GetCurrentChain()>=3  
end
function c11570000.accon(e,tp,eg,ep,ev,re,r,rp) 
	for i=1,ev do 
		if Duel.IsChainDisablable(i) then
			return Duel.GetCurrentChain()>=2   
		end
	end
	return false
end
function c11570000.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function c11570000.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local x=Duel.GetCurrentChain()  
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if Duel.IsChainDisablable(i) then
			local e1=Effect.CreateEffect(c) 
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
			e1:SetCode(EVENT_CHAIN_SOLVING) 
			if x>=5 then 
			e1:SetLabel(1)
			else 
			e1:SetLabel(0)  
			end 
			e1:SetLabelObject(te) 
			e1:SetCondition(c11570000.discon) 
			e1:SetOperation(c11570000.disop) 
			e1:SetReset(RESET_CHAIN) 
			Duel.RegisterEffect(e1,tp)   
		end
	end 
end
function c11570000.discon(e,tp,eg,ep,ev,re,r,rp) 
	local te=e:GetLabelObject() 
	return re==te   
end 
function c11570000.disop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local te=e:GetLabelObject() 
	local x=e:GetLabel() 
	local rc=te:GetHandler() 
	if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) then 
		Duel.Destroy(rc,REASON_EFFECT)
		if x==1 then 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
		e1:SetTarget(c11570000.xdistg)
		e1:SetLabelObject(rc)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetCondition(c11570000.xdiscon)
		e2:SetOperation(c11570000.xdisop)
		e2:SetLabelObject(rc)
		e2:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e2,tp)
		end 
	end 
end 
function c11570000.xdistg(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule()) 
end
function c11570000.xdiscon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c11570000.xdisop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end





