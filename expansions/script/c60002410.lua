--瓶中之人
local cm,m,o=GetID()
function cm.initial_effect(c)
	--tograve
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,m)
	e3:SetOperation(cm.tgop)
	c:RegisterEffect(e3)
	
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_REMOVE)
	e3:SetOperation(cm.tgop2)
	c:RegisterEffect(e3)

	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.condition)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetHandler(),nil,REASON_EFFECT)
end
function cm.tgop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,m)~=0
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	--spsm
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_REMOVE)
	e1:SetOperation(cm.spop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	for i=1,#eg do
		if Duel.GetFlagEffect(tp,m+10000000)==3 then
			Duel.ResetFlagEffect(tp,m+10000000)
			local rc=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_REMOVED,0,nil):RandomSelect(tp,1)
			Duel.SendtoHand(rc,tp,REASON_EFFECT)
		else
			Duel.RegisterFlagEffect(tp,m+10000000,RESET_PHASE+PHASE_END,0,1)
		end
	end
end