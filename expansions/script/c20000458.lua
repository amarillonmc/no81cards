--击星之创导龙
dofile("expansions/script/c20000450.lua")
local cm, m = fu_GD.RInitial("glo")
cm.e1 = fuef.S(EFFECT_EXTRA_ATTACK):Ran("M"):Val("val1")
function cm.val1(e)
	return cm.glo[e:GetHandlerPlayer() + 1] + 1 
end
--ge1
cm.ge1 = fuef.FC("PHS+DP"):Op("glo_op1")("DR"):Func("SelfDraw_con,glo_op2")
function cm.glo_op1()
	cm.glo = {0, 0} 
end
function cm.glo_op2(e,tp,eg,ep,ev,re,r,rp)
	cm.glo[ep + 1] = cm.glo[ep + 1] + ev
end