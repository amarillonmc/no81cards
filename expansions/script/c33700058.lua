--砂之星之奇迹
function c33700058.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c33700058.target)
	e1:SetOperation(c33700058.activate)
	c:RegisterEffect(e1)
	--revive 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(92826944,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c33700058.cost)
	e2:SetCondition(c33700058.con)
	e2:SetTarget(c33700058.tg)
	e2:SetOperation(c33700058.op)
	c:RegisterEffect(e2)
end
c33700058.card_code_list={33700056}
function c33700058.filter(c)
	return c:IsSetCard(0x442) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c33700058.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33700058.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c33700058.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c33700058.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c33700058.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c33700058.confilter(c)
	return c:IsSetCard(0x442) and c:IsFaceup()
end
function c33700058.con(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c33700058.confilter,e:GetHandlerPlayer(),LOCATION_GRAVE+LOCATION_ONFIELD,0,nil)
	return g:GetClassCount(Card.GetCode)==g:GetCount()
end
function c33700058.spfilter(c,e,tp,tid)
	return  c:IsSetCard(0x442) and c:IsType(TYPE_MONSTER) 
  and c:GetTurnID()==tid and (c:IsReason(REASON_BATTLE) or bit.band(c:GetReason(),0x41)==0x41 and c:GetReasonPlayer()==1-tp) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function c33700058.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
   local tid=Duel.GetTurnCount()
   if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c33700058.spfilter(chkc,e,tp,tid) end
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingTarget(c33700058.spfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp,tid) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c33700058.spfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp,tid)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c33700058.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if  tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end