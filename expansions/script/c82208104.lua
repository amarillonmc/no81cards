local m=82208104
local cm=_G["c"..m]
cm.name="梦幻泡影"
function cm.initial_effect(c)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_DISABLE)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER) 
	e1:SetOperation(cm.activate)  
	c:RegisterEffect(e1)  
	--act in hand  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE)  
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)  
	e2:SetCondition(cm.handcon)  
	c:RegisterEffect(e2)  
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()   
	if c:IsLocation(LOCATION_SZONE) then  
		local e4=Effect.CreateEffect(c)  
		e4:SetType(EFFECT_TYPE_FIELD)  
		e4:SetCode(EFFECT_DISABLE)  
		e4:SetTargetRange(0x0c,0x0c)  
		e4:SetTarget(cm.distg)  
		e4:SetLabel(c:GetSequence())  
		Duel.RegisterEffect(e4,tp)  
		local e5=Effect.CreateEffect(c)  
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
		e5:SetCode(EVENT_CHAIN_SOLVING)  
		e5:SetOperation(cm.disop)   
		e5:SetLabel(c:GetSequence())  
		Duel.RegisterEffect(e5,tp)  
		local e6=Effect.CreateEffect(c)  
		e6:SetType(EFFECT_TYPE_FIELD)  
		e6:SetCode(EFFECT_DISABLE_TRAPMONSTER)  
		e6:SetTargetRange(0x0c,0x0c)
		e6:SetTarget(cm.distg)  
		e6:SetLabel(c:GetSequence())  
		Duel.RegisterEffect(e6,tp)  
	end   
end  
function cm.distg(e,c)  
	local seq=e:GetLabel()  
	local tp=e:GetHandlerPlayer()  
	return aux.GetColumn(c,tp)==seq  
end  
function cm.disop(e,tp,eg,ep,ev,re,r,rp)  
	local tseq=e:GetLabel()  
	local loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)  
	if loc&LOCATION_ONFIELD~=0 and seq<=4
		and ((rp==tp and seq==tseq) or (rp==1-tp and seq==4-tseq)) then  
		Duel.NegateEffect(ev)  
	end  
end  
function cm.handcon(e)  
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)==0  
end  