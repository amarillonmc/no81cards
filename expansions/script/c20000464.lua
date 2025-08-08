--构龙之创导
dofile("expansions/script/c20000450.lua")
local cm, m = fusf.Initial(fu_GD)
fusf.AddCode(463)
--e1
cm.e1 = fuef.A():Cat("REL+SP+EQ"):Func("tg1,op1")
function cm.tg1f2(c, tp, rc, eg)
	return fugf.Filter(eg, "CanBeEq+IsLv+Not", {{tp, rc}, -c:GetLevel(), c}, 1)
end
function cm.tg1f1(rc, e, tp, mg, eg)
	if fucf.Filter(rc, "~(IsTyp+IsCode+CanSp)", "RI+M,463,(%1,RI)", e) then return false end
	mg = mg:Filter(Card.IsCanBeRitualMaterial, rc, rc):Filter(rc.mat_filter or aux.TRUE, rc, tp)
	return fugf.Filter(mg, cm.tg1f2, {tp, rc, eg}, 1)
end
local e1g1 = fugf.MakeFilter("D", cm.tg1f1, "%1,%2,%3,%4")
local function GetME(tp)
	local mg = fugf.Filter(Duel.GetRitualMaterial(tp), "IsLoc+IsSet+IsPublic", "H,bfd4")
	local eg = fugf.GetFilter(tp, "HG", "IsTyp+IsRac", "RI+M,DR")
	return mg, eg
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return #e1g1(tp, e, tp, GetME(tp)) > 0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local mg, eg = GetME(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local rc = fugf.Select(tp, e1g1(tp, e, tp, mg, eg)):GetFirst()
	if not rc then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	mg = mg:Filter(Card.IsCanBeRitualMaterial, rc, rc):Filter(rc.mat_filter or aux.TRUE, rc, tp)
	mg = fugf.Select(tp, mg, cm.tg1f2, {tp, rc, eg})
	fu_GD.Hint(tp, m, mg, rc)
	rc:SetMaterial(mg)
	Duel.ReleaseRitualMaterial(mg)
	Duel.BreakEffect()
	Duel.SpecialSummon(rc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
	rc:CompleteProcedure()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	eg = fugf.Select(tp, eg, "CanBeEq+IsLv", {{tp, rc}, -mg:GetFirst():GetLevel()}):GetFirst()
	fusf.Equip(e, tp, eg, rc)
	fuef.S(e, EFFECT_SELF_DESTROY, rc):Pro("IG+SR"):Ran("M"):Con(cm.op1con1):Res("STD")
end
function cm.op1con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipCount() == 0
end
--e2
cm.e2 = fuef.I():Cat("EQ"):Ran("G"):Pro("TG"):Func("bfgcost,tg2,op2")
function cm.tg2f1(c, e, g, tp)
	if fucf.Filter(c,"~(IsPos+IsTyp+TgChk+IsAbleToChangeControler)","FU,EF,%1",e) then return false end
	return fugf.Filter(g, "CanEq", {c, tp}, 1)
end
local e2g2 = fugf.MakeFilter("M", "IsPos+IsCode", "FU,463")
local e2g1 = fugf.MakeFilter("+M", cm.tg2f1, "%1,%2,%3")
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g = e2g1(tp, e, e2g2(tp), tp)
	if chkc then return g:IsContains(chkc) end
	if chk==0 then return #g > 0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	g = fugf.SelectTg(tp, g)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local ec = fusf.GetTarget(e, "FU")
	if not ec or ec:IsControler(tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local c = fugf.Select(tp, e2g2(tp), "CanEq", {ec, tp}):GetFirst()
	fusf.Equip(e, tp, ec, c)
end