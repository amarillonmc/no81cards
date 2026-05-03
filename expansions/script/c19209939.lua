--饥献魔公子 玛帕斯
function c19209939.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(TIMING_SPSUMMON,TIMING_BATTLE_START)
	e1:SetDescription(aux.Stringid(19209939,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,19209939)
	e1:SetCondition(c19209939.indcon)
	e1:SetCost(c19209939.indcost)
	e1:SetTarget(c19209939.indtg)
	e1:SetOperation(c19209939.indop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(19209939,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DRAW)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,19209939+1)
	e2:SetCondition(c19209939.spcon)
	e2:SetTarget(c19209939.sptg)
	e2:SetOperation(c19209939.spop)
	c:RegisterEffect(e2)
end
function c19209939.indcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	if Duel.GetTurnPlayer()==tp then
		return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
	else
		return (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
	end
end
function c19209939.cfilter(c)
	return c:IsSetCard(0xb54) and c:IsAbleToGraveAsCost()
end
function c19209939.indcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19209939.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c19209939.cfilter,1,1,REASON_COST,nil)
end
function c19209939.indtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,2,nil)
end
function c19209939.indop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_DISEFFECT)
		e2:SetRange(LOCATION_MZONE)
		e2:SetValue(c19209939.efilter)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
function c19209939.efilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	return te:GetHandler()==e:GetHandler()
end
function c19209939.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.GetCurrentPhase()~=PHASE_DRAW
end
function c19209939.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(Card.IsControler,nil,1-tp)
	if chk==0 then return #g>0 end
	Duel.SetTargetCard(g)
end
function c19209939.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	if #g==0 then return end
	Duel.ConfirmCards(tp,g)
	local p=1-tp
	local sg=g:Filter(Card.IsCanBeSpecialSummoned,nil,e,0,p,false,false)
	local b1=#sg>0 and Duel.GetMZoneCount(p)>0
	local b2=Duel.IsPlayerCanDraw(tp,1)
	local b3=true
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(19209939,0)},
		{b2,aux.Stringid(19209939,1)},
		{b3,aux.Stringid(19209939,2)})
	if op==1 then
		Duel.BreakEffect()
		if #sg>1 then
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_SPSUMMON)
			sg=sg:Select(p,1,1,nil)
		end
		Duel.SpecialSummon(sg,0,p,p,false,false,POS_FACEUP)
	elseif op==2 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
