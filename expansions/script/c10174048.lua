--炼狱的骨蚺
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(10174048)
function cm.initial_effect(c)
	local e1=rsef.QO(c,nil,{m,0},{1,m},"sp,res",nil,LOCATION_HAND,nil,rscost.regflag(m),cm.sptg(1),cm.spop(1))
	local e2=rsef.QO(c,nil,{m,1},{1,m+100},"sp,res",nil,LOCATION_GRAVE,nil,rscost.regflag(m),cm.sptg(2),cm.spop(2))
	local e3=rsef.QO(c,nil,{m,2},{1,m+200},"sp,res",nil,LOCATION_HAND+LOCATION_GRAVE,nil,rscost.regflag(m),cm.sptg(3),cm.spop(3))
end 
function cm.cfilter(c)
	return c:IsReleasableByEffect() and c:IsLevelAbove(7) 
end
function cm.gfilter(g,tp)
	return Duel.GetMZoneCount(tp,g,tp)>0 
end
function cm.sptg(ct)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		local g=Duel.GetReleaseGroup(tp,true):Filter(Card.IsLevelAbove,c,7)
		if chk==0 then return #g>=ct and g:CheckSubGroup(cm.gfilter,ct,ct,tp) end
		Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
		Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
		Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,ct,tp,LOCATION_HAND+LOCATION_MZONE)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
		if ct==3 then
			local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
			Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
		end
	end
end
function cm.spop(ct)
	return function(e,tp)
		local c=aux.ExceptThisCard(e)
		local g=Duel.GetReleaseGroup(tp,true):Filter(Card.IsLevelAbove,c,7)
		if not c or #g<ct then return end
		rshint.Select(tp,"res")
		local rg=g:SelectSubGroup(tp,cm.gfilter,false,ct,ct,tp)
		if #rg>0 and Duel.Release(rg,REASON_EFFECT)>0 and c and rssf.SpecialSummon(c)>0 and ct==3 then 
			local rmg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
			if #rmg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
				Duel.Remove(rmg,POS_FACEUP,REASON_EFFECT)
			end
		end
	end
end