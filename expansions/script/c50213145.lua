--Kamipro 戴安娜
function c50213145.initial_effect(c)
	c:EnableCounterPermit(0xcbf)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCountLimit(1,50213145)
	e1:SetCondition(c50213145.spcon)
	e1:SetTarget(c50213145.sptg)
	e1:SetOperation(c50213145.spop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCountLimit(1,50213146)
	e2:SetCondition(c50213145.drcon)
	e2:SetTarget(c50213145.drtg)
	e2:SetOperation(c50213145.drop)
	c:RegisterEffect(e2)
	--add counter
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c50213145.cttg)
	e3:SetOperation(c50213145.ctop)
	c:RegisterEffect(e3)
	--attack counter 2
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLED)
	e4:SetCondition(c50213145.atccon)
	e4:SetOperation(c50213145.atcop)
	c:RegisterEffect(e4)
	--add 10 counters
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(50213145,1))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCost(c50213145.a10cost)
	e5:SetTarget(c50213145.a10tg)
	e5:SetOperation(c50213145.a10op)
	c:RegisterEffect(e5)
end
function c50213145.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsReason(REASON_DRAW)
end
function c50213145.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c50213145.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c50213145.drfilter(c,tp)
	return c:IsControler(1-tp) and not c:IsReason(REASON_DRAW)
end
function c50213145.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c50213145.drfilter,1,nil,tp)
end
function c50213145.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c50213145.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c50213145.afilter(c)
	return c:IsFaceup() and c:IsSetCard(0xcbf) and c:IsCanAddCounter(0xcbf,2)
end
function c50213145.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c50213145.afilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c50213145.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c50213145.afilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0xcbf,2)
		tc=g:GetNext()
	end
end
function c50213145.atccon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c50213145.atcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:AddCounter(0xcbf,2)
	end
end
function c50213145.a10cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0xcbf,10,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0xcbf,10,REASON_COST)
end
function c50213145.a10filter(c)
	return c:IsFaceup() and c:IsCanAddCounter(0xcbf,10)
end
function c50213145.a10tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c50213145.a10filter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
end
function c50213145.a10op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c50213145.a10filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	local tc=g:GetFirst()
	if tc then
		tc:AddCounter(0xcbf,10)
	end
end