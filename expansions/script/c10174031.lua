--超量连接人
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=10174031
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2)
	local e1=rsef.SV_CANNOT_BE_MATERIAL(c,"link",nil,nil,nil,"cd,uc")
	local e2=rsef.I(c,{m,1},{1,m},"sp",nil,LOCATION_MZONE,nil,nil,cm.tg,cm.op)
	local e3=rsef.I(c,{m,0},{1,m+100},nil,nil,LOCATION_MZONE,nil,rscost.reglabel(100),cm.lvtg,cm.lvop)
end
function cm.rmfilter(c,lg,tp)
	return c:IsLevelBelow(8) and c:IsAbleToRemoveAsCost() and lg:IsExists(cm.lvfilter,1,nil,c:GetLevel())
end
function cm.lvfilter(c,lv)
	return c:IsFaceup() and c:IsLevelAbove(1) and not c:IsLevel(lv)
end
function cm.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local lg=c:GetLinkedGroup()
	if chk==0 then 
		return e:GetLabel()==100 and #lg>0 and Duel.IsExistingMatchingCard(cm.rmfilter,tp,LOCATION_GRAVE,0,1,nil,lg,tp)
	end
	e:SetLabel(0)
	rshint.Select(tp,"rm")
	local rg=Duel.SelectMatchingCard(tp,cm.rmfilter,tp,LOCATION_GRAVE,0,1,1,nil,lg,tp)
	if #rg>0 then
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
		e:SetValue(rg:GetFirst():GetLevel())
	end
end
function cm.lvop(e,tp)
	local c=e:GetHandler()
	local lv=e:GetValue()
	local lg=c:GetLinkedGroup():Filter(cm.lvfilter,nil,lv)
	if #lg<=0 then return end
	for tc in aux.Next(lg) do
		local e1=rsef.SV_CHANGE({c,tc},"lv",lv,nil,rsreset.est)
	end 
end
function cm.xyzfilter(c,mg,tp)
	return mg:CheckSubGroup(cm.cfilter,1,3,tp,c)
end
function cm.cfilter(g,tp,xyzc)
	local tc=g:GetFirst()
	return g:FilterCount(Card.IsLocation,nil,LOCATION_HAND)<=1 and g:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)<=1 and g:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)<=1 and xyzc:IsXyzSummonable(g,#g,#g) and (#g~=1 or tc:IsOnField())
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND,0,nil,TYPE_MONSTER)
	local g2=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local g3=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_MONSTER)
	local matg=rsgf.Mix2(g1,g2,g3)
	local xyzg=Duel.GetMatchingGroup(cm.xyzfilter,tp,LOCATION_EXTRA,0,nil,matg,tp)
	if chk==0 then return #xyzg>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.op(e,tp,eg)
	local g1=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND,0,nil,TYPE_MONSTER)
	local g2=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local g3=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_MONSTER)
	local matg=rsgf.Mix2(g1,g2,g3)
	local xyzg=Duel.GetMatchingGroup(cm.xyzfilter,tp,LOCATION_EXTRA,0,nil,matg,tp)
	if #xyzg<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local xyzc=xyzg:Select(tp,1,1,nil):GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local matg2=matg:SelectSubGroup(tp,cm.cfilter,false,1,3,tp,xyzc)
	Duel.XyzSummon(tp,xyzc,matg2)
	if matg2:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_HAND) then
		Duel.ShuffleHand(tp)
	end
end
