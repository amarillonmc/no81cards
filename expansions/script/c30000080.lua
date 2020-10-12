--邪魂钝核 扎托斯
if not pcall(function() require("expansions/script/c30000100") end) then require("script/c30000100") end
local m,cm=rscf.DefineCard(30000080)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1=rscf.AddSpecialSummonProcdure(c,rsloc.hg,cm.sprcon,nil,cm.sprop)
	local e2,e3=rsef.SV_SET(c,"batk,bdef",cm.val)
	local e4=rsef.FV_REDIRECT(c,"tg",LOCATION_REMOVED,nil,{0xff,0xff})
	local e5=rsef.STF(c,EVENT_REMOVE,{m,1},{1,m},"rm,dr",nil,nil,nil,nil,cm.drop)
end
function cm.drop(e,tp)
	local res=false
	for p=0,1 do
		local ct=rsop.SelectRemove(p,Card.IsAbleToRemove,p,LOCATION_HAND,0,2,2,nil,{})
		res= res or ct==2
	end
	if not res then return end
	Duel.BreakEffect()
	for p=0,1 do
		Duel.Draw(p,2,REASON_EFFECT)
	end
end
function cm.val(e,c)
	return Duel.GetFieldGroupCount(0,LOCATION_REMOVED,LOCATION_REMOVED)*300
end
function cm.sprcon(e,c,tp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,rsloc.hog,0,c)
	return g:CheckSubGroup(aux.mzctcheck,5,5) 
end
function cm.sprop(e,tp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,rsloc.hog,0,c)	
	rshint.Select(tp,"rm")
	local rg=g:SelectSubGroup(tp,aux.mzctcheck,false,5,5)
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
end