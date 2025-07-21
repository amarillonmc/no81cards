--圣沌大忍者 萨婆诃
dofile("expansions/script/c20000175.lua")
local cm, m = fu_HC.MInitial(nil, 6)
--e1
cm.e1 = fuef.FTO("TG"):Cat("GA"):Pro("DE"):Ran("M"):Func("cos1,tg1,op1")
function cm.cos1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return fugf.Filter(eg, "IsSet+IsTyp+IsSSetable", "5fd1,T", 1) end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g = fugf.Select(tp, "G", "IsTyp+IsSSetable", "T")
	if #g == 0 then return end
	Duel.SSet(tp, g)
	fuef.S(e,EFFECT_TRAP_ACT_IN_SET_TURN,g):Pro("SET"):Res("STD")
end
