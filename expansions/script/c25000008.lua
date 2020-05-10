--根源破灭魔人 布里兹布罗兹
if not pcall(function() require("expansions/script/c25000000") end) then require("script/c25000000") end
local m,cm=rscf.DefineCard(25000008)
function cm.initial_effect(c)
	local e1=rszg.XyzSumFun(c,m,6,25000009)
	local e2=rsef.SC(c,EVENT_ATTACK_ANNOUNCE,nil,nil,nil,nil,cm.regop) 
	local e3=rsef.QO(c,EVENT_CHAINING,{m,0},{1,m+600},"neg,des,dam",nil,LOCATION_MZONE,rscon.negcon(0,true),rscost.rmxyz(1),aux.AND(rstg.negtg("des"),cm.damtg),cm.negop)
end
function cm.discon(e)
	return e:GetHandler():GetFlagEffect(m)~=0
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	if not tc then return end
	tc:RegisterFlagEffect(m,rsreset.est+RESET_PHASE+PHASE_BATTLE,0,1)
	local e1=rsef.SV_LIMIT({e:GetHandler(),tc,true},"dis",nil,cm.discon,rsreset.est+RESET_PHASE+PHASE_BATTLE,"cd")
end
function cm.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function cm.negop(e,tp,...)
	if rsop.negop("des")(e,tp,...)>0 then
		Duel.BreakEffect()
		Duel.Damage(1-tp,1000,REASON_EFFECT)
	end
end