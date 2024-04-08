--无亘帝皇之显现
xpcall(function() dofile("expansions/script/c20000000.lua") end,function() dofile("script/c20000000.lua") end)
local cm,m,o=GetID()
function cm.initial_effect(c)
	fuef.A(c):CAT("SP"):Func("tg1,op1")
	cm.chks = {"IsRac", "IsAtt", "IsAtk", "IsDef", "IsLv/IsRLv"}
end
--e1
function cm.gettn(c)  -- card type count 
	local tn = 0
	for i,chk in ipairs(cm.chks) do
		if fucf.Filter(c, chk, cm.vals[i]) then tn = tn|(1<<i) end
	end
	return tn
end
function cm.tnchk(tn)  -- material type count chk
	local res = 0
	for i = 1, 5 do
		if tn&(1<<i) > 0 then res = res + 1 end
	end
	return res > 2
end
function cm.mmchk(c, mg)  -- material must chk
	local g, res = mg - c, 0
	for i,chk in ipairs(cm.chks) do
		if fugf.Filter(g, chk, cm.vals[i], 1) then res = res + 1 end
	end
	return res > 2 and cm.mgchk(g)
end
function cm.mgchk(g, mmchk)  -- material group chk
	local dchk = Duel.GetFlagEffect(cm.tp,m) == 0
	if not (Duel.GetMZoneCount(cm.tp, g, cm.tp) > 0 and (not cm.rc.mat_group_check or cm.rc.mat_group_check(g, cm.tp)) 
		and #fugf.Filter(g,"IsLoc","D") <= (dchk and 1 or 0) and (not aux.RCheckAdditional or aux.RCheckAdditional(cm.tp, g, cm.rc))) then
		return false 
	end
	return not (mmchk and g:IsExists(cm.mmchk, 1, nil, g))
end
function cm.mfchk(mg, sg, tn)  -- material filter chk
	if cm.tnchk(tn) and cm.mgchk(sg, true) then return true end
	for c in aux.Next(mg) do
		local ctn = cm.gettn(c)
		if tn|ctn > tn and cm.mfchk(mg - c, sg + c, tn|ctn) then return true end
	end
	return false
end
function cm.cut_cant(mg, sg, gtn)
	local g, rg = mg - sg, Group.CreateGroup()
	for c in aux.Next(g) do
		local ctn = cm.gettn(c)
		if gtn|ctn > gtn and cm.mfchk(g - c, sg + c, gtn|ctn) then rg = rg + c end
	end
	return rg
end
function cm.rchk(c,e,tp,m1,m2)
	if not fucf.Filter(c,"IsTyp+IsSet+CanSp", "RI+M,bfd0", {e,SUMMON_TYPE_RITUAL,tp,false,true}) then return false end
	cm.rc, cm.vals = c, {"DR", "DA", "3000", "2500", {8, {8, c}}}
	m1 = m1:Filter(Card.IsCanBeRitualMaterial,c,c)
	if Duel.GetFlagEffect(tp,m) == 0 then m1 = m1 + m2 end
	m1, m2 = m1:Filter(c.mat_filter or aux.TRUE,c,tp), Group.CreateGroup()
	for i,chk in ipairs(cm.chks) do
		m2 = m2 + fugf.Filter(m1, chk, cm.vals[i])
	end
	return cm.mfchk(m2, Group.CreateGroup(), 0)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	cm.tp = tp
	if chk==0 then
		local mg = Duel.GetRitualMaterialEx(tp)
		local rg = fugf.GetFilter(tp,"D","IsSet+AbleTo+IsTyp","3fd0,R,M")
		return fugf.GetFilter(tp,"HG",cm.rchk,{e,tp,mg,rg},1)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,LOCATION_DECK)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	::cancel::
	local mg = Duel.GetRitualMaterialEx(tp)
	local rg = fugf.GetFilter(tp,"D","IsSet+AbleTo+IsTyp","3fd0,R,M")
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local rc = fugf.SelectFilter(tp,"HG",cm.rchk,{e,tp,mg,rg}):GetFirst()
	if not rc then return end
	cm.rc, cm.tp = rc, tp
	mg = mg:Filter(Card.IsCanBeRitualMaterial,rc,rc)
	if Duel.GetFlagEffect(tp,m) == 0 then mg = mg + rg end
	mg, rg = mg:Filter(rc.mat_filter or aux.TRUE,rc,tp), Group.CreateGroup()
	for i,chk in ipairs(cm.chks) do
		rg = rg + fugf.Filter(mg, chk, cm.vals[i])
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local canfinish, gtn = false, 0
	mg = Group.CreateGroup()
	while not canfinish do
		collectgarbage("collect")
		local g = cm.cut_cant(rg, mg, gtn)
		local tc = g:SelectUnselect(mg,tp,canfinish,not canfinish)
		if not tc then break end
		Group[mg:IsContains(tc) and "RemoveCard" or "AddCard"](mg,tc)
		gtn = 0
		for sc in aux.Next(mg) do
			gtn = gtn|cm.gettn(sc)
		end
		canfinish = cm.tnchk(gtn) and cm.mgchk(mg, gtn, true)
	end
	if #mg == 0 then goto cancel end
	rc:SetMaterial(mg)
	rg = fugf.Filter(mg,"IsLoc","D")
	if #rg > 0 then
		mg:Sub(rg)
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	end
	Duel.ReleaseRitualMaterial(mg)
	Duel.BreakEffect()
	Duel.Hint(24,0,aux.Stringid(m,0)) 
	Duel.SpecialSummon(rc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
	rc:CompleteProcedure()
end