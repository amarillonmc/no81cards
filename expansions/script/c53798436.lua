local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,id+4)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetCost(s.thcost)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
function s.ritfilter(c,e,tp)
	return c:IsCode(id+4) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function s.matfilter(c,tc)
	return c:IsLevelAbove(1) and c:IsAbleToDeck() and (not tc or (c~=tc and c:IsCanBeRitualMaterial(tc)))
end
function s.tgfilter(c,e,tp,mg,ritg)
	if c:IsType(TYPE_RITUAL) or not c:IsAbleToGrave() or not c:IsLevelAbove(1) then return false end
	local lv=c:GetLevel()
	return ritg:IsExists(s.ritcheck,1,nil,tp,mg,lv)
end
function s.ritcheck(c,tp,mg,lv)
	local mg2=mg:Filter(s.matfilter,nil,c)
	aux.GCheckAdditional=s.rcheck(c,lv)
	local res=mg2:CheckSubGroup(s.gcheck,1,lv,tp,c,lv)
	aux.GCheckAdditional=nil
	return res
end
function s.rcheck(c,lv)
	return  function(g,ec)
				if ec then
					return g:GetSum(Card.GetRitualLevel,c)-ec:GetRitualLevel(c)<=lv
				else
					return true
				end
			end
end
function s.gcheck(g,tp,c,lv)
	return aux.RitualCheckGreater(g,c,lv) and Duel.GetMZoneCount(tp,g,tp)>0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ritg=Duel.GetMatchingGroup(s.ritfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
		if #ritg==0 then return false end
		local mg=Duel.GetMatchingGroup(s.matfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,nil)
		return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil,e,tp,mg,ritg)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND+LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local ritg=Duel.GetMatchingGroup(s.ritfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
	local mg=Duel.GetMatchingGroup(s.matfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,mg,ritg)
	local tc=tg:GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_GRAVE) then
		local lv=tc:GetLevel()
		local rits=ritg:Filter(s.ritcheck,nil,tp,mg,lv)
		if #rits>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local rtc=rits:Select(tp,1,1,nil):GetFirst()
			local mg2=mg:Filter(s.matfilter,nil,rtc)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			aux.GCheckAdditional=s.rcheck(rtc,lv)
			local mat=mg2:SelectSubGroup(tp,s.gcheck,false,1,lv,tp,rtc,lv)
			aux.GCheckAdditional=nil
			if mat then
				local cg=mat:Filter(Card.IsFacedown,nil)
				if #cg>0 then
					Duel.ConfirmCards(1-tp,cg)
				end
				rtc:SetMaterial(mat)
				if Duel.SendtoDeck(mat,nil,SEQ_DECKSHUFFLE,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)>0 then
					Duel.BreakEffect()
					if Duel.SpecialSummon(rtc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)>0 then
						rtc:CompleteProcedure()
						local e1=Effect.CreateEffect(e:GetHandler())
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetCode(EFFECT_CHANGE_LEVEL)
						e1:SetValue(lv)
						e1:SetReset(RESET_EVENT+RESETS_STANDARD)
						rtc:RegisterEffect(e1)
					end
				end
			end
		end
	end
end
function s.cfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
