--极限单独种 奥尔特·宇宙圆盘
function c22025790.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c22025790.indcon)
	e2:SetValue(c22025790.efilter)
	c:RegisterEffect(e2)
	--xyz
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22025790,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCondition(c22025790.descon)
	e3:SetOperation(c22025790.desop)
	c:RegisterEffect(e3)
	--lp
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22025790,1))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCondition(c22025790.lpcon)
	e4:SetOperation(c22025790.lpop)
	c:RegisterEffect(e4)
end
function c22025790.indcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)==1
end
function c22025790.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c22025790.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c22025790.eatfilter(c,e)  
	return c:IsCanOverlay() and not c:IsImmuneToEffect(e)
end	
function c22025790.desop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()  
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c22025790.eatfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c,e)
	local tc=g:GetFirst() 
	while tc do
		local og=tc:GetOverlayGroup()  
		if og:GetCount()>0 then  
			Duel.SendtoGrave(og,REASON_RULE)  
		end  
		Duel.Overlay(c,Group.FromCards(tc)) 
		tc=g:GetNext()
	end  
end 
function c22025790.lpcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp and Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)==0
end
function c22025790.lpop(e,tp,eg,ep,ev,re,r,rp)
	local lp=Duel.GetLP(1-tp)
	Duel.SetLP(1-tp,lp-5000)
end