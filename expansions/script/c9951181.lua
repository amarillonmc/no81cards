--万圣节魔娘·机械伊丽莎白二号
function c9951181.initial_effect(c)
	--fusion material
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x9ba8),aux.FilterBoolFunction(Card.IsLevelBelow,8),true)
	c:EnableReviveLimit()
 --Attribute Dark
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_ADD_RACE)
	e2:SetValue(RACE_DRAGON)
	e2:SetRange(LOCATION_MZONE+LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED)
	c:RegisterEffect(e2)
 --tograve
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9951181,0))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetTarget(c9951181.tgtg)
	e3:SetOperation(c9951181.tgop)
	c:RegisterEffect(e3)
 --remove
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9951181,0))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,9951181)
	e4:SetCost(c9951181.rmcost)
	e4:SetTarget(c9951181.rmtg)
	e4:SetOperation(c9951181.rmop)
	c:RegisterEffect(e4)
--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9951181,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c9951181.thcon)
	e4:SetTarget(c9951181.thtg)
	e4:SetOperation(c9951181.thop)
	c:RegisterEffect(e4)
  --spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9951181.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9951181.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951181,0))
	Duel.Hint(HINT_SOUND,0,aux.Stringid(9951181,1))
end
function c9951181.tgfilter(c)
	return c:IsSetCard(0xba5) and c:IsAbleToGrave()
end
function c9951181.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9951181.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c9951181.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9951181.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c9951181.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0x3d) and (not sg or not sg:IsExists(Card.IsFusionAttribute,1,c,c:GetFusionAttribute()))
end
function c9951181.costfilter(c,tp)
	return c:IsSetCard(0xba5) and c:IsAbleToRemoveAsCost() and (c:IsLocation(LOCATION_HAND) or c:IsFaceup())
		and Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
end
function c9951181.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9951181.costfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9951181.costfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil,tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c9951181.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	 if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
end
function c9951181.rmop(e,tp,eg,ep,ev,re,r,rp)
   local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
	if g:GetCount()>0 then
		local sg=g:RandomSelect(tp,1)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951181,0))
Duel.Hint(HINT_SOUND,0,aux.Stringid(9951181,2))
end
function c9951181.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and c:IsReason(REASON_EFFECT) and c:IsSummonType(SUMMON_TYPE_FUSION) and c:GetPreviousControler()==tp
end
function c9951181.thfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c9951181.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9951181.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9951181.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9951181.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

