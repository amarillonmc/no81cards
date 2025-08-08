--创导龙裔的煉成
dofile("expansions/script/c20000450.lua")
local cm, m = fusf.Initial(fu_GD)
--e1
cm.e1 = fuef.A()
--e2
cm.e2 = fuef.QO():Cat("SP"):Ran("S"):Ctl(m):Func("con2,tg2,op2")
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return fugf.GetFilter(tp,"H","IsPublic",nil,1)
end
function cm.tg2f2(g, tp, c, lv)
	local mc = #fugf.Filter(g, "IsLoc", "M")
	if mc > 1 or (mc == 1 and Duel.GetMZoneCount(tp, g, tp) == 0) then return false end
	Duel.SetSelectedCard(g)
	return g:CheckWithSumGreater(Card.GetRitualLevel, lv, c) and (c.mat_group_check or aux.TRUE)(g, tp)
end
function cm.tg2f1(rc, e, tp, mg, hg)
	if fucf.Filter(rc, "~(IsTyp+IsRac+CanSp)", "RI+M,DR,(%1,RI)", e) then return false end
	local lv = rc:GetLevel()
	hg = hg:Filter(Card.IsCanBeRitualMaterial, rc, rc):Filter(rc.mat_filter or aux.TRUE, rc, tp)
	if hg:CheckSubGroup(cm.tg2f2, 1, 1, tp, rc, lv) then return true end
	mg = mg:Filter(Card.IsCanBeRitualMaterial, rc, rc):Filter(rc.mat_filter or aux.TRUE, rc, tp)
	aux.GCheckAdditional = aux.RitualCheckAdditional(rc, lv, "Greater")
	local res = mg:CheckSubGroup(cm.tg2f2, 1, math.min(#mg, lv), tp, rc, lv)
	aux.GCheckAdditional = nil
	return res
end
local function GetRM(e, tp)
	local mg = Duel.GetRitualMaterial(tp)
	local hg = fugf.Filter(mg, "IsLoc+IsPublic", "H")
	mg = fugf.Filter(mg, "IsTyp+IsRac+IsLoc", "RI+M,DR,M")
	return fugf.GetFilter(tp, "HG", cm.tg2f1, "%1,%2,%3,%4", nil, e, tp, mg, hg), mg + hg
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return #GetRM(e, tp)> 0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local rg, mg = GetRM(e, tp)
	local rc, sg
	repeat
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		rc = fugf.Select(tp, rg, "GChk"):GetFirst()
		if not rc then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		sg = mg:Filter(Card.IsCanBeRitualMaterial, rc, rc):Filter(rc.mat_filter or aux.TRUE, rc, tp)
		local lv = rc:GetLevel()
		aux.GCheckAdditional = aux.RitualCheckAdditional(rc, lv, "Greater")
		sg = sg:SelectSubGroup(tp, cm.tg2f2, true, 1, math.min(#sg, lv), tp, rc, lv)
		aux.GCheckAdditional = nil
	until sg
	fu_GD.Hint(tp, m, sg, rc)
	rc:SetMaterial(sg)
	Duel.ReleaseRitualMaterial(sg)
	Duel.BreakEffect()
	Duel.SpecialSummon(rc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
	rc:CompleteProcedure()
end
--e3
function cm.f3(tp, eg)
	local mg = Group.CreateGroup()
	for rc in aux.Next(fugf.Filter(eg,"IsSTyp+IsRac","RI,DR")) do
		mg = mg + fugf.Filter(rc:GetMaterial(),"IsLoc+IsTyp+AbleTo","G,M,D")
	end
	return mg
end
cm.e3 = fuef.FTO("SP"):Cat("TD+DR+GA"):Ran("S"):Ctl(1):Func("con3,Ptg(%1),Pop(%1)", cm.f3)
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	return fugf.Filter(eg,"IsSTyp+IsRac","RI,DR",1)
end