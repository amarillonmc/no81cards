--虚拟水神士兵
if not pcall(function() require("expansions/script/c65020201") end) then require("script/c65020201") end
local m,cm=rscf.DefineCard(65020206,"VrAqua")
function cm.initial_effect(c)
	local e1,e2,e3=rsva.MonsterEffect(c,m,cm.op)
end
function cm.op(e,tp)
	local c=e:GetHandler()
	local e1,e2=rsef.FV_UPDATE({c,tp},"atk,def",cm.atkval,cm.atktg,{LOCATION_MZONE,0},cm.atkcon,rsreset.pend)
end
function cm.atkval(e,c)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),0,LOCATION_MZONE)*800
end
function cm.atktg(e,c)
	return c:IsLevel(10) and (Duel.GetAttacker()==c or (Duel.GetAttackTarget() and Duel.GetAttackTarget()==c))
end
function cm.atkcon(e)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL
end