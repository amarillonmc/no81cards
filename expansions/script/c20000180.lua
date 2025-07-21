--圣沌忍法 后门
dofile("expansions/script/c20000175.lua")
local cm, m = fu_HC.Initial("chk")
cm.e1 = fuef.A()
--e2
cm.e2 = fuef.FTO("CH"):Cat("SP"):Pro("DE"):Ran("F"):Ctl(1):Func("con2,tg2,op2")
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	if not fusf.IsPhase("BP") then return false end
	return rp == tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP)
end
local e1g1 = fugf.MakeFilter("M", "IsSet+IsPos+IsTyp", "5fd1,FU,XYZ")
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return #e1g1(tp)>0 end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local g = e1g1(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	g = fugf.Select(tp, g)
	Duel.HintSelection(g)
	fuef.S(e, EFFECT_UPDATE_RANK, g):Pro("SR"):Ran("M"):Val(1):Res("STD+DIS")
	g = fugf.Filter(g:GetFirst():GetOverlayGroup(), "IsSet+CanSp", "5fd1,%1", nil, e)
	if #g == 0 or not Duel.SelectYesNo(tp, 1152) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	g = fugf.Select(tp, g)
	Duel.BreakEffect()
	Duel.SpecialSummon(g, 0, tp, tp, false, false, POS_FACEUP)
end
--e3
cm.e3 = fuef.FTF("PH+BPE"):Ctl(1):Ran("F"):Func("op3")
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local ct = fusf.GetCounter(175, tp, "CH") - cm.chk[tp + 1]
	local g = fugf.GetFilter(tp, "G", "IsSet+IsTyp+IsSSetable+GChk", "5fd1,T")
	if #g == 0 or ct == 0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	g = g:Select(tp,1,ct,nil)
	Duel.SSet(tp, g)
end
--ge1
cm.ge1 = fuef.FC("PHS+BPE"):Op("gop1")
function cm.gop1(e,tp,eg,ep,ev,re,r,rp)
	cm.chk = {fusf.GetCounter(175, 0, "CH"), fusf.GetCounter(175, 1, "CH")}
end