--圣沌大忍者 萨婆诃
dofile("expansions/script/c20000175.lua")
local cm, m = fu_HC.MInitial(nil, 6)
--e1
cm.e1 = fuef.FTO("TG"):Cat("GA"):Pro("DE"):Ran("M"):Func("cos1,con1,tg1,op1")
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return fugf.Filter(eg, "IsSet+IsTyp+IsPLoc", "5fd1,T,MSD", 1)
end
function cm.cos1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
local e1g1 = fugf.MakeFilter("G","IsTyp+IsSSetable","T")
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g = e1g1(tp)
	if chk==0 then return #g > 0 end
	Duel.SetOperationInfo(0, CATEGORY_LEAVE_GRAVE, g, 1, 0, 0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SET)
	local g = fugf.Select(tp, e1g1(tp), "GChk")
	if #g == 0 then return end
	Duel.SSet(tp, g)
	fuef.S(e, EFFECT_TRAP_ACT_IN_SET_TURN, g):Des(0):Pro("HINT+SET"):Res("STD")
end
