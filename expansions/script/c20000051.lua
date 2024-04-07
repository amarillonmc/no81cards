--无亘帝皇之显现
xpcall(function() dofile("expansions/script/c20000000.lua") end,function() dofile("script/c20000000.lua") end)
local cm,m,o=GetID()
function cm.initial_effect(c)
	fuef.A(c):CAT("SP"):Func("tg1,op1")
end
--e1
function cm.tg1f4(g,c)
	local res, chks, vals = 0, "IsRac,IsAtt,IsAtk,IsDef", fusf.CutString("DR,DA,3000,2500",",")
	for i,chk in ipairs(fusf.CutString(chks,",")) do
		if fugf.Filter(g, chk, vals[i], 1) then res = res + 1 end
	end
	if fugf.Filter(g, "IsLv/IsRLv", {8, {8, c}}, 1) then res = res + 1 end
	return res > 2
end
function cm.tg1f3(g,tp,c)
	return cm.tg1f4(g,c) and #fugf.Filter(g,"IsLoc","D") <= (Duel.GetFlagEffect(tp,m) == 0 and 1 or 0) and not g:IsExists(cm.tg1f2,1,nil,g,c)
		and Duel.GetMZoneCount(tp,g,tp)>0 and (not c.mat_group_check or c.mat_group_check(g,tp)) and (not aux.RCheckAdditional or aux.RCheckAdditional(tp,g,c))
end
function cm.tg1f2(c,g,tc)
	return cm.tg1f4(g-c,tc)
end
function cm.tg1f1(c,e,tp,m1,m2)
	if not fucf.Filter(c,"IsTyp+IsSet+CanSp", "RI+M,bfd0", {e,SUMMON_TYPE_RITUAL,tp,false,true}) then return false end
	m1 = m1:Filter(Card.IsCanBeRitualMaterial,c,c) + m2
	m1, m2 = m1:Filter(c.mat_filter or aux.TRUE,c,tp), Group.CreateGroup()  
	local chks, vals = "IsRac,IsAtt,IsAtk,IsDef", fusf.CutString("DR,DA,3000,2500",",")
	for i,chk in ipairs(fusf.CutString(chks,",")) do
		m2 = m2 + fugf.Filter(m1, chk, vals[i])
	end
	m2 = m2 + fugf.Filter(m1, "IsLv/IsRLv", {8, {8, c}})
	m1 = m2:CheckSubGroup(cm.tg1f3,1,#m2,tp,c)
	return m1
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg = Duel.GetRitualMaterialEx(tp)
		local rg = Duel.GetFlagEffect(tp,m) == 0 and fugf.GetFilter(tp,"D","IsSet+AbleTo+IsTyp","3fd0,R,M") or Group.CreateGroup()
		return fugf.GetFilter(tp,"HG",cm.tg1f1,{e,tp,mg,rg},1)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,LOCATION_DECK)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	::cancel::
	local mg = Duel.GetRitualMaterialEx(tp)
	local rg = Duel.GetFlagEffect(tp,m) == 0 and fugf.GetFilter(tp,"D","IsSet+AbleTo+IsTyp","3fd0,R,M") or Group.CreateGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc = fugf.SelectFilter(tp,"HG",cm.tg1f1,{e,tp,mg,rg}):GetFirst()
	if not tc then return end
	mg = mg:Filter(Card.IsCanBeRitualMaterial,tc,tc) + rg
	mg = mg:Filter(tc.mat_filter or aux.TRUE,tc,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	mg = mg:SelectSubGroup(tp,cm.tg1f3,false,1,#mg,tp,tc)
	if #mg == 0 then goto cancel end
	tc:SetMaterial(mg)
	rg = fugf.Filter(mg,"IsLoc","D")
	if #rg > 0 then
		mg:Sub(rg)
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	end
	Duel.ReleaseRitualMaterial(mg)
	Duel.BreakEffect()
	Duel.Hint(24,0,aux.Stringid(m,0)) 
	Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
	tc:CompleteProcedure()
end