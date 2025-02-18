--狱犬龙-三首蛇龙鬼
local cm,m=GetID()
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,nil,cm.lcheck)
	c:EnableReviveLimit()
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(cm.drcon)
	e3:SetTarget(cm.drtg)
	e3:SetOperation(cm.drop)
	c:RegisterEffect(e3)
end
function cm.lcheck(g,lc)
	return g:GetClassCount(Card.GetLinkCode)==g:GetCount()
end
function cm.spfilter1(c,e,tp)
	return (c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp) and Duel.GetMZoneCount(1-tp)>0)
end
function cm.spfilter2(c,e,tp)
	return (c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp)>0)
end
function cm.spfilter(c,e,tp)
	return cm.spfilter1(c,e,tp) or cm.spfilter2(c,e,tp)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_LINK) and c:GetMaterialCount()>0
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsPlayerCanDraw(tp,c:GetMaterialCount()) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(c:GetMaterialCount())
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,c:GetMaterialCount())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)>0 then
		local og=Duel.GetOperatedGroup()
		Duel.ConfirmCards(1-p,og)
		og=og:Filter(Card.IsAbleToDeck,nil)
		if #og>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,1-p,HINTMSG_TODECK)
			local sg=og:Select(1-p,1,1,nil)
			Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
		end
		local g=Duel.GetMatchingGroup(cm.spfilter,p,LOCATION_HAND,0,nil,e,tp)
		if #g>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_SPSUMMON)
			local sc=g:Select(p,1,1,nil):GetFirst()
			local op=aux.SelectFromOptions(tp,{cm.spfilter2(sc,e,tp),aux.Stringid(m,0)},{cm.spfilter1(sc,e,tp),aux.Stringid(m,1)})
			if op==2 then
				Duel.SpecialSummon(sc,0,tp,1-tp,false,false,POS_FACEUP)
			elseif op==1 then
				Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
			end
		end
		local og=Duel.GetMatchingGroup(Card.IsAbleToDeck,p,LOCATION_HAND,0,nil)
		if #og>0 then
			Duel.BreakEffect()
			local sg=og:RandomSelect(p,1)
			Duel.SendtoDeck(sg,nil,1,REASON_EFFECT)
		end
	end
end