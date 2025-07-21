--忍瞬之圣沌 千手
dofile("expansions/script/c20000175.lua")
local cm, m = fu_HC.Initial()
--e1
cm.e1 = fuef.A():Cat("SP"):Func("tg1,op1")
local e1g1 = fugf.MakeFilter("DR","IsCode/IsSet+(IsTyp+IsSSetable)","175,5fd1,S/T")
local e1g2 = fugf.MakeFilter("G","IsSet+CanSp+%1","5fd1,%2")
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return #e1g1(tp)>0 or #e1g2(tp, fu_HC.IsMantraAct(tp), e)>0 end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local c = fugf.Select(tp, e1g1(tp) + e1g2(tp, fu_HC.IsMantraAct(tp), e)):GetFirst()
	if not c then return end
	local oper = {"SpecialSummon", c, 0, tp, tp, false, false, POS_FACEUP}
	if fucf.IsTyp(c, "S/T") then oper = {"SSet", tp, c}end
	Duel[oper[1] ](table.unpack(oper, 2))
end
--e2
cm.e2 = fuef.QO("SP"):Cat("GA"):Pro("DE+TG"):Ctl(m):Ran("G"):Func("tg2,op2")
local e2f1 = fugf.MakeFilter("M","IsSet+IsTyp+IsPos+InG+TgChk","5fd1,XYZ,FU,%1,%2")
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g = e2f1(tp, eg, e)
	if chkc then return g:IsContains(chkc) end
	if chk==0 then return #g > 0 and e:GetHandler():IsCanOverlay() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	g = fugf.SelectTg(tp, g)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc = fusf.GetTarget(e, nil, true)
	if not tc then return end
	fuef.S(e, EFFECT_UPDATE_RANK, tc):Pro("SR"):Ran("M"):Val(1):Res("STD+DIS")
	local c = e:GetHandler()
	if fucf.Filter(c,"~(IsRelateToEffect/IsCanOverlay/GChk)",e) then return end
	Duel.BreakEffect()
	Duel.Overlay(tc, c)
end