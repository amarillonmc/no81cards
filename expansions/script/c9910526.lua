--桃绯巫女 八岐雪花
function c9910526.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--atk down
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(c9910526.atkval1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(c9910526.atkval2)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9910526,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DECKDES+CATEGORY_GRAVE_ACTION+CATEGORY_GRAVE_SPSUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND+LOCATION_EXTRA)
	e3:SetCountLimit(1,9910526)
	e3:SetCost(c9910526.spcost)
	e3:SetTarget(c9910526.sptg)
	e3:SetOperation(c9910526.spop)
	c:RegisterEffect(e3)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_RELEASE)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCountLimit(1,9910535)
	e4:SetTarget(c9910526.rmtg)
	e4:SetOperation(c9910526.rmop)
	c:RegisterEffect(e4)
	c9910526.tsukisome_release_effect=e4
end
function c9910526.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa950) and c:GetLevel()>0
end
function c9910526.atkval1(e)
	local lg=Duel.GetMatchingGroup(c9910526.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)
	return lg:GetSum(Card.GetLevel)*50
end
function c9910526.atkval2(e)
	local lg=Duel.GetMatchingGroup(c9910526.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)
	return lg:GetSum(Card.GetLevel)*(-50)
end
function c9910526.spfilter(c,tp)
	return (c:IsSetCard(0xa950) or c:IsType(TYPE_RITUAL)) and c:IsType(TYPE_MONSTER) and Duel.GetMZoneCount(tp,c)>0
end
function c9910526.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,c9910526.spfilter,1,REASON_COST,true,e:GetHandler(),tp) end
	local g=Duel.SelectReleaseGroupEx(tp,c9910526.spfilter,1,1,REASON_COST,true,e:GetHandler(),tp)
	Duel.Release(g,REASON_COST)
end
function c9910526.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9910526.filter(c,e,tp)
	return c:IsSetCard(0xa950) and c:IsType(TYPE_PENDULUM)
		and (c:IsAbleToHand() or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c9910526.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9910526.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(9910526,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local sg=g:Select(tp,1,1,nil)
		local sc=sg:GetFirst()
		local b1=sc:IsAbleToHand()
		local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and sc:IsCanBeSpecialSummoned(e,0,tp,false,false)
		local op=0
		if b1 and b2 then op=Duel.SelectOption(tp,1190,1152)
		elseif b1 then op=0
		else op=1 end
		if op==0 then
			Duel.SendtoHand(sc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sc)
		else
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c9910526.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE)
end
function c9910526.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	local sg=Group.CreateGroup()
	if #g1>0 and (#g2==0 or Duel.SelectOption(tp,aux.Stringid(9910526,2),aux.Stringid(9910526,3))==0) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		sg=g1:RandomSelect(tp,1)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		sg=g2:Select(tp,1,1,nil)
	end
	if #sg>0 then
		Duel.HintSelection(sg)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end
