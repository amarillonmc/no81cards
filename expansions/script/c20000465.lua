--创导龙裔的再构
dofile("expansions/script/c20000450.lua")
local cm, m = fuef.initial(fu_GD)
cm.e1 = fuef.A("LEA"):CAT("SP+RE"):PRO("DE"):Func("DRM_leave_con,tg1,op1")
cm.e2 = fuef.QO():CAT("TD+DR"):RAN("G"):Func("bfgcost,CanReturnDraw_tg,op2")
--e1
function cm.tg1f1(g,tp,c,lv)
	Duel.SetSelectedCard(g)
	return g:CheckWithSumGreater(Card.GetRitualLevel,lv,c) and Duel.GetMZoneCount(tp,nil,tp)>0 
		and (not c.mat_group_check or c.mat_group_check(g,tp))
end
function cm.tg1f(rc,e,tp,mg)
	if not fucf.Filter(rc,"IsTyp+IsRac+IsPLoc+CanSp","RI+M,DR,M",{e,"RI",tp}) then return false end
	mg = mg:Filter(rc.mat_filter or aux.TRUE, rc, tp)
	return mg:CheckSubGroup(cm.tg1f1,1,#mg,tp,rc,rc:GetLevel())
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg = fugf.GetFilter(tp,"G","IsSet+IsLv+IsTyp+AbleTo","bfd4,+1,M,R")
	if chk==0 then return fugf.Filter(eg,cm.tg1f,{e,tp,mg},1) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local mg = fugf.GetFilter(tp,"G","IsSet+IsLv+IsTyp+AbleTo+GChk","bfd4,+1,M,R")
	local rc = fugf.Filter(eg,aux.NecroValleyFilter(cm.tg1f),{e,tp,mg})
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	if #rc > 1 then rc = fugf.Select(tp,rc) end
	rc = rc:GetFirst()
	if not rc then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	mg = mg:Filter(rc.mat_filter or aux.TRUE, rc, tp)
	mg = mg:SelectSubGroup(tp,cm.tg1f1,false,1,#mg,tp,rc,rc:GetLevel())
	rc:SetMaterial(mg)
	Duel.ReleaseRitualMaterial(mg)
	Duel.BreakEffect()
	Duel.SpecialSummon(rc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
	rc:CompleteProcedure()
end
--e2
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
	local ct = Duel.SendtoDeck(fugf.Select(tp, "H", "AbleTo", "D", 1, 99), nil, 2, REASON_EFFECT)
	if ct == 0 then return end
	fu_GD.DrawReturn(tp, ct)
end
