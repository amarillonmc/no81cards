--触手型异生兽 库土拉
if not pcall(function() require("expansions/script/c25000033") end) then require("script/c25000033") end
local m,cm=rscf.DefineCard(25000038)
function cm.initial_effect(c)
	rssb.SummonCondition(c)  
	local e1=rsef.I(c,{m,0},{1,m},"rm,sp,se",nil,LOCATION_HAND,rssb.cfcon,nil,cm.tg,cm.op)
	local e2=rsef.I(c,{m,1},{1,m+100},"rm",nil,LOCATION_MZONE,nil,rssb.rmtdcost(1),cm.hdtg,cm.hdop)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetDecktopGroup(tp,3)
	if chk==0 then return #g==3 and g:FilterCount(rssb.rmfilter,nil)==3 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=aux.ExceptThisCard(e)
	local g=Duel.GetDecktopGroup(tp,3)
	if #g~=3 or g:FilterCount(rssb.rmfilter,nil)~=3 then return end
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	if #g>0 then
		Duel.DisableShuffleCheck()
		if g:IsExists(rssb.IsSetM,1,nil) then
			if Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)>0 and c then
				rssf.SpecialSummon(c)
			end
		else
			Duel.ShuffleDeck(tp)
		end
	end
end
function cm.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
end
function cm.hdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
	if g:GetCount()>0 then
		local sg=g:RandomSelect(tp,1)
		Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
	end
end