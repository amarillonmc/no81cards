--黑森林的目灯
function c61701027.initial_effect(c)
	aux.AddCodeList(c,61701001)
	c:SetSPSummonOnce(61701027)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c61701027.mfilter,nil,2,2)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	--e1:SetCountLimit(1,61701027)
	e1:SetCondition(c61701027.tgcon)
	e1:SetTarget(c61701027.tgtg)
	e1:SetOperation(c61701027.tgop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetTarget(c61701027.thtg)
	e2:SetOperation(c61701027.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
end
function c61701027.mfilter(c,xyzc)
	return c:IsXyzLevel(xyzc,3) or c:IsRace(RACE_WINDBEAST) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_LINK)
end
function c61701027.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c61701027.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,5) end
end
function c61701027.tgop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,5) then return end
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5)
	if #g~=5 then return end
	Duel.DisableShuffleCheck()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=g:Select(tp,0,5,nil)
	g:Sub(tg)
	Duel.SendtoGrave(tg,REASON_EFFECT+REASON_REVEAL)
	if #g==0 then return end
	Duel.SortDecktop(tp,tp,#g)
	if Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(61701027,0)) then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c61701027.tfilter(c,e,tp)
	return (aux.IsCodeListed(c,61701001) and c:IsType(TYPE_MONSTER) or c:IsRace(RACE_WINDBEAST)) and c:IsCanBeEffectTarget(e) and (c:IsAbleToHand() or c:IsCanBeSpecialSummoned(e,0,tp,false,false)) and c:IsFaceupEx()
end
function c61701027.gcheck(sg,e,tp)
	return aux.dncheck(sg) and (sg:IsExists(Card.IsAbleToHand,2,nil) or not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetMZoneCount(tp)>=2 and sg:IsExists(Card.IsCanBeSpecialSummoned,2,nil,e,0,tp,false,false))
end
function c61701027.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(c61701027.tfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
	if chk==0 then return g:CheckSubGroup(c61701027.gcheck,2,2,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sg=g:SelectSubGroup(tp,c61701027.gcheck,false,2,2,e,tp)
	Duel.SetTargetCard(sg)
end
function c61701027.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	if g:GetCount()~=2 then return end
	if Duel.GetMZoneCount(tp)>=2 and g:IsExists(Card.IsCanBeSpecialSummoned,2,nil,e,0,tp,false,false) and not Duel.IsPlayerAffectedByEffect(tp,59822133) and (not g:IsExists(Card.IsAbleToHand,2,nil) or Duel.SelectOption(tp,1190,1152)==1) then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		--[[local ft=Duel.GetMZoneCount(tp)
		if g:GetCount()<=ft then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,ft,ft,nil)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			g:Sub(sg)
			local tg=g:Filter(Card.IsLocation,nil,LOCATION_REMOVED)
			if #tg>0 then Duel.SendtoGrave(g,REASON_RULE) end
		end]]--
	elseif g:IsExists(Card.IsAbleToHand,2,nil) then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
