--灵刀姬 飒天pendulum
function c60001023.initial_effect(c)
	c:SetSPSummonOnce(60001023)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c60001023.matfilter,1,1)
	--battle
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(60001023,0))
	e9:SetType(EFFECT_TYPE_QUICK_O)
	e9:SetCode(EVENT_FREE_CHAIN)
	e9:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e9:SetRange(LOCATION_MZONE)
	e9:SetHintTiming(0,TIMING_END_PHASE)
	e9:SetCountLimit(1,60001023)
	e9:SetTarget(c60001023.batg)
	e9:SetOperation(c60001023.baop)
	c:RegisterEffect(e9)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60001023,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,60001023)
	e1:SetTarget(c60001023.lktg)
	e1:SetOperation(c60001023.lkop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60001023,2))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c60001023.thtg1)
	e2:SetOperation(c60001023.thop1)
	c:RegisterEffect(e2)
end
function c60001023.matfilter(c)
	return c:IsLinkSetCard(0x1624) and not c:IsLinkAttribute(ATTRIBUTE_WIND)
end
function c60001023.batg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return c:IsAttackable()
		and Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil)  end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
end
function c60001023.baop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsAttackable() and c:IsControler(tp) and c:IsFaceup() and c:IsRelateToEffect(e) then
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		local tc=g:GetFirst()
		if tc:IsControler(1-tp) and tc:IsRelateToEffect(e) then
			Duel.CalculateDamage(c,tc)
		end
	end
end
function c60001023.lktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,nil,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c60001023.lkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsControler(1-tp) or not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,nil,nil,c)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.LinkSummon(tp,sg:GetFirst(),nil,c)
	end
end
function c60001023.thfilter1(c)
	return c:IsSetCard(0x624) and c:IsAbleToHand()
end
function c60001023.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60001023.thfilter1,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function c60001023.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c60001023.thfilter1,tp,LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
