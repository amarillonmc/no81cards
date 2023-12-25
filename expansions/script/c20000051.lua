--无亘皇帝之显现
xpcall(function() dofile("expansions/script/c20000000.lua") end,function() dofile("script/c20000000.lua") end)
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,20000050)
	_ = fuef.A(c) + "CAT:SP,TG:tg1,OP:op1"
end
--e1
cm.Rf1 = function(c) return c:IsCode(20000050) end
function cm.Rmgf1(n,chk)
	if chk then
		return function(tp,g,c) return #fugf.Filter(g,"IsLoc","D")<=n end
	else
		return function(g) return #fugf.Filter(g,"IsLoc","D")<=n end
	end
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		local rg=fugf.GetFilter(tp,"D","IsSet+AbleTo+IsLv","3fd0,R,+1")
		local n=Duel.GetFlagEffect(tp,m)==0 and 1 or 0
		aux.RCheckAdditional=cm.Rmgf1(n,1)
		aux.RGCheckAdditional=cm.Rmgf1(n)
		n = fugf.GetFilter(tp,"HG","RitualUltimateFilter",{cm.Rf1,e,tp,mg,rg,Card.GetLevel,"Greater"},1)
		aux.RCheckAdditional=nil
		aux.RGCheckAdditional=nil
		return n
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,LOCATION_DECK)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp)
	local rg=fugf.GetFilter(tp,"D","IsSet+AbleTo+IsLv","3fd0,R,+1")
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local n=Duel.GetFlagEffect(tp,m)==0 and 1 or 0
	aux.RCheckAdditional=cm.Rmgf1(n,1)
	aux.RGCheckAdditional=cm.Rmgf1(n)
	local tc=fugf.SelectFilter(tp,"HG","RitualUltimateFilter+GChk",{{cm.Rf1,e,tp,mg,rg,Card.GetLevel,"Greater"}}):GetFirst()
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
	rg=fugf.Filter(mg,"IsLoc","D")
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