--冰雪之森-水晶宫
function c72413510.initial_effect(c)
		local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c72413510.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(72413510,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c72413510.spcon)
	e2:SetTarget(c72413510.sptg)
	e2:SetOperation(c72413510.spop)
	c:RegisterEffect(e2)
end
function c72413510.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x5727) and c:IsAbleToHand()
end
function c72413510.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c72413510.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(72413510,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c72413510.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c72413510.spfilter(c,e,tp,lv)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsLevelBelow(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c72413510.cfilter(c,e)
	return c:GetControler()~=e:GetHandler():GetControler() and c:GetAttackAnnouncedCount()==0
end
function c72413510.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
		local sg=Duel.GetMatchingGroup(c72413510.cfilter,tp,0,LOCATION_MZONE,nil,e)
		local ct=sg:GetCount()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c72413510.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,ct) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c72413510.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		local sg=Duel.GetMatchingGroup(c72413510.cfilter,tp,0,LOCATION_MZONE,nil,e)
		local ct=sg:GetCount()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c72413510.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,ct)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end