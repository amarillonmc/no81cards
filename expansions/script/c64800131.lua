--芥川龙之介的河童之国
local m=64800131
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e0:SetRange(LOCATION_SZONE)
	e0:SetCountLimit(1)
	e0:SetCondition(cm.mtcon)
	e0:SetOperation(cm.mtop)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--disable
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCode(EVENT_CHAIN_SOLVING)
	e6:SetOperation(cm.disop)
	c:RegisterEffect(e6)
end
function cm.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.cfilter(c)
	return c:IsReleasableByEffect()
end
function cm.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.HintSelection(Group.FromCards(c))
	local g=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_MZONE,0,nil)
	local sel=1
	if g:GetCount()~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local tg=g:Select(tp,1,1,nil)
		Duel.Release(tg,REASON_COST)
	else
		Duel.Destroy(c,REASON_COST)
	end
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct,loc=Duel.GetChainInfo(ev,CHAININFO_CHAIN_COUNT,CHAININFO_TRIGGERING_LOCATION)
	if ct~=1 or bit.band(loc,LOCATION_ONFIELD)==0 then return end
	local tc=re:GetHandler()
	if tc:IsType(TYPE_MONSTER) and tc:IsAbleToGrave() then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
	if tc:IsType(TYPE_SPELL+TYPE_TRAP) and tc:IsAbleToRemove() and tc~=c then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end