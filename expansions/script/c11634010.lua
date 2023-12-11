--贫化燃料弹丸龙
function c11634010.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11634010,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,11634010)
	e1:SetTarget(c11634010.thtg)
	e1:SetOperation(c11634010.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	  --effect target
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11634010,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,116340100)
	e2:SetCost(c11634010.etcost)
	e2:SetTarget(c11634010.ettg)
	e2:SetOperation(c11634010.etop)
	c:RegisterEffect(e2)
end
function c11634010.thfilter(c)
	return c:IsSetCard(0x10f) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c11634010.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11634010.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11634010.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11634010.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c11634010.cfilter(c,tc,tp,e)
	return c:IsRace(RACE_DRAGON) and c:IsDestructable(e) and Duel.GetMZoneCount(tp,Group.FromCards(c,tc))>0
end
function c11634010.etcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c11634010.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,c,c,tp,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c11634010.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,c,c,tp,e)
	g:AddCard(c)
	Duel.Destroy(g,REASON_COST)
end
function c11634010.spfilter1(c,e,tp,sc)
	return c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,true,false)
		and Duel.GetLocationCountFromEx(tp,tp,sc,c)>0 and c:IsLinkBelow(2)
end
function c11634010.ettg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c11634010.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c11634010.etop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c11634010.spfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc):GetFirst()
	if sc then
		Duel.SpecialSummon(sc,SUMMON_TYPE_LINK,tp,tp,true,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c11634010.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c11634010.splimit(e,c)
	return not  (c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_DARK+ATTRIBUTE_LIGHT)) 
end