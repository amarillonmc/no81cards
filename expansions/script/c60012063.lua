-- 龙之启示
Duel.LoadScript("c60001511.lua")
local cm,m,o=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)

end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	byd.AddSummonCount(e,tp)
	if Duel.GetFlagEffect(tp,60012060)>1 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
