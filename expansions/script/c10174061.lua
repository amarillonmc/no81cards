--四位一体
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(10174061)
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,nil,"sp",nil,nil,rscost.reglabel(100),cm.tg,cm.op)   
end
function cm.gfilter(g,e,tp)
	return aux.dabcheck(g) and aux.mzctcheck(g,tp) and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,g,e,tp)
end
function cm.spfilter(c,g,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and  (c:IsLocation(LOCATION_DECK) and Duel.GetMZoneCount(tp,g)>0
			or c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,g,c)>0)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetReleaseGroup(tp)
	if chk==0 then 
		if e:GetLabel()==100 then return g:CheckSubGroup(cm.gfilter,4,4,e,tp) 
		else 
			return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,nil,e,tp)
		end
	end
	local att=0
	if e:GetLabel()==100 then
		e:SetLabel(0)
		rshint.Select(tp,"res")
		local rg=g:SelectSubGroup(tp,cm.gfilter,false,4,4,e,tp)
		Duel.Release(rg,REASON_COST)
		for tc in aux.Next(Duel.GetOperatedGroup()) do
			local patt=tc:GetPreviousAttributeOnField()
			att=att|patt
		end
	end
	e:SetValue(att)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local ct,og=rsop.SelectSpecialSummon(tp,cm.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,{},nil,e,tp)
	local att=e:GetValue()
	if ct>0 and att>0 then
		local tc=og:GetFirst()
		tc:SetHint(CHINT_ATTRIBUTE,att)
		local e1=rsef.SV_ADD({c,tc,true},"att",att,nil,rsreset.est)
		local e2=rsef.SV_IMMUNE_EFFECT({c,tc,true},cm.imval(att),nil,rsreset.est)
		local e3=rsef.SV_CANNOT_BE_TARGET({c,tc,true},"battle",cm.btval(att),nil,rsreset.est)
	end
end
function cm.imval(att)
	return function(e,re)
		return rsval.imoe(e,re) and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():GetAttribute()&att>0
	end
end
function cm.btval(att)
	return function(e,c)
		return aux.imval1(e,c) and c:IsControler(1-e:GetHandlerPlayer()) and c:GetAttribute()&att>0
	end
end