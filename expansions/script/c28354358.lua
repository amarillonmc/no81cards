--闪耀的再续 安可
function c28354358.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,28354358+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c28354358.target)
	e1:SetOperation(c28354358.activate)
	c:RegisterEffect(e1)
	--return
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1,28354358)
	e2:SetCondition(c28354358.thcon)
	e2:SetTarget(c28354358.thtg)
	e2:SetOperation(c28354358.thop)
	c:RegisterEffect(e2)
end
function c28354358.tfilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsSummonableCard() and c:IsAbleToHand()
end
function c28354358.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c28354358.tfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c28354358.tfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c28354358.tfilter,tp,LOCATION_GRAVE,0,nil):Filter(Card.IsPreviousLocation,nil,LOCATION_ONFIELD)
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(28354358,1))
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectTarget(tp,c28354358.tfilter,tp,LOCATION_GRAVE,0,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tg,#tg,0,LOCATION_GRAVE)
end
function c28354358.spfilter(c,e,tp)
	return c:IsSetCard(0x283) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c28354358.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	local tg=g:Filter(Card.IsAbleToHand,nil)
	local ct=tg:FilterCount(Card.IsPreviousLocation,nil,LOCATION_ONFIELD)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	if ct>ft then ct=ft end
	if #tg>0 and Duel.SendtoHand(tg,nil,REASON_EFFECT)~=0 and ct>0 and Duel.IsExistingMatchingCard(c28354358.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(28354358,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c28354358.spfilter,tp,LOCATION_HAND,0,1,ct,nil,e,tp)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c28354358.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
		and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
end
function c28354358.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c28354358.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
