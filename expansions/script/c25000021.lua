--斯菲亚合成兽 新盖加雷德
if not pcall(function() require("expansions/script/c25000011") end) then require("script/c25000011") end
local m,cm=rscf.DefineCard(25000021)
function cm.initial_effect(c)
	local e1,e2,e3,e4=rsgs.FusProcFun(c,m,TYPE_LINK,"dish","ptg",rsop.target(nil,"dish",0,1),cm.disop)
	local e5=rsef.STO(c,EVENT_BATTLE_CONFIRM,{m,0},nil,"des,atk",nil,nil,nil,rsop.target(aux.TRUE,"des",0,LOCATION_MZONE),cm.desop)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(ep,LOCATION_HAND,0,nil)
	if #g==0 then return end
	local sg=g:RandomSelect(1-tp,1)
	Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)
end
function cm.desop(e,tp)
	local c=rscf.GetRelationThisCard(e)
	local ct,og,tc=rsop.SelectDestroy(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil,{})
	if ct>0 and c then
		local atk=c:GetBaseAttack()
		local e1=rsef.SV_UPDATE(c,"atk",atk,nil,rsreset.est_pend+RESET_DISABLE)
	end
end