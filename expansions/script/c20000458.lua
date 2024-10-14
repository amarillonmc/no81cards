--击星之创导龙
dofile("expansions/script/c20000450.lua")
local cm, m = fu_GD.RM_initial("glo")
cm.e1 = fuef.S(EFFECT_EXTRA_ATTACK):RAN("M"):VAL("val1")
cm.val1 = function(e) return cm.glo[e:GetHandlerPlayer() + 1] + 1 end
--ge1
cm.ge1 = fuef.FC("PHS+DP"):OP("glo_op1")("DR"):Func("sd_con,glo_op2")
cm.glo_op1 = function() cm.glo = {0, 0} end
cm.glo_op2 = function(e,tp,eg,ep,ev,re,r,rp) cm.glo[ep + 1] = cm.glo[ep + 1] + ev end