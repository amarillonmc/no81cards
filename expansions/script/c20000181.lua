--圣沌忍者 曼怛罗
dofile("expansions/script/c20000175.lua")
local cm, m = fu_HC.MInitial("chk")
--AddCounter
fusf.AddCounter(m, "CH", "counter")
function cm.counter(re, tp, cid)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP)
end
--e1
cm.e1 = fuef.ProcXyzLv(3)
--e2
cm.e2 = fuef.ProcXyz("FALSE", nil, 1, 1, "exop", "excf"):Ctl(m)
function cm.exop(e, xyzc, tp, chk)
	if chk==0 then return fusf.GetCounter(m, tp, "CH", 1) or (cm.chk[tp + 1] > 0) end
end
cm.excf = fucf.MakeCardFilter("IsTyp+IsLoc", "T,G")
--e3
cm.e3 = fuef.I():Ran("M"):Func("cos3,tg3,op3")
function cm.cos3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
local e3g1 = fugf.MakeFilter("DR","IsCode+IsSSetable","175")
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return #e3g1(tp) > 0 end
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	Duel.SSet(tp, fugf.Select(tp, e3g1(tp)))
end
--ge1
cm.ge1 = fuef.FC("PH+ED"):Ctl(1):Con("gcon1")
function cm.gcon1(e,tp,eg,ep,ev,re,r,rp)
	cm.chk = {fusf.GetCounter(m, 0, "CH"), fusf.GetCounter(m, 1, "CH")}
	return false
end