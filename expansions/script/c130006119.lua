--献上不义之祈祷
local s,id,o=GetID()
s.UnJustice=1
function s.initial_effect(c)
	aux.AddCodeList(c,130006118)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--change cost
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(id)
	e3:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e3)
end
function s.costfilter1(c)
	return c:IsAbleToDeck() and c:IsLevelAbove(1) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function s.thfilter(c)
	return c.UnJustice==1 and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function s.thfilter2(c)
	return c:IsLevelAbove(1) and c.UnJustice==1 and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function s.spfilter(c,e,tp)
	return c:IsType(TYPE_RITUAL) and c:IsCode(130006118)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function s.fselect(g,e,tp)
	local sg=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	local lv=g:GetSum(Card.GetLevel)
	return sg:CheckSubGroup(s.fselect2,1,#g-1,lv)
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,g,e,tp) 
end
function s.fselect2(g,lv)
	return g:GetSum(Card.GetLevel)==lv
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg=Duel.GetMatchingGroup(s.costfilter1,tp,LOCATION_HAND,0,nil)
	if chk==0 then return sg:CheckSubGroup(s.fselect,2,#sg,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=sg:SelectSubGroup(tp,s.fselect,false,2,#sg,e,tp)
	Duel.SetTargetCard(g)
	local lv=g:GetSum(Card.GetLevel)
	e:SetLabel(lv)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	local rg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
	local lv=e:GetLabel()
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	local mat=Group.CreateGroup()
	mat:Merge(tg)
	if tg:GetCount()>0 then
		local ct=Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=sg:SelectSubGroup(tp,s.fselect2,false,1,ct-1,lv)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
		if #rg>0 then 
			local rc=rg:Select(tp,1,1,nil):GetFirst()
			if rc then
				rc:SetMaterial(mat)
				Duel.SpecialSummonStep(rc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_LEVEL)
				e1:SetValue(lv)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				rc:RegisterEffect(e1,true)
				Duel.SpecialSummonComplete()
			end
		end
	end
end