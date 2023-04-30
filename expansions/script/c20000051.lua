--无亘皇帝之显现
if not pcall(function() require("expansions/script/c20000000") end) then require("script/c20000000") end
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,20000050)
	local e1=fuef.B_A(c,nil,"SP",nil,nil,nil,nil,nil,cm.tg1,cm.op1,c)
end
--e1
function cm.Rf1(c)
	return c:IsCode(20000050)
end
function cm.Rmgf1(n,chk)
	if chk then
		return function(tp,g,c) return #fugf.Filter(g,fucf.IsLoc,"D")<=n end
	else
		return function(g) return #fugf.Filter(g,fucf.IsLoc,"D")<=n end
	end
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		local rg=fugf.GetFilter(tp,"D","IsSetCard+IsLevelAbove+AbleTo",{0xafd1,1,"R"})
		local n=Duel.GetFlagEffect(tp,m)==0 and 1 or 0
		aux.RCheckAdditional=cm.Rmgf1(n,1)
		aux.RGCheckAdditional=cm.Rmgf1(n)
		local res=fugf.GetFilter(tp,"HG",aux.RitualUltimateFilter,{cm.Rf1,e,tp,mg,rg,Card.GetLevel,"Greater"},nil,1)
		aux.RCheckAdditional=nil
		aux.RGCheckAdditional=nil
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,LOCATION_DECK)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp)
	local rg=fugf.GetFilter(tp,"D","IsSetCard+IsLevelAbove+AbleTo",{0xafd1,1,"R"})
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local n=Duel.GetFlagEffect(tp,m)==0 and 1 or 0
	aux.RCheckAdditional=cm.Rmgf1(n,1)
	aux.RGCheckAdditional=cm.Rmgf1(n)
	local tc=fugf.SelectFilter(tp,"HG",aux.NecroValleyFilter(aux.RitualUltimateFilter),{cm.Rf1,e,tp,mg,rg,Card.GetLevel,"Greater"},nil,1):GetFirst()
	if not tc then return end
	mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
	mg:Merge(rg)
	mg=mg:Filter(tc.mat_filter or aux.TRUE,tc,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
	mg=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater")
	aux.GCheckAdditional=nil
	if not mg or #mg==0 then
		aux.RCheckAdditional=nil
		aux.RGCheckAdditional=nil
		return
	end
	tc:SetMaterial(mg)
	rg=fugf.Filter(mg,fucf.IsLoc,"D")
	if #rg>0 then
		mg:Sub(rg)
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	end
	Duel.ReleaseRitualMaterial(mg)
	Duel.BreakEffect()
	Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
	tc:CompleteProcedure()
	aux.RCheckAdditional=nil
	aux.RGCheckAdditional=nil
end