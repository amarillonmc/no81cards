--天听
local cm,m,o=GetID()
function cm.initial_effect(c)
	--random
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.sccost)
	e1:SetOperation(cm.scop)
	c:RegisterEffect(e1)
end
tt={}
ttnum=0
function cm.sccost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFlagEffect(0,m)==0 then
		Duel.RegisterFlagEffect(0,m,RESET_PHASE+PHASE_END,0,2)
		Duel.RegisterFlagEffect(1,m,RESET_PHASE+PHASE_END,0,2)
		tt[1]={m}
		ttnum=1
		--activate cost
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_ACTIVATE_COST)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,1)
		e2:SetReset(RESET_PHASE+PHASE_END,2)
		e2:SetCost(cm.costchk)
		e2:SetTarget(cm.costtg)
		e2:SetOperation(cm.costop)
		Duel.RegisterEffect(e2,tp)
	end
end
function cm.costchk(e,the,tp)
	local tp=the:GetHandlerPlayer()
	local dkg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_DECK,0,nil)
	for i=1,ttnum do 
		dkg:Remove(Card.IsCode,nil,tt[i])
	end
	return #dkg>0
end
function cm.costtg(e,the,tp)
	e:SetLabelObject(the)
	return true
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	local thec=e:GetLabelObject():GetHandler()
	local tp=e:GetLabelObject():GetHandlerPlayer()
	local dkg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_DECK,0,nil)
	for i=1,ttnum do 
		dkg:Remove(Card.IsCode,nil,tt[i])
	end
	if #dkg>0 then
		local lc=dkg:Select(tp,1,1,nil):GetFirst()
		Duel.ConfirmCards(1-tp,lc)
		ttnum=ttnum+1
		tt[ttnum]=lc:GetCode()
		ttnum=ttnum+1
		tt[ttnum]=thec:GetCode()
	end
end