--创导龙裔·构形者
dofile("expansions/script/c20000450.lua")
local func = fugf.GetNoP("DG", "IsCode", 464)
local pe = fuef.STO("DR"):RAN("H"):PRO("DAM"):CTL("m"):Func("p_con1,N_cos1,N_tg1(%1),N_op1(%1)", func)
local cm, m = fuef.initial(fu_GD, _glo, "public_effect", pe)
cm.e1 = fuef.FC("DR"):RAN("H"):Func("SelfDraw_con,N_op2")
--pe
function cm.p_con1(e,tp,eg,ep,ev,re,r,rp)
	return (r & REASON_EFFECT == REASON_EFFECT) and fucf.Filter(re:GetHandler(), "IsSet+IsTyp", "bfd4,M")
end