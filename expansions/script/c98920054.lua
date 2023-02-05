--圣蔓之大贤者
function c98920054.initial_effect(c)
	 --link summon
	aux.AddLinkProcedure(c,c98920054.mfilter,2,3)
	c:EnableReviveLimit()
   --spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.linklimit)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920054,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c98920054.descon)
	e1:SetTarget(c98920054.destg)
	e1:SetOperation(c98920054.desop)
	c:RegisterEffect(e1)
--Draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,98920054)
	e1:SetTarget(c98920054.target)
	e1:SetOperation(c98920054.activate)
	c:RegisterEffect(e1)
--negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98920054,1))
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e4:SetCode(EVENT_CHAINING)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetCountLimit(1)
	e4:SetCondition(c98920054.negcon)
	e4:SetCost(c98920054.negcost)
	e4:SetTarget(aux.nbtg)
	e4:SetOperation(c98920054.negop)
	c:RegisterEffect(e4)
end
function c98920054.mfilter(c)
	return c:IsLinkType(TYPE_LINK) and c:IsLinkRace(RACE_PLANT)
end
function c98920054.cfilter(c,tp)
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp) and c:IsReason(REASON_EFFECT)
		and bit.band(c:GetPreviousTypeOnField(),TYPE_LINK)~=0 and c:IsPreviousSetCard(0x2158) and c:IsPreviousLocation(LOCATION_MZONE)
end
function c98920054.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98920054.cfilter,1,nil,tp)
end
function c98920054.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c98920054.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
function c98920054.filter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and c:IsSetCard(0x2158) and Duel.IsPlayerCanDraw(tp,c:GetLink())
end
function c98920054.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c98920054.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c98920054.filter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c98920054.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(g:GetFirst():GetLink())
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,g:GetFirst():GetLink())
end
function c98920054.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local tc=Duel.GetFirstTarget()
	local ct=tc:GetLink()
	if tc:IsRelateToEffect(e) then
		if Duel.Draw(p,ct,REASON_EFFECT)==ct then
			local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,p,LOCATION_HAND,0,nil)
			if g:GetCount()<ct then return end
			Duel.ShuffleHand(p)
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
			local sg=g:Select(p,ct,ct,nil)
			aux.PlaceCardsOnDeckBottom(p,sg)
		end
	end
end
function c98920054.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c98920054.cfilter1(c)
	return not c:IsStatus(STATUS_BATTLE_DESTROYED) and c:IsRace(RACE_PLANT)
end
function c98920054.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c98920054.cfilter1,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c98920054.cfilter1,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c98920054.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end