local m=53722002
local cm=_G["c"..m]
cm.name="大祭环 髑蛮"
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
	SNNM.GreatCircle(c)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.negcon)
	e3:SetOperation(cm.negop)
	c:RegisterEffect(e3)
end
function cm.nfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsSetCard(0x3531) and c:IsType(TYPE_MONSTER)
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) or not Duel.IsChainNegatable(ev) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return rp==1-tp and g and g:IsExists(cm.nfilter,1,nil)
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,2) then return end
	Duel.Hint(HINT_CARD,0,m)
	Duel.NegateEffect(ev)
	Duel.DiscardDeck(tp,2,REASON_EFFECT)
end
