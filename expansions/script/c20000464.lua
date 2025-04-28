--构龙之创导
dofile("expansions/script/c20000450.lua")
local cm, m = fuef.initial(fu_GD, nil, "AddCode", 463)
cm.e1 = fuef.A():CAT("REL+SP+EQ"):Func("tg1,op1")
cm.e2 = fuef.I():CAT("EQ"):RAN("G"):PRO("TG"):Func("bfgcost,tg2,op2")
--e1
function cm.tg1f2(c, tp)
	return fucf.Filter(c, "IsLoc+IsPublic", "H") and fugf.GetFilter(tp, "HG", "IsTyp+IsRac+CanEq+IsLv+Not", {"RI+M,DR", tp, -c:GetLevel(), c}, 1)
end
function cm.tg1f(rc, e, tp, mg)
	if not fucf.Filter(rc, "IsTyp+IsCode+CanSp", "RI+M,463", {e, "RI", tp}) then return false end
	mg = mg:Filter(Card.IsCanBeRitualMaterial, rc, rc):Filter(rc.mat_filter or aux.TRUE, rc, tp)
	return fugf.Filter(mg, cm.tg1f2, tp, 1)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return fugf.GetFilter(tp,"D",cm.tg1f,{e,tp,Duel.GetRitualMaterial(tp)},1) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local mg = Duel.GetRitualMaterial(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local rc = fugf.Select(tp,"D",cm.tg1f,{e,tp,mg}):GetFirst()
	if not rc then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	mg = mg:Filter(Card.IsCanBeRitualMaterial, rc, rc):Filter(rc.mat_filter or aux.TRUE, rc, tp)
	mg = fugf.Select(tp, mg, cm.tg1f2, tp)
	rc:SetMaterial(mg)
	Duel.ReleaseRitualMaterial(mg)
	Duel.BreakEffect()
	Duel.SpecialSummon(rc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
	rc:CompleteProcedure()
	local mc = mg:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	mc = fugf.Select(tp, "HG", "IsTyp+IsRac+CanEq+IsLv", {"RI+M,DR", tp, -mc:GetLevel()}):GetFirst()
	fusf.Equip(e,tp,mc,rc)
	local selfdescon = function(e) return e:GetHandler():GetEquipCount() == 0 end
	fuef.S(e, EFFECT_SELF_DESTROY, rc):PRO("SR"):RAN("M"):CON(selfdescon):RES("STD")
end
--e2
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g = fugf.GetFilter(tp,"+M","IsPos+IsTyp+TgChk+IsAbleToChangeControler","FU,EF,%1",nil,e)
	if chkc then return g:IsContains(chkc) end
	if chk==0 then return #g>0 and fugf.GetFilter(tp,"M","IsPos+IsCode+CanEq","FU,463,%1",nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	g = fugf.SelectTg(tp,g)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local ec = Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	if not (ec and ec:IsFaceup() and ec:IsRelateToEffect(e) and ec:IsControler(1-tp)) then return end
	local c = fugf.GetFilter(tp,"M","IsPos+IsCode+CanEq","FU,463,%1",nil,tp):GetFirst()
	fusf.Equip(e,tp,ec,c)
end