--妄想咒阈 退相干诠释
--21.08.04
local m=11451200
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Decoherent Histories
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_ACTIVATE_COST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetTarget(cm.costtg)
	e1:SetOperation(cm.costop)
	c:RegisterEffect(e1)
end
function cm.costtg(e,te,tp)
	e:SetLabelObject(te:GetHandler())
	return true
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.AnnounceCard(e:GetHandlerPlayer())
	if e:GetLabelObject():IsOriginalCodeRule(ac) then
		if Duel.CheckLPCost(tp,3000) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.PayLPCost(tp,3000)
		else
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_CHAIN_SOLVING)
			e1:SetOperation(cm.ngop)
			e1:SetReset(RESET_CHAIN)
			e1:SetLabel(ev+1)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function cm.ngop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==ev then Duel.NegateEffect(ev) end
end