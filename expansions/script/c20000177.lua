--忍警之圣沌 鸣子
dofile("expansions/script/c20000175.lua")
local cm,m = fu_HC.T_initial()
--e1
function cm.e1(c)
	fuef.A(c):Func("tg1,op1")
	if cm.chk then return end
	cm.chk = {0, 0}
	fuef.FC(c,"PHS+DP",1):OP("op2*")("CH"):Func("con2,op2*1")("NEGA"):Func("op2*-1")
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return #fugf.Get(tp,"D")>0 end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	if #fugf.Get(tp,"D")==0 then return end
	local n = (cm.chk[tp+1]+3 > #fugf.Get(tp,"D")) and #fugf.Get(tp,"D") or (cm.chk[tp+1]+3)
	Duel.ConfirmDecktop(tp,n)
	local g=fugf.Filter(Duel.GetDecktopGroup(tp,n),"IsTyp+IsSSetable","T")
	if #g>0 and Duel.SelectYesNo(tp,1153) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		g=g:Select(tp,1,1,nil):GetFirst()
		if Duel.SSet(tp,g)>0 and fu_HC.chk[tp+1]>0 then
			fuef.S(e,EFFECT_TRAP_ACT_IN_SET_TURN,g):PRO("SET"):RES("EV+STD")
		end
	end
	Duel.ShuffleDeck(tp)
end
--e2
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP)
end
function cm.op2(n)
	return function(e,tp,eg,ep,ev,re,r,rp)
		if tonumber(n) then 
			cm.chk[re:GetHandlerPlayer()+1] = cm.chk[re:GetHandlerPlayer()+1] + n
		else 
			cm.chk = {0, 0}
		end
	end
end