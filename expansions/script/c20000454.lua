--创导龙裔的秘仪
dofile("expansions/script/c20000450.lua")
local cm, m = fu_GD.RS_initial("IsTyp","RI+S")
cm.e1 = fuef.A():CAT("SP"):Func("tg_is_cos,tg1,op1")
--e1
function cm.rm_chk(rc, e, tp, hg, rg, count)
	if not fucf.Filter(rc, "IsTyp+IsRac+CanSp", "RI+M,DR", {e, SUMMON_TYPE_RITUAL, tp, false, true}) then return false end
	hg = hg:Filter(Card.IsCanBeRitualMaterial, rc, rc):Filter(rc.mat_filter or aux.TRUE, rc, tp)
	if #hg == 0 then return false end 
	if not rg then
		for hc in aux.Next(hg) do
			if rc:GetLevel()==aux.RitualCheckAdditionalLevel(hc,rc) and (not rc.mat_group_check or rc.mat_group_check(Group.FromCards(hc),tp)) then return true end
		end
		return false
	end
	rg = rg:Filter(aux.TRUE, rc)
	for hc in aux.Next(hg) do
		local n = math.abs(rc:GetLevel() - aux.RitualCheckAdditionalLevel(hc, rc))
		if not count then 
			if #(rg - hc) >= n and (rg - hc):CheckSubGroup(cm.reg_chk, n, n, e, tp) then 
				return true
			end
		elseif not rg:IsContains(hc) then 
			if n == count and fucf.GChk(rc) then 
				return true
			end
		end
	end
	return false
end
function cm.reg_chk(rg, e, tp, hg, rmg)
	if Duel.GetMZoneCount(tp, rg, tp) == 0 then return false end
	if not hg then return true end
	local diff = 0
	for rc in aux.Next(rmg) do
		local hmg = hg:Filter(Card.IsCanBeRitualMaterial, rc, rc):Filter(rc.mat_filter or aux.TRUE, rc, tp)
		for mc in aux.Next(hmg) do
			diff = diff | (1 << math.abs(rc:GetLevel() - aux.RitualCheckAdditionalLevel(mc, rc)))
		end
	end
	return diff & (1 << #rg) > 0 and fugf.Filter((rmg - rg), cm.rm_chk, {e, tp, hg, rg, #rg}, 1)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg = fugf.GetFilter(tp,"HMG","IsTyp+AbleTo","M,*R")
	local hg = fugf.GetFilter(tp,"H","IsTyp+IsSet","M,bfd4")
	local nrg = fugf.GetFilter(tp, "HG", cm.rm_chk, {e, tp, hg}) -- no rg
	local mrg = fugf.GetFilter(tp, "HG", cm.rm_chk, {e, tp, hg, rg}) -- must rg
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return #(nrg + mrg) > 0
	end
	local reg = Group.CreateGroup()
	if #mrg > 0 and (#nrg == 0 or Duel.SelectYesNo(tp,aux.Stringid(m,0))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		reg = rg:SelectSubGroup(tp, cm.reg_chk, true, 1, #rg, e, tp, hg, (nrg + mrg))
		Duel.Remove(reg,POS_FACEUP,REASON_COST)
	end
	reg:KeepAlive()
	e:SetLabelObject(reg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local rg = e:GetLabelObject()
	local hg = fugf.GetFilter(tp,"H","IsTyp+IsSet","M,bfd4")
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc = fugf.Select(tp,"HG",cm.rm_chk,{e,tp,hg,rg,#rg}):GetFirst()
	if not tc then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	hg = fugf.Filter(hg,"IsLv+IsCanBeRitualMaterial",{tc:GetLevel()-#rg,tc}):FilterSelect(tp,tc.mat_filter or aux.TRUE,1,1,tc,tp)
	tc:SetMaterial(hg)
	Duel.ReleaseRitualMaterial(hg)
	Duel.BreakEffect()
	Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
	tc:CompleteProcedure()
end