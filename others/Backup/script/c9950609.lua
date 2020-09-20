--免许皆传·武藏
function c9950609.initial_effect(c)
  --send to grave
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(c9950609.target)
	e2:SetOperation(c9950609.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950609,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,9950609)
	e1:SetTarget(c9950609.thtg)
	e1:SetOperation(c9950609.thop)
	c:RegisterEffect(e1)
--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950609.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950609.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950609,0))
end
function c9950609.tgfilter(c)
	return c:IsLevelBelow(2) and c:IsSetCard(0xba5)
		and (c:IsLocation(LOCATION_DECK) or c:IsFaceup()) and c:IsAbleToGrave()
end
function c9950609.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950609.tgfilter,tp,LOCATION_DECK+LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK+LOCATION_MZONE)
end
function c9950609.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9950609.tgfilter,tp,LOCATION_DECK+LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c9950609.cfilter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsSetCard(0xba5) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c9950609.filter(c)
	return c:IsLevelBelow(2) and c:IsSetCard(0xba5) and not c:IsCode(9950609) and c:IsAbleToHand()
end
function c9950609.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950609.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(c9950609.filter,tp,LOCATION_DECK,0,1,nil) end
	local dg=Duel.GetMatchingGroup(c9950609.filter,tp,LOCATION_DECK,0,nil)
	local ct=math.min(2,dg:GetClassCount(Card.GetCode))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=Duel.SelectMatchingCard(tp,c9950609.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,ct,e:GetHandler())
	local rc=Duel.Remove(rg,POS_FACEUP,REASON_COST)
	e:SetLabel(rc)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,rc,tp,LOCATION_DECK)
end
function c9950609.thop(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(c9950609.filter,tp,LOCATION_DECK,0,nil)
	local ct=e:GetLabel()
	if dg:GetClassCount(Card.GetCode)<ct then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=dg:SelectSubGroup(tp,aux.dncheck,false,ct,ct)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end

