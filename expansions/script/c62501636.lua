--公正的什弥尼斯
function c62501636.initial_effect(c)
	c:EnableReviveLimit()
	--spirit return
	aux.EnableSpiritReturn(c,EVENT_SPSUMMON_SUCCESS)
	--public
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(62501636,0))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetTarget(c62501636.tgtg)
	e2:SetOperation(c62501636.tgop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(62501636,1))
	e3:SetCategory(CATEGORY_SPSUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c62501636.spcon)
	e3:SetTarget(c62501636.sptg)
	e3:SetOperation(c62501636.spop)
	c:RegisterEffect(e3)
	--public
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,62501636)
	e4:SetOperation(c62501636.regop)
	c:RegisterEffect(e4)
	--to hand
	local e5=Effect.CreateEffect(c)
	e5:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e5:SetDescription(aux.Stringid(62501636,3))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,62501636+1)
	e5:SetTarget(c62501636.thtg)
	e5:SetOperation(c62501636.thop)
	c:RegisterEffect(e5)
	if not c62501636.global_check then
		c62501636.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(c62501636.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
c62501636.has_text_type=TYPE_SPIRIT
function c62501636.checkop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:IsSetCard(0xea2) and not tc:IsReason(REASON_RETURN) then Duel.RegisterFlagEffect(tc:GetControler(),62501636,RESET_PHASE+PHASE_END,0,1) end
	end
end
function c62501636.tgfilter(c)
	return c:IsSetCard(0xea2) and c:IsAbleToGrave()
end
function c62501636.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGrave() and Duel.IsExistingMatchingCard(c62501636.tgfilter,tp,LOCATION_DECK,0,2,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_DECK)
end
function c62501636.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=Duel.SelectMatchingCard(tp,c62501636.tgfilter,tp,LOCATION_DECK,0,2,2,nil)
	if #tg==2 then
		tg:AddCard(c)
		Duel.SendtoGrave(tg,REASON_EFFECT)
	end
end
function c62501636.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,62501636)>=4
end
function c62501636.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c62501636.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() then
		c:SetMaterial(nil)
		Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
		c:CompleteProcedure()
	end
end
function c62501636.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetTargetRange(0,LOCATION_HAND)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c62501636.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	if chk==0 then return sg:IsExists(Card.IsControler,4,nil,0) and sg:IsExists(Card.IsControler,4,nil,1) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,4,PLAYER_ALL,0)
end
function c62501636.thop(e,tp,eg,ep,ev,re,r,rp)
	for p in aux.TurnPlayers() do
		local g=Duel.GetMatchingGroup(Card.IsAbleToHand,p,LOCATION_GRAVE,0,nil)
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
		local tg=g:Select(p,4,4,nil)
		Duel.HintSelection(tg)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
	for p in aux.TurnPlayers() do
		local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,p,LOCATION_HAND,0,nil)
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOGRAVE)
		local tg=g:Select(p,4,4,nil)
		Duel.SendtoGrave(tg,REASON_EFFECT)
	end
end
