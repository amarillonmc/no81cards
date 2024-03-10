--天际之指名者
local m=16670011
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
    --
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
        local g = Group.CreateGroup()
    local a=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_EXTRA+LOCATION_HAND,nil)
    g:AddCard(a)
	local b=Duel.GetCurrentChain()
	for i=1,b do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if tgp~=tp then
			local tc=te:GetHandler()
			if (tc:IsLocation(LOCATION_HAND) or tc:IsLocation(LOCATION_EXTRA)) and tc:IsAbleToRemove() then
				g:AddCard(tc)
			end
		end
    end
        return g:GetCount()>0 end
        local g = Group.CreateGroup()
        local a=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_EXTRA+LOCATION_HAND,nil)
        g:AddCard(a)
        local b=Duel.GetCurrentChain()
	        for i=1,b do
            local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
            if tgp~=tp then
                local tc=te:GetHandler()
                if (tc:IsLocation(LOCATION_HAND) or tc:IsLocation(LOCATION_EXTRA)) and tc:IsAbleToRemove() then
                    g:AddCard(tc)
                end
            end
        end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,tp,LOCATION_EXTRA+LOCATION_HAND)
end
function cm.filter(c,code)
	return c:IsAbleToRemove() and c:IsFaceup()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g = Group.CreateGroup()
    local a=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_EXTRA+LOCATION_HAND,nil)
    g:AddCard(a)
    local b=Duel.GetCurrentChain()
	for i=1,b do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if tgp~=tp then
			local tc=te:GetHandler()
			if (tc:IsLocation(LOCATION_HAND) or tc:IsLocation(LOCATION_EXTRA)) and tc:IsAbleToRemove() then
				g:AddCard(tc)
			end
		end
    end
	Duel.ConfirmCards(tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if tc and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_REMOVED) then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
		e1:SetTarget(cm.distg1)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetCondition(cm.discon)
		e2:SetOperation(cm.disop)
		e2:SetLabelObject(tc)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
		e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e3:SetTarget(cm.distg2)
		e3:SetLabelObject(tc)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
	end
end
function cm.distg1(e,c)
	local tc=e:GetLabelObject()
	if c:IsType(TYPE_SPELL+TYPE_TRAP) then
		return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
	else
		return c:IsOriginalCodeRule(tc:GetOriginalCodeRule()) and (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0)
	end
end
function cm.distg2(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
