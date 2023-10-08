--炽天覆七重圆环
function c11579810.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,11579810+EFFECT_COUNT_CODE_OATH) 
	e1:SetTarget(c11579810.actg) 
	e1:SetOperation(c11579810.acop)  
	c:RegisterEffect(e1) 
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(function(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),0,LOCATION_MZONE)>0 end)
	c:RegisterEffect(e2)
end
function c11579810.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
end 
function c11579810.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_CHAIN_SOLVING) 
	e1:SetLabel(0)
	e1:SetCondition(c11579810.xdscon) 
	e1:SetOperation(c11579810.xdsop) 
	e1:SetReset(RESET_PHASE+PHASE_END)  
	Duel.RegisterEffect(e1,tp) 
end 
function c11579810.xdscon(e,tp,eg,ep,ev,re,r,rp)
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	return ex and (tg~=nil or tc>0) and Duel.IsChainDisablable(ev) 
end 
function c11579810.xdsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local x=e:GetLabel()
	if c11579810.xdscon(e,tp,eg,ep,ev,re,r,rp) then 
		Duel.NegateEffect(ev)   
		local x=x+1 
		e:SetLabel(x) 
		c:SetTurnCounter(x) 
		if x==7 then 
			e:Reset() 
		end 
	end 
end  




