--光之巨人 闪亮戴拿
if not pcall(function() require("expansions/script/c25010001") end) then require("script/c25010001") end
local m,cm=rscf.DefineCard(25010004)
function cm.initial_effect(c)
	rsgol.TigaSummonFun(c,m,m+1,m+2,rscon.turno,cm.sprcon,cm.sprop)
	local e1=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,0},{1,m},"dr,dish","ptg,de,dsp",nil,nil,rsop.target2(cm.fun,1,"dr"),cm.drop)
end
function cm.sprcon(e,c,tp)
	return Duel.IsExistingMatchingCard(cm.sprcfilter,tp,LOCATION_MZONE,0,1,nil,tp,c)
end
function cm.sprcfilter(c,tp,fc)
	return c:IsFaceup() and not c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToDeckOrExtraAsCost() and Duel.IsExistingMatchingCard(cm.sprcfilter2,tp,LOCATION_REMOVED,0,1,nil,tp,fc,c)
end
function cm.sprcfilter2(c,tp,fc,c2)
	return c:IsAbleToDeckOrExtraAsCost() and c:IsAttribute(ATTRIBUTE_LIGHT) and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,c2),fc)>0 and c:IsFaceup()
end
function cm.sprop(e,tp)
	local c=e:GetHandler()
	rshint.Select(tp,"td")
	local g1=Duel.SelectMatchingCard(tp,cm.sprcfilter,tp,LOCATION_MZONE,0,1,1,nil,tp,c)
	rshint.Select(tp,"td")
	local g2=Duel.SelectMatchingCard(tp,cm.sprcfilter2,tp,LOCATION_REMOVED,0,1,1,nil,tp,c,g1:GetFirst())
	Duel.SendtoDeck((g1+g2),nil,2,REASON_COST)
end
function cm.fun(g,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)~=0 then
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end