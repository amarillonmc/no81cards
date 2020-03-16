--高等儀式術
function c460524290.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,460524290)
	e1:SetTarget(c460524290.target)
	e1:SetOperation(c460524290.activate)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c460524290.thcon)
	e2:SetCost(c460524290.thcost)
	e2:SetTarget(c460524290.thtg)
	e2:SetOperation(c460524290.thop)
	c:RegisterEffect(e2)
end
function c460524290.filter(c,e,tp,m)
	if not c:IsSetCard(0xb4) or bit.band(c:GetType(),0x81)~=0x81 then return false end
	if c.mat_filter then
		m=m:Filter(c.mat_filter,nil)
	end
	return m:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c)
end
function c460524290.matfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsReleasableByEffect()
end
function c460524290.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(c460524290.matfilter,tp,LOCATION_DECK,0,nil)
		return Duel.IsExistingMatchingCard(c460524290.filter,tp,LOCATION_DECK,0,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c460524290.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local mg=Duel.GetMatchingGroup(c460524290.matfilter,tp,LOCATION_DECK,0,nil)
	local g=Duel.SelectMatchingCard(tp,c460524290.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp,mg)
	local tg=g:GetFirst()
	if tg==nil then return end
	if tg.mat_filter then
		mg=mg:Filter(tg.mat_filter,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tg:GetLevel(),1,99,tg)
	tg:SetMaterial(mat)
	Duel.SendtoGrave(mat,REASON_EFFECT+REASON_RELEASE)
	Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
	if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
	e1:SetCondition(c460524290.spcon)
	e1:SetOperation(c460524290.spop)
	tg:RegisterEffect(e1)
end
function c460524290.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c460524290.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local mg=Duel.GetMatchingGroup(c460524290.matfilter,tp,LOCATION_DECK,0,nil)
	local tc=e:GetHandler()
	if not tc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return end
	Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
	tc:CompleteProcedure()
end

function c460524290.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c460524290.cfilter(c)
	return c:IsSetCard(0xb4) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c460524290.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c460524290.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c460524290.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c460524290.thfilter(c)
	return c:IsSetCard(0xb4) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c460524290.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c460524290.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c460524290.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c460524290.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end