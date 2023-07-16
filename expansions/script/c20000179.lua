--忍防之圣沌 八方
local cm,m,o=GetID()
if not pcall(function() require("expansions/script/c20000175") end) then require("script/c20000175") end
function cm.initial_effect(c)
	fu_HC.glo(c)
	local e1 = fuef.B_A(c,c,",,,,,,",cm.tg1,cm.op1)
end
--e1
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return fugf.GetFilter(tp,"MS","IsTyp","S/T",1) end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=fugf.GetFilter(tp,"MS","IsTyp","S/T")
	local e1=fuef.S(e,{g,1},"",EFFECT_CANNOT_BE_EFFECT_TARGET,"SET,",aux.tgoval,",,",{RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2})
	local e2=fuef.Clone(e1,fugf.Filter(g,"~IsImmuneToEffect",e),{"COD",EFFECT_INDESTRUCTABLE_EFFECT},{"VAL",aux.indoval})
	g=fugf.GetFilter(tp,"M","IsTyp+IsSet+IsPos","M,5fd1,FU")
	if not fu_HC.IsAct() or #g==0 then return end
	local e3=fuef.S(e,{g,1},"",EFFECT_CANNOT_BE_EFFECT_TARGET,",",aux.tgoval,",,",{RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2})
	local e4=fuef.Clone(e3,fugf.Filter(g,"~IsImmuneToEffect",e),{"COD",EFFECT_INDESTRUCTABLE_EFFECT},{"VAL",aux.indoval})
end