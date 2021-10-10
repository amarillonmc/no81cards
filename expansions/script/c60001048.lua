--异格灵刀姬 暗鸦pendulum
function c60001048.initial_effect(c)
	c:SetSPSummonOnce(60001048)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c60001048.matfilter,1,1)
	--damage val
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_NO_BATTLE_DAMAGE)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e8:SetValue(1)
	c:RegisterEffect(e8)
	--half
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e8:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e8:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetOperation(c60001048.lpop)
	c:RegisterEffect(e8) 
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60001048,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,60001048)
	e1:SetTarget(c60001048.lktg)
	e1:SetOperation(c60001048.lkop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60001048,2))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c60001048.thtg)
	e2:SetOperation(c60001048.thop)
	c:RegisterEffect(e2)
end
function c60001048.matfilter(c)
	return c:IsLinkSetCard(0x1624) and not c:IsLinkAttribute(ATTRIBUTE_DARK)
end
function c60001048.lpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,60001048)
	Duel.SetLP(1-tp,math.ceil(Duel.GetLP(1-tp)/8))
end
function c60001048.lktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,nil,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c60001048.lkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsControler(1-tp) or not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,nil,nil,c)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.LinkSummon(tp,sg:GetFirst(),nil,c)
	end
end
function c60001048.thfilter(c)
	return c:IsSetCard(0x624) and c:IsAbleToHand()
end
function c60001048.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60001048.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function c60001048.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c60001048.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
