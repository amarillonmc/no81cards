local m=53763002
local cm=_G["c"..m]
cm.name="金色拼件多蒂克希德隆"
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
	aux.AddCodeList(c,53763001)
	SNNM.Ranclock(c,CATEGORY_DRAW,ATTRIBUTE_WATER,cm.op,ATTRIBUTE_EARTH)
end
function cm.dfilter(c)
	return c:IsFaceupEx() and c:IsRace(RACE_FIEND) and c:IsLevelAbove(7)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local tc=Duel.SelectMatchingCard(tp,cm.dfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil):GetFirst()
	local attr=tc:GetAttribute()
	if Duel.Destroy(tc,REASON_EFFECT)~=0 and bit.band(attr,ATTRIBUTE_DARK)~=0 and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
