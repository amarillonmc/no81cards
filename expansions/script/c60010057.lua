--游梦华
local cm,m,o=GetID()
function cm.initial_effect(c)
	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCost(cm.cost2)
	e2:SetCondition(cm.tcon)
	e2:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE)
	c:RegisterEffect(e2)
end
cm={}
if not cm.ymh then
	cm.ymh=true
	cm._registereffect=Card.RegisterEffect
	Card.RegisterEffect=function (card,eff)
		cm._registereffect(card,eff)
		if eff:IsHasType(EFFECT_TYPE_TRIGGER_O) then
			local neff=eff:Clone()
			neff:SetType(eff:GetType()-EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_TRIGGER_F)
			--neff:SetLabelObject(eff)
			if eff:GetCondition()~=nil then
				neff:SetCondition(cm.ncon)
			else
				neff:SetCondition(cm.ncon2)
			end
			if eff:GetTarget()~=nil then
				neff:SetTarget(cm.ntg)
			end
			card:RegisterEffect(neff)
			cm[neff]=eff
		end
	end
end
function cm.ncon(e,tp,eg,ep,ev,re,r,rp)
	local oc=cm[e]:GetCondition()
	return oc(e,tp,eg,ep,ev,re,r,rp) and Duel.GetFlagEffect(0,m)~=0
end
function cm.ncon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(0,m)~=0
end
function cm.ntg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local otg=cm[e]:GetTarget()
	if chkc then return otg(e,tp,eg,ep,ev,re,r,rp,1,1) end
	if chk==0 then return true end
	otg(e,tp,eg,ep,ev,re,r,rp)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,c)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function cm.tcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.RegisterFlagEffect(0,m,RESET_PHASE+PHASE_END,0,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,1)
	e1:SetValue(cm.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.aclimit(e,re,tp)
	return re:GetType()&EFFECT_TYPE_TRIGGER_O>0
end