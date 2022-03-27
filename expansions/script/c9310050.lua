--单调秘仪
function c9310050.initial_effect(c)
	aux.AddCodeList(c,9310000)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9310050+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9310050.target)
	e1:SetOperation(c9310050.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9311050)
	e2:SetCondition(c9310050.thcon)
	e2:SetTarget(c9310050.thtg)
	e2:SetOperation(c9310050.thop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9310050,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,9311050)
	e3:SetCondition(c9310050.thcon2)
	e3:SetTarget(c9310050.thtg)
	e3:SetOperation(c9310050.thop)
	c:RegisterEffect(e3)
end
function c9310050.filter(c,e,tp)
	return c:IsType(TYPE_TUNER)
end
function c9310050.mfilter(c,e)
	return c:GetLevel()>0 and c:IsType(TYPE_TUNER) and c:IsReleasableByEffect() 
			and c:IsCanBeRitualMaterial(nil) and aux.AtkEqualsDef(c)
end
function c9310050.rfilter2(c,e,tp,m1)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
	if bit.band(c:GetType(),0x81)~=0x81 or not c:IsType(TYPE_TUNER)
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,c,tp)
	end
	return mg:IsExists(Card.IsLevel,1,nil,c:GetLevel())
end
function c9310050.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local loc=LOCATION_HAND+LOCATION_GRAVE 
		local mg1=Duel.GetRitualMaterial(tp)
		local mg2=Duel.GetMatchingGroup(c9310050.mfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
		return Duel.IsExistingMatchingCard(c9310050.rfilter2,tp,loc+LOCATION_DECK,0,1,nil,e,tp,mg2)
			or Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,loc,0,1,nil,c9310050.filter,e,tp,mg1,nil,Card.GetLevel,"Equal")
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c9310050.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local loc=LOCATION_HAND+LOCATION_GRAVE 
	local mg1=Duel.GetRitualMaterial(tp)
	local mg2=Duel.GetMatchingGroup(c9310050.mfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	local g1=Duel.GetMatchingGroup(aux.RitualUltimateFilter,tp,loc,0,nil,c9310050.filter,e,tp,mg1,nil,Card.GetLevel,"Equal")
	local g2=Duel.GetMatchingGroup(c9310050.rfilter2,tp,loc+LOCATION_DECK,0,nil,e,tp,mg2)
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
		if g1:IsContains(tc) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Equal")
			local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Equal")
			aux.GCheckAdditional=nil
			tc:SetMaterial(mat)
			Duel.ReleaseRitualMaterial(mat)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Equal")
			local mat=mg2:FilterSelect(tp,Card.IsLevel,1,1,nil,tc:GetLevel())
			aux.GCheckAdditional=nil
			tc:SetMaterial(mat)
			Duel.ReleaseRitualMaterial(mat)
		end
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c9310050.cfilter(c,tp)
	return c:IsSummonType(SUMMON_TYPE_SYNCHRO) and c:IsSummonPlayer(tp)
			and c:IsType(TYPE_SYNCHRO) and c:IsType(TYPE_TUNER)
end
function c9310050.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9310050.cfilter,1,nil,tp)
end
function c9310050.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,9310000)
end
function c9310050.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c9310050.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end