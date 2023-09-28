local m=53715010
local cm=_G["c"..m]
cm.name="欢乐树友 偷弟"
if not require and Duel.LoadScript then
    function require(str)
        local name=str
        for word in string.gmatch(str,"%w+") do
            name=word
        end
        Duel.LoadScript(name..".lua")
        return true
    end
end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	SNNM.HTFSynchoro(c,0,m)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_PZONE)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
end
cm[0]=0
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local id=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)
	if id==cm[0] or not re:IsActiveType(TYPE_SPELL+TYPE_TRAP) then return end
	cm[0]=id
	if e:GetHandler():IsDestructable(e) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_CARD,0,m)
		if Duel.Destroy(e:GetHandler(),REASON_EFFECT)~=0 and Duel.IsChainDisablable(ev) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then Duel.NegateEffect(ev) end
		SNNM.HTFPlacePZone(e:GetHandler(),2,LOCATION_EXTRA,1,EVENT_PHASE+PHASE_END,m,tp)
	end
end
