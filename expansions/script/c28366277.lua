--堕天的古之妖 漆黑幻想颂
function c28366277.initial_effect(c)
	--same effect send this card to grave and summon another card check
	local e0=aux.AddThisCardInGraveAlreadyCheck(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(0,TIMING_DRAW_PHASE+TIMING_END_PHASE)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c28366277.cost)
	e1:SetTarget(c28366277.target)
	e1:SetOperation(c28366277.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28366277,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_MSET)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	--e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetLabelObject(e0)
	--e2:SetCondition(c28366277.spcon)
	e2:SetTarget(c28366277.thtg)
	e2:SetOperation(c28366277.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SSET)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_CHANGE_POS)
	e4:SetCondition(c28366277.thcon)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
end
function c28366277.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLP(tp)<=3000 or Duel.CheckLPCost(tp,2000) end
	if Duel.GetLP(tp)>3000 then Duel.PayLPCost(tp,2000) end
end
function c28366277.thfilter(c)
	return c:IsSetCard(0x285) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c28366277.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28366277.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c28366277.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetLP(tp)>3000 and 1 or 2
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c28366277.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,ct,nil)
	if #tg==0 then return end
	local hg=tg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	if #hg~=0 then Duel.HintSelection(hg) end
	if Duel.SendtoHand(tg,nil,REASON_EFFECT)==0 then return end
	tg=tg:Filter(Card.IsLocation,nil,LOCATION_HAND)
	if #tg==0 then return end
	Duel.ConfirmCards(1-tp,tg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND+LOCATION_MZONE,0,#tg,#tg,nil)
	Duel.HintSelection(dg)
	Duel.Destroy(dg,REASON_EFFECT)
end
function c28366277.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsFacedown,1,nil)--Duel.GetLP(tp)<=3000
end
function c28366277.desfilter(c,tp)
	return c:IsRace(RACE_FAIRY) and c:IsLevelAbove(1) and Duel.IsPlayerCanSpecialSummonMonster(tp,28366277,0x285,TYPES_NORMAL_TRAP_MONSTER,c:GetAttack(),c:GetDefense(),c:GetLevel(),RACE_FIEND,c:GetAttribute()) and c:IsFaceup()
end
function c28366277.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c28366277.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local tc=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	if not tc then return end
	Duel.HintSelection(Group.FromCards(tc))
	local c=e:GetHandler()
	if Duel.Destroy(tc,REASON_EFFECT)==0 or not c:IsRelateToChain() then return end
	Duel.SendtoHand(c,nil,REASON_EFFECT)
end
