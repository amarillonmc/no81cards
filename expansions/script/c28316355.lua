--闪耀的迷光 黛冬优子
function c28316355.initial_effect(c)
	--Straylight spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28316355,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,28316355)
	e1:SetCondition(c28316355.spcon)
	e1:SetTarget(c28316355.sptg)
	e1:SetOperation(c28316355.spop)
	c:RegisterEffect(e1)
	--Straylight search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28316355,2))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,38316355)
	e2:SetCost(c28316355.thcost)
	e2:SetTarget(c28316355.thtg)
	e2:SetOperation(c28316355.thop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_FLIP)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetTarget(c28316355.destg)
	e3:SetOperation(c28316355.desop)
	c:RegisterEffect(e3)
c28316355.shinycounter=true
end
function c28316355.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x1283)>0
end
function c28316355.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanChangePosition,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and Duel.GetMZoneCount(tp)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c28316355.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local tc=Duel.SelectMatchingCard(tp,Card.IsCanChangePosition,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
	if not tc then return end
	Duel.HintSelection(Group.FromCards(tc))
	local c=e:GetHandler()
	if Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)~=0 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
	end
end
function c28316355.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1283,3,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x1283,3,REASON_COST)
end
function c28316355.thfilter(c)
	return c:IsSetCard(0x283) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c28316355.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28316355.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c28316355.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c28316355.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c28316355.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAttackPos,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAttackPos,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c28316355.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,Card.IsAttackPos,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
