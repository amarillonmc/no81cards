-- 人格切换
Duel.LoadScript("c60001511.lua")
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddRitualProcGreater2(c,cm.filter,LOCATION_HAND,nil,nil,false,cm.extraop)
end
function cm.filter(c,e,tp)
	return c:IsSetCard(0x6624)
end
function cm.extraop(e,tp,eg,ep,ev,re,r,rp,tc,mat)
	local c=e:GetHandler()
	if not tc then return end
	if byd.link(c,5) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.BreakEffect()
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end