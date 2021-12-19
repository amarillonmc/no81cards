local m=53716008
local cm=_G["c"..m]
cm.name="断片折光 幻想壳滩"
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	SNNM.FanippetTrap(c,800,m,900,2100,RACE_ROCK,ATTRIBUTE_WATER)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_MSET)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SSET)
		Duel.RegisterEffect(ge2,0)
		local ge3=ge1:Clone()
		ge3:SetCode(EVENT_CHANGE_POS)
		ge3:SetOperation(cm.checkop2)
		Duel.RegisterEffect(ge3,0)
		local ge4=ge3:Clone()
		ge4:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge4,0)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+m,e,0,0,ep,0)
end
function cm.checkop2(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(Card.IsFacedown,1,nil) then Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+m,re,r,rp,ep,ev) end
end
