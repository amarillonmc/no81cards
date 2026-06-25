--饥献魔道士 勒杜亚斯
function c19209941.initial_effect(c)
	--spsummon-self
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(19209941,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,19209941)
	e1:SetCondition(c19209941.spscon)
	e1:SetTarget(c19209941.spstg)
	e1:SetOperation(c19209941.spsop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(19209941,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,19209941+1)
	e2:SetCondition(c19209941.condition)
	e2:SetTarget(c19209941.thtg)
	e2:SetOperation(c19209941.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(19209941,2))
	e3:SetCategory(CATEGORY_HANDES_OPPO+CATEGORY_DRAW)
	e3:SetCondition(c19209941.drcon)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c19209941.drtg)
	e3:SetOperation(c19209941.drop)
	c:RegisterEffect(e3)
end
function c19209941.cfilter(c)
	return c:IsSetCard(0xb54) and c:IsFaceup()
end
function c19209941.spscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c19209941.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c19209941.spstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c19209941.spsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c19209941.chkfilter(c,tp)
	return c:IsSetCard(0xb54) and c:IsSummonPlayer(tp) and c:IsSummonType(SUMMON_TYPE_RITUAL) and c:IsFaceup()
end
function c19209941.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c19209941.chkfilter,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function c19209941.thfilter(c)
	return c:IsSetCard(0xb54) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c19209941.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19209941.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsPlayerCanDraw(0,1) and Duel.IsPlayerCanDraw(1,1) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c19209941.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c19209941.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if not tc then return end
	--Duel.HintSelection(Group.FromCards(tc))
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
	if not tc:IsLocation(LOCATION_HAND) then return end
	Duel.ShuffleHand(tp)
	Duel.Draw(Duel.GetTurnPlayer(),1,REASON_EFFECT)
	Duel.Draw(1-Duel.GetTurnPlayer(),1,REASON_EFFECT)
end
function c19209941.rcfilter(c)
	return c:IsSetCard(0xb54) and (c:GetType()&0x81)==0x81 and c:IsFaceup()
end
function c19209941.drcon(e,tp,eg,ep,ev,re,r,rp)
	return  Duel.IsExistingMatchingCard(c19209941.rcfilter,tp,LOCATION_REMOVED,0,2,nil) and c19209941.condition(e,tp,eg,ep,ev,re,r,rp)
end
function c19209941.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(0,ct) and Duel.IsPlayerCanDraw(1,ct) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,ct)
end
function c19209941.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()==0 or Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)==0 then return end
	Duel.BreakEffect()
	Duel.Draw(Duel.GetTurnPlayer(),#g,REASON_EFFECT)
	Duel.Draw(1-Duel.GetTurnPlayer(),#g,REASON_EFFECT)
end
