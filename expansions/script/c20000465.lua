--创导龙裔的再构
dofile("expansions/script/c20000450.lua")
local cm, m = fusf.Initial(fu_GD)
--e1
cm.e1 = fuef.A("LEA"):Cat("SP+RE"):Pro("DE"):Func("DRM_leave_con,tg1,op1")
function cm.tg1f2(g, tp, c, lv)
	Duel.SetSelectedCard(g)
	return g:CheckWithSumGreater(Card.GetRitualLevel, lv, c) and (c.mat_group_check or aux.TRUE)(g, tp)
end
function cm.tg1f1(rc, e, tp, mg)
	if fucf.Filter(rc, "~(IsTyp+IsRac+CanSp)", "RI+M,DR,(%1,RI)", e) then return false end
	mg = mg:Filter(rc.mat_filter or aux.TRUE, rc, tp)
	local lv = rc:GetLevel()
	aux.GCheckAdditional = aux.RitualCheckAdditional(rc, lv, "Greater")
	local res = mg:CheckSubGroup(cm.tg1f2, 1, math.min(#mg, lv), tp, rc, lv)
	aux.GCheckAdditional = nil
	return res
end
local e1g1 = fugf.MakeFilter("G", "IsSet+IsLv+IsTyp+AbleTo", "bfd4,+1,M,R")
local e1f1 = fugf.MakeGroupFilter(cm.tg1f1, "%1,%2,%3")
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e1f1(eg, 1, e, tp, e1g1(tp)) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local mg = e1g1(tp)
	local rg = e1f1(eg, nil, e, tp, mg)
	local rc, sg
	repeat
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		rc = fugf.Select(tp, rg, "GChk"):GetFirst()
		if not rc then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		sg = mg:Filter(rc.mat_filter or aux.TRUE, rc, tp)
		local lv = rc:GetLevel()
		aux.GCheckAdditional = aux.RitualCheckAdditional(rc, lv, "Greater")
		sg = sg:SelectSubGroup(tp, cm.tg1f2, true, 1, math.min(#sg, lv), tp, rc, lv)
		aux.GCheckAdditional = nil
	until sg
	Duel.Hint(24, tp, aux.Stringid(m, 0))
	Duel.Hint(24, tp, aux.Stringid(m, 1))
	rc:SetMaterial(sg)
	Duel.ReleaseRitualMaterial(sg)
	Duel.BreakEffect()
	Duel.SpecialSummon(rc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
	rc:CompleteProcedure()
	fu_GD.Hint(tp, m, sg, rc)
end
--e2
cm.e2 = fuef.QO():Cat("TD+DR"):Ran("G"):Func("bfgcost,ReDraw_tg,op2")
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
	local ct = Duel.SendtoDeck(fugf.Select(tp, "H", "AbleTo", "D", 1, 99), nil, 2, REASON_EFFECT)
	if ct == 0 then return end
	fu_GD.DrawReturn(tp, ct)
end