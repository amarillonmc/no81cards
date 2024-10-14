--创导龙裔的煉成
dofile("expansions/script/c20000450.lua")
local cm, m = fuef.initial(fu_GD)
--e1
cm.e1 = fuef.A()
--e2
cm.e2 = fuef.QO():CAT("SP"):RAN("S"):CTL(m):Func("con2,tg2,op2")
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return fugf.GetFilter(tp,"H","IsPublic",nil,1)
end
function cm.tg2ff(g,tp,c,lv)
	Duel.SetSelectedCard(g)
	if not (g:CheckWithSumGreater(Card.GetRitualLevel,lv,c) and Duel.GetMZoneCount(tp,g,tp)>0 
		and (not c.mat_group_check or c.mat_group_check(g,tp))) then return false end
	if g:GetFirst():IsLocation(LOCATION_MZONE) then 
		return #g == 1
	end
	return not fugf.Filter(g,"~IsPublic",nil,1)
end
function cm.tg2f(rc,e,tp,mg)
	if not fucf.Filter(rc, "IsTyp+IsRac+CanSp", "RI+M,DR", {e, SUMMON_TYPE_RITUAL, tp, false, true}) then return false end
	mg = mg:Filter(Card.IsCanBeRitualMaterial, rc, rc):Filter(rc.mat_filter or aux.TRUE, rc, tp)
	if fugf.Filter(mg,"IsTyp+IsRac+IsLoc","RI+M,DR,M"):CheckSubGroup(cm.tg2ff,1,1,tp,rc,rc:GetLevel()) then return true end
	return fugf.Filter(mg,"IsLoc+IsPublic","H"):CheckSubGroup(cm.tg2ff,1,#mg,tp,rc,rc:GetLevel())
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return fugf.GetFilter(tp,"HG",cm.tg2f,{e,tp,Duel.GetRitualMaterial(tp)},1) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local mg = Duel.GetRitualMaterial(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local rc = fugf.Select(tp,"HG",aux.NecroValleyFilter(cm.tg2f),{e,tp,mg}):GetFirst()
	if not rc then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	mg = mg:Filter(Card.IsCanBeRitualMaterial, rc, rc):Filter(rc.mat_filter or aux.TRUE, rc, tp)
	mg = fugf.Filter(mg,"IsTyp+IsRac+IsLoc","RI+M,DR,M") + fugf.Filter(mg,"IsLoc+IsPublic","H")
	mg = mg:SelectSubGroup(tp,cm.tg2ff,false,1,#mg,tp,rc,rc:GetLevel())
	rc:SetMaterial(mg)
	Duel.ReleaseRitualMaterial(mg)
	Duel.BreakEffect()
	Duel.SpecialSummon(rc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
	rc:CompleteProcedure()
end
--e3
function cm.f3(e,tp,eg)
	local mg = Group.CreateGroup()
	for rc in aux.Next(fugf.Filter(eg,"IsSTyp+IsRac","RI,DR")) do
		mg = mg + fugf.Filter(rc:GetMaterial(),"IsLoc+IsTyp+AbleTo","G,M,D")
	end
	return mg
end
cm.e3 = fuef.FTO("SP"):CAT("TD+DR+GA"):RAN("S"):CTL(1):Func("con3,N_tg1(%1),N_op1(%1)", cm.f3)
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	return fugf.Filter(eg,"IsSTyp+IsRac","RI,DR",1)
end