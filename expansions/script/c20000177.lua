--忍警之圣沌 鸣子
local cm,m,o=GetID()
if not pcall(function() require("expansions/script/c20000175") end) then require("script/c20000175") end
function cm.initial_effect(c)
	fu_HC.glo(c)
	local e1 = fuef.B_A(c,c,",,,,,,",cm.tg1,cm.op1)
end
--e1
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return #fugf.Get(tp,"D")>2 end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	if #fugf.Get(tp,"D")<3 then return end
	Duel.ConfirmDecktop(tp,3)
	local g=fugf.Filter(Duel.GetDecktopGroup(tp,3),"IsTyp+IsSSetable","T")
	if #g>0 and Duel.SelectYesNo(tp,1153) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		g=g:Select(tp,1,1,nil)
		if Duel.SSet(tp,g)>0 and fu_HC.IsAct() then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			g:GetFirst():RegisterEffect(e1)
		end
	end
	Duel.ShuffleDeck(tp)
end