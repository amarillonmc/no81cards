--忍警之圣沌 鸣子
dofile("expansions/script/c20000175.lua")
local cm, m = fu_HC.T_initial("chk")
--e1
cm.e1 = fuef.A():Func("tg1,op1")
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return #fugf.Get(tp,"D")>0 end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	if #fugf.Get(tp,"D")==0 then return end
	local n = math.min(cm.chk[tp+1]+2, #fugf.Get(tp,"D"))
	Duel.ConfirmDecktop(tp,n)
	local g=fugf.Filter(Duel.GetDecktopGroup(tp,n),"IsTyp+IsSSetable","T")
	if #g>0 and Duel.SelectYesNo(tp,1153) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		g=g:Select(tp,1,1,nil):GetFirst()
		if Duel.SSet(tp,g)>0 and fu_HC.chk[tp+1]>0 then
			fuef.S(e,EFFECT_TRAP_ACT_IN_SET_TURN,g):PRO("SET"):RES("STD")
		end
	end
	Duel.ShuffleDeck(tp)
end
--ge1
cm.ge1 = fuef.FC("PHS+DP"):OP("gop1()")("CH"):Func("gcon1,gop1(1)")("NEGA"):OP("gop1", -1)
function cm.gcon1(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP)
end
function cm.gop1(n)
	return function(e,tp,eg,ep,ev,re,r,rp)
		if tonumber(n) then 
			cm.chk[re:GetHandlerPlayer()+1] = cm.chk[re:GetHandlerPlayer()+1] + n
		else 
			cm.chk = {0, 0}
		end
	end
end