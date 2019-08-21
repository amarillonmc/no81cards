--空想星界 星辉沼地
local m=10122004
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c10122001") end) then require("script/c10122001") end
function cm.initial_effect(c)
	local e1=rsef.ACT(c)
	local e2=rsul.ToHandActivateEffect(c,m)
	local e3=rsef.QO(c,nil,{m,0},1,"tk,sp","tg",LOCATION_FZONE,nil,rscost.reglabel(100),cm.tg,rsul.TokenOp(nil,nil,2),rsul.hint) 
end
function cm.cfilter(c,tp)
	return c:IsCode(10122011) and rsul.SpecialOrPlaceBool(tp,c,2)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetReleaseGroup(tp)
	local g2=Duel.GetMatchingGroup(Card.IsReleasable,tp,LOCATION_SZONE,0,nil)
	g1:Merge(g2)
	if chk==0 then 
	   if e:GetLabel()==100 then
		  return g1:IsExists(cm.cfilter,1,nil,tp)
	   else
		  return rsul.SpecialOrPlaceBool(tp,nil,2)
	   end
	end
	if e:GetLabel()==100 then
	   e:SetLabel(0)
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	   local rg=g1:FilterSelect(tp,cm.cfilter,1,1,nil,tp)
	   Duel.Release(rg,REASON_COST)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
