--拉尼亚凯亚之试航
function c9910655.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c9910655.target)
	e1:SetOperation(c9910655.activate)
	c:RegisterEffect(e1)
end
function c9910655.cfilter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c9910655.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910655.cfilter,tp,LOCATION_HAND,0,2,nil) end
end
function c9910655.thfilter(c)
	return c:IsSetCard(0xa952) and c:IsAbleToHand()
end
function c9910655.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c9910655.cfilter,tp,LOCATION_HAND,0,2,2,nil)
	if #g<2 then return end
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	local lv=g:GetFirst():GetLevel()
	if g:GetNext():GetLevel()~=lv then lv=0 end
	if g:IsExists(Card.IsCanBeSpecialSummoned,1,nil,e,0,tp,false,false,POS_FACEUP_DEFENSE)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(9910655,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		g:Sub(sg)
	end
	if g:IsExists(Card.IsAbleToGrave,1,nil) and Duel.IsExistingMatchingCard(c9910655.thfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(9910655,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sc=g:Select(tp,1,1,nil):GetFirst()
		if sc and Duel.SendtoGrave(sc,REASON_EFFECT)~=0 and sc:IsLocation(LOCATION_GRAVE) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local tg=Duel.SelectMatchingCard(tp,c9910655.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			if #tg>0 then
				Duel.SendtoHand(tg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tg)
			end
		end
	end
	if lv>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,9910655,0,0x11,0,3000,lv,RACE_MACHINE,ATTRIBUTE_LIGHT)
		and c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.SelectYesNo(tp,aux.Stringid(9910655,2)) then
		Duel.BreakEffect()
		c:AddMonsterAttribute(TYPE_NORMAL,nil,nil,lv,nil,nil)
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
	end
end
