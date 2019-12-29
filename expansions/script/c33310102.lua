--睡美人的小憇
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rsof.DefineCard(33310102)
function cm.initial_effect(c)
	local e1=rsef.ACT(c,nil,nil,nil,"sp,rm",nil,nil,nil,cm.tg,cm.act)
	local e2=rsef.I(c,{m,0},nil,"td,th","tg",LOCATION_GRAVE,nil,nil,rstg.target({cm.tdfilter,"td",LOCATION_REMOVED },rsop.list(Card.IsAbleToHand,"th")),cm.tdop)
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) and c:CheckSetCard("Cochrot") and Duel.IsExistingMatchingCard(cm.matfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,c,c,e,tp)
end
function cm.matfilter(c,tc,e,tp)
	if c:GetRitualLevel(tc)<tc:GetLevel() then return false end
	if Duel.GetMZoneCount(tp,c,tp)<=0 then return false end
	if tc.mat_filter and not tc.mat_filter(c,tp) then return false end
	if c:IsLocation(LOCATION_GRAVE) then return
		c:IsAbleToRemove() and c:IsType(TYPE_RITUAL)
	else
		return c:IsReleasableByEffect(e)
	end
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,LOCATION_GRAVE)
end
function cm.act(e,tp)
	rsof.SelectHint(tp,"sp")
	local tc=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if not tc then return end
	rsof.SelectHint(tp,"res")
	local matc=Duel.SelectMatchingCard(tp,cm.matfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,1,tc,tc,e,tp):GetFirst()
	tc:SetMaterial(Group.FromCards(matc))
	if matc:IsLocation(LOCATION_GRAVE) then
		if Duel.Remove(matc,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)==0 then return end
	else
		if Duel.Release(matc,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)==0 then return end
	end
	Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
	tc:CompleteProcedure()
end
function cm.tdfilter(c)
	return c:IsAbleToDeck() and c:CheckSetCard("Cochrot") and c:IsFaceup()
end
function cm.tdop(e,tp)
	local c,tc=aux.ExceptThisCard(e),rscf.GetTargetCard()
	if tc and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_DECK) and c then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end