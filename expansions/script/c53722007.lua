local m=53722007
local cm=_G["c"..m]
cm.name="大祭环 徒花"
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
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetOperation(cm.ctop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
--function cm.cfilter(c)
--	return not c:IsSetCard(0x3531)
--end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
--	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_GRAVE,0,nil)
--	if #g>0 and not g:IsExists(cm.cfilter,1,nil) and eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp) then
	if eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp) then
		Duel.Hint(HINT_CARD,0,m)
		Duel.DiscardDeck(tp,1,REASON_EFFECT)
	end
end
