--诡诈连线
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(10174049)
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,{m,0},{1,m,1},"sp",nil,nil,nil,cm.tg,cm.act)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_EXTRA,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_EXTRA)
end
function cm.lfilter(c)
	return c:IsType(TYPE_LINK) and c:IsLinkSummonable(nil)
end
function cm.act(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	if #g<=0 then return end
	Duel.ConfirmCards(tp,g)
	local lg=g:Filter(cm.lfilter,nil)
	if #lg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		rshint.Select(tp,"sp")
		local lc=lg:Select(tp,1,1,nil):GetFirst()
		Duel.ConfirmCards(1-tp,lc)
		Duel.LinkSummon(1-tp,lc,nil)
	end
end
