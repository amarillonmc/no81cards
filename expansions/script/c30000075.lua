--邪魂恶龙 卡利特
if not pcall(function() require("expansions/script/c30000100") end) then require("script/c30000100") end
local m,cm=rscf.DefineCard(30000075)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1=rscf.AddSpecialSummonProcdure(c,rsloc.hg,cm.sprcon,nil,cm.sprop)
	local e2=rsef.I(c,{m,0},1,nil,nil,LOCATION_MZONE,nil,rscost.reglabel(100),cm.lvtg,cm.lvop)
	local e3=rsef.STF(c,EVENT_REMOVE,{m,1},{1,m},"tg",nil,nil,nil,rsop.target(cm.tgfilter,"tg",rsloc.de),cm.tgop)
end
function cm.tgfilter(c)
	return c:IsAbleToGrave() and c:IsLevel(12) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_FIEND)
end
function cm.tgop(e,tp)
	rsop.SelectToGrave(tp,cm.tgfilter,tp,rsloc.de,0,1,1,nil,{})
end
function cm.cfilter1(c,tp,rc)
	local g=Group.FromCards(c)
	if rc then g:AddCard(rc) end
	return c:IsFaceup() and c:IsLevelAbove(1) and c:IsAttribute(ATTRIBUTE_DARK) and Duel.IsExistingMatchingCard(cm.lvfilter,tp,LOCATION_MZONE,0,1,g,c:GetLevel())
end
function cm.lvfilter(c,lv)
	return c:IsLevelAbove(1) and c:IsAttribute(ATTRIBUTE_DARK) and not c:IsLevel(lv)
end
function cm.cfilter0(c,tp)
	return c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(cm.cfilter1,tp,rsloc.mg+LOCATION_REMOVED,0,1,c,tp,c)
end
function cm.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then 
		if e:GetLabel()~=100 then return Duel.IsExistingMatchingCard(cm.cfilter1,tp,rsloc.mg+LOCATION_REMOVED,0,1,nil,tp)
		else
			return Duel.IsExistingMatchingCard(cm.cfilter0,tp,rsloc.hog,0,1,c,tp)
		end
	end
	if e:GetLabel()==100 then
		rshint.Select(tp,"rm")
		local rg=Duel.SelectMatchingCard(tp,cm.cfilter0,tp,rsloc.hog,0,1,1,c,tp)
		Duel.Remove(rg,POS_FACEUP,REASON_COST)
	end
end
function cm.lvop(e,tp)
	rsop.SelectSolve(HINTMSG_SELF,tp,cm.cfilter1,tp,rsloc.mg+LOCATION_REMOVED,0,1,1,nil,{cm.fun,e:GetHandler()},tp)
end
function cm.fun(g,c,tp)
	local tc=g:GetFirst()
	local lv=tc:GetLevel()
	local lg=Duel.GetMatchingGroup(cm.lvfilter,tp,LOCATION_MZONE,0,nil,lv)
	for tc in aux.Next(lg) do
		local e1=rscf.QuickBuff({c,tc},"lv",lv)
	end
end
function cm.sprcon(e,c,tp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,rsloc.ho,0,c)
	return g:CheckSubGroup(aux.mzctcheck,2,2) 
end
function cm.sprop(e,tp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,rsloc.ho,0,c)	
	rshint.Select(tp,"rm")
	local rg=g:SelectSubGroup(tp,aux.mzctcheck,false,2,2)
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
end