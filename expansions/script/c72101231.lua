--深空传送术
function c72101231.initial_effect(c)
	--yishi
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72101231,2))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,72101231)
	e1:SetTarget(c72101231.ystg)
	e1:SetOperation(c72101231.ysop)
	c:RegisterEffect(e1)

	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(72101231,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,72101232)
	e2:SetCost(c72101231.seacost)
	e2:SetTarget(c72101231.seatg)
	e2:SetOperation(c72101231.seaop)
	c:RegisterEffect(e2)
	
end

--yishi
function c72101231.filter(c,e,tp)
	return c:IsSetCard(0xcea)
end
function c72101231.mfilter(c)
	return c:GetLevel()>0 and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c72101231.rfilter2(c,e,tp,m1)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
	if bit.band(c:GetType(),0x81)~=0x81 or not c:IsSetCard(0xcea)
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,c,tp)
	end
	return mg:IsExists(Card.IsLevel,1,nil,c:GetLevel())
end
function c72101231.ystg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetRitualMaterial(tp)
		local mg2=Duel.GetMatchingGroup(c72101231.mfilter,tp,LOCATION_EXTRA,0,nil)
		return Duel.IsExistingMatchingCard(c72101231.rfilter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,mg2)
			or Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,c72101231.filter,e,tp,mg1,nil,Card.GetLevel,"Equal")
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c72101231.ysop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg1=Duel.GetRitualMaterial(tp)
	local mg2=Duel.GetMatchingGroup(c72101231.mfilter,tp,LOCATION_EXTRA,0,nil)
	local g1=Duel.GetMatchingGroup(aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,c72101231.filter,e,tp,mg1,nil,Card.GetLevel,"Equal")
	local g2=Duel.GetMatchingGroup(c72101231.rfilter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp,mg2)
	local g=g1+g2
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if tc then
		local mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		if g1:IsContains(tc) and (not g2:IsContains(tc) or not Duel.SelectYesNo(tp,aux.Stringid(72101231,0))) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Equal")
			local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Equal")
			aux.GCheckAdditional=nil
			tc:SetMaterial(mat)
			Duel.ReleaseRitualMaterial(mat)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local mat=mg2:FilterSelect(tp,Card.IsLevel,1,1,nil,tc:GetLevel())
			tc:SetMaterial(mat)
			Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		end
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end

--search
function c72101231.seacost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c72101231.seafilter(c)
	return c:IsSetCard(0xcea) and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c72101231.seatg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c72101231.seafilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c72101231.seaop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c72101231.seafilter,tp,LOCATION_DECK,0,1,1,nil)
	if #tg>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
