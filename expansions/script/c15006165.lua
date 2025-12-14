local m=15006165
local cm=_G["c"..m]
cm.name="无海冷却协议"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetTarget(cm.reptg)
	e5:SetValue(cm.repval)
	e5:SetOperation(cm.repop)
	c:RegisterEffect(e5)
end
function cm.xyzfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6f44)
end
function cm.ovfilter(c,tp)
	return c:IsAbleToHand() and c:GetOwner()==tp
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Group.CreateGroup()
	local xg=Duel.GetMatchingGroup(cm.xyzfilter,tp,LOCATION_MZONE,0,nil)
	if xg:GetCount()<1 then return false end
	for tc in aux.Next(xg) do
		local hg=tc:GetOverlayGroup()
		if hg:GetCount()>0 then
			rg:Merge(hg)
		end
	end
	if chk==0 then return rg and rg:FilterCount(cm.ovfilter,nil,tp)>0 end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rg=Group.CreateGroup()
	local xg=Duel.GetMatchingGroup(cm.xyzfilter,tp,LOCATION_MZONE,0,nil)
	if xg:GetCount()<1 then return end
	for tc in aux.Next(xg) do
		local hg=tc:GetOverlayGroup()
		if hg:GetCount()>0 then
			rg:Merge(hg)
		end
	end
	if rg and rg:FilterCount(cm.ovfilter,nil,tp)>0 then
		local tc=rg:FilterSelect(tp,cm.ovfilter,1,1,nil,tp):GetFirst()
		if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) then
			local ct=Duel.GetCurrentChain()
			if ct<2 then return end
			local te,tep=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
			if tep==1-tp then
				Duel.BreakEffect()
				Duel.NegateEffect(ct-1)
			end
		end
	end
end
function cm.repfilter(c,tp)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsLocation(LOCATION_MZONE)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(cm.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function cm.repval(e,c)
	return cm.repfilter(c,e:GetHandlerPlayer())
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end