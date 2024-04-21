--坏兽镇压大作战
function c11567832.initial_effect(c) 
	Duel.EnableGlobalFlag(GLOBALFLAG_BRAINWASHING_CHECK) 
	--Activate 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,11567832)
	e1:SetOperation(c11567832.acop) 
	c:RegisterEffect(e1) 
	--set
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetRange(LOCATION_GRAVE) 
	e2:SetCountLimit(1,13767832) 
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c11567832.settg) 
	e2:SetOperation(c11567832.setop) 
	c:RegisterEffect(e2) 
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c11567832.handcon)
	c:RegisterEffect(e2)	
end
function c11567832.acop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_REMOVE_BRAINWASHING)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE) 
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE) 
	e1:SetReset(RESET_PHASE+PHASE_END) 
	Duel.RegisterEffect(e1,tp) 
end 
function c11567832.setfil(c) 
	return c:IsSSetable() and c:IsCode(94739788,9720537) 
end 
function c11567832.settg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c11567832.setfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end 
end 
function c11567832.setop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c11567832.setfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil) 
	if g:GetCount()>0 then 
	local tc=g:Select(tp,1,1,nil):GetFirst() 
	if tc and Duel.SSet(tp,tc)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
	end 
end 
function c11567832.cxfilter(c)
	return c:GetControler()~=c:GetOwner() 
end
function c11567832.handcon(e)
	return Duel.IsExistingMatchingCard(c11567832.cxfilter,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,1,nil)
end












  