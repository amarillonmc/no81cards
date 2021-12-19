local m=53716006
local cm=_G["c"..m]
cm.name="断片折光 幻想愚间"
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	SNNM.FanippetTrap(c,800,m,1400,1500,RACE_FIEND,ATTRIBUTE_EARTH)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.cfilter(c)
	return c:IsFaceup() and bit.band(c:GetType(),0x20004)==0x20004 and not c:IsRace(RACE_FIEND)
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(cm.cfilter,1,nil) then Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+m,e,0,0,0,1) end
end
