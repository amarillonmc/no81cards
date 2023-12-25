--无亘幻梦传说
xpcall(function() dofile("expansions/script/c20000000.lua") end,function() dofile("script/c20000000.lua") end)
local cm,m,o = GetID()
function cm.initial_effect(c)
	fuef.A(c)
	fuef.F(c,c,EFFECT_DIRECT_ATTACK,",,F,M+M,,,,tg1")
	fuef.FTO(c,c,EVENT_PHASE+PHASE_BATTLE,",,,F,1,con2,,,op2")
	if cm.glo then return end
	cm.op4()
	fuef.FC(c,0,EVENT_BATTLE_DAMAGE,",,,,,op3")(EVENT_PHASE_START+PHASE_DRAW,0,"OP:op4")
end
--e1
function cm.tg1(e,c)
	return c:IsAttackBelow(1000)
end
--e2
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return cm.glo[tp+1]>0
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local val = cm.glo[tp]
	fuef.F(e,tp,EFFECT_CHANGE_DAMAGE,",PTG,,1+0,op2val1,,,,,PH/ED|2,"..val)
end
function cm.op2val1(e,re,dam,r,rp,rc)
	local val = dam - e:GetLabel()
	return val>0 and dam or 0
end
--e3
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	cm.glo[rp+1] = cm.glo[rp+1] + (ev or 0)
end
--e4
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	cm.glo = {0,0} 
end