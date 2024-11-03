--真竜皇アグニマズドV
function c97746083.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,97746083)
	e1:SetTarget(c97746083.sptg)
	e1:SetOperation(c97746083.spop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,97746084)
	e2:SetCondition(c97746083.thcon)
	e2:SetTarget(c97746083.thtg)
	e2:SetOperation(c97746083.thop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(97746083,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,97746085+EFFECT_COUNT_CODE_DUEL)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c97746083.remtg)
	e3:SetOperation(c97746083.remop)
	c:RegisterEffect(e3)
end
function c97746083.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_ONFIELD+LOCATION_GRAVE)
end
function c97746083.remop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
	local sg=Group.CreateGroup()
	if g1:GetCount()>0 and g2:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg1=g1:Select(tp,1,1,nil)
		local sg2=g2:Select(tp,1,1,nil)
		Duel.HintSelection(sg1)
		sg:Merge(sg1)
		sg:Merge(sg2)
	end
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end
function c97746083.desfilter(c)
	return c:IsType(TYPE_MONSTER) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup())
end
function c97746083.desfilter2(c)
	return c:IsFaceup() and c:GetSequence()<5
end
function c97746083.mzfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5
end
function c97746083.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=nil
	if ft>-1 then
		local loc=0
		if Duel.IsPlayerAffectedByEffect(tp,88581108) then loc=LOCATION_MZONE end
		g=Duel.GetMatchingGroup(c97746083.desfilter,tp,LOCATION_MZONE+LOCATION_HAND,loc,c)
	else
		g=Duel.GetMatchingGroup(c97746083.desfilter2,tp,LOCATION_MZONE,0,c)
	end
	if chk==0 then return  c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and g:GetCount()>=1 and  (ft~=0 or g:IsExists(c97746083.mzfilter,1,nil,tp)) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,2,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c97746083.rmfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c97746083.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=nil
	if ft>-1 then
		local loc=0
		if Duel.IsPlayerAffectedByEffect(tp,88581108) then loc=LOCATION_MZONE end
		g=Duel.GetMatchingGroup(c97746083.desfilter,tp,LOCATION_MZONE+LOCATION_HAND,loc,c)
	else
		g=Duel.GetMatchingGroup(c97746083.desfilter2,tp,LOCATION_MZONE,0,c)
	end
	if g:GetCount()<1  then return end
	local g1=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	if ft==0 then
		g1=g:FilterSelect(tp,c97746083.mzfilter,1,1,nil,tp)
	else
		g1=g:Select(tp,1,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local rm=g1:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_FIRE)
	if Duel.Destroy(g1,REASON_EFFECT)==1 then
		if not c:IsRelateToEffect(e) then return end
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then
			return
		end
		local rg=Duel.GetMatchingGroup(c97746083.rmfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,nil)
		if rm and rg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(97746083,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local tg=rg:Select(tp,1,1,nil)
			Duel.HintSelection(tg)
			Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function c97746083.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c97746083.thfilter(c)
	return c:IsNonAttribute(ATTRIBUTE_FIRE) and c:IsRace(RACE_WYRM) and c:IsAbleToHand()
end
function c97746083.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c97746083.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c97746083.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c97746083.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
