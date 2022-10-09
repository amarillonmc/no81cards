--绘界星梦
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
function c9910655.cfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and not c:IsPublic()
		and Duel.IsPlayerCanSpecialSummonMonster(tp,9910655,0,0x11,0,3000,c:GetLevel(),RACE_MACHINE,ATTRIBUTE_LIGHT)
end
function c9910655.fselect(g)
	return g:GetClassCount(Card.GetLevel)==1
end
function c9910655.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c9910655.cfilter,tp,LOCATION_HAND,0,nil,tp)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:CheckSubGroup(c9910655.fselect,2,2) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9910655.thfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAttack(0) and c:IsDefense(3000)
		and c:IsAbleToHand()
end
function c9910655.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c9910655.cfilter,tp,LOCATION_HAND,0,nil,tp)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=g:SelectSubGroup(tp,c9910655.fselect,false,2,2)
	if not sg or sg:GetCount()<2 then return end
	Duel.ConfirmCards(1-tp,sg)
	Duel.ShuffleHand(tp)
	local lv=sg:GetFirst():GetLevel()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not c:IsRelateToEffect(e) or not Duel.IsPlayerCanSpecialSummonMonster(tp,9910655,0,0x11,0,3000,lv,RACE_MACHINE,ATTRIBUTE_LIGHT) then return end
	c:AddMonsterAttribute(TYPE_NORMAL,nil,nil,lv,nil,nil)
	if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)==0 then return end
	if sg:IsExists(Card.IsCanBeSpecialSummoned,1,nil,e,0,tp,false,false)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(9910655,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local ssg=sg:Select(tp,1,1,nil)
		Duel.SpecialSummon(ssg,0,tp,tp,false,false,POS_FACEUP)
		sg:Sub(ssg)
	end
	local tg=Duel.GetMatchingGroup(c9910655.thfilter,tp,LOCATION_DECK,0,nil)
	if sg:IsExists(Card.IsAbleToGrave,1,nil) and #tg>0 and Duel.SelectYesNo(tp,aux.Stringid(9910655,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sc=sg:Select(tp,1,1,nil):GetFirst()
		if sc and Duel.SendtoGrave(sc,REASON_EFFECT)~=0 and sc:IsLocation(LOCATION_GRAVE) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local tsg=tg:Select(tp,1,1,nil)
			Duel.SendtoHand(tsg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tsg)
		end
	end
end
