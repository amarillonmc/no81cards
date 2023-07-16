--忍缚之圣沌 圆月
local cm,m,o=GetID()
if not pcall(function() require("expansions/script/c20000175") end) then require("script/c20000175") end
function cm.initial_effect(c)
	fu_HC.glo(c)
	local e1 = fuef.B_A(c,c,",NEGE,,TG,,,",cm.tg1,cm.op1)
end
--e1
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return fucf.Filter("IsLoc+IsControler+TgChk+NegateMonsterFilter","M",tp,e) end
	if chk==0 then return fugf.GetFilter(tp,"+M","TgChk+NegateMonsterFilter",e,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)	
	fugf.SelectTg(tp,"+M","TgChk+NegateMonsterFilter",e)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsCanBeDisabledByEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=fuef.S(e,tc,"",EFFECT_DISABLE,",,,,,",RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		local e2=fuef.Clone(e1,tc,{"COD",EFFECT_DISABLE_EFFECT},{"VAL",RESET_TURN_SET})
		local e3=fuef.Clone(e1,tc,{"COD",EFFECT_MUST_ATTACK})
		local g=fugf.GetFilter(tp,"+S","IsPos","FD")
		if fu_HC.IsAct() and #g>0 then
			local e4=fuef.S(e,g,0,EFFECT_CANNOT_TRIGGER,"HINT,,,,,",{RESET_EVENT+0x17a0000+RESET_PHASE+PHASE_END,2})
		end
	end
end