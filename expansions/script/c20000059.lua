--无亘帝幻梦龙
xpcall(function() dofile("expansions/script/c20000000.lua") end,function() dofile("script/c20000000.lua") end)
local cm,m,o=GetID()
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddCodeList(c,20000051)
	fuef.S(c,EFFECT_INDESTRUCTABLE_BATTLE):RAN("M"):PRO("SR"):Func("1,con1")
	fuef.FTO(c,EVENT_BATTLE_DAMAGE):CAT("REC+ATK"):RAN("M"):Func("con2,tg2,op2")
end
--e1
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
--e2
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker() == e:GetHandler() or Duel.GetAttackTarget() == e:GetHandler()
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ev)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Recover(tp,ev,REASON_EFFECT) <= 0 then return end
	local g = fugf.GetFilter(tp, "M", "IsRac+IsPos-IsImm", {"DR,FU", e})
	fuef.S(e,EFFECT_UPDATE_ATTACK,g):VAL(math.floor(ev/2)):RES("EV+STD")
end