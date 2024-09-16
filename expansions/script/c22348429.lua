--哥布林商人 夏洛克
local m=22348429
local cm=_G["c"..m]
function cm.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(c22348429.target)
	e1:SetOperation(c22348429.operation)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,22352429)
	e2:SetCondition(c22348429.bbcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c22348429.bbttg)
	e2:SetOperation(c22348429.bbtop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_BECOME_TARGET)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,22352429)
	e3:SetCondition(c22348429.btcon)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c22348429.bbttg)
	e3:SetOperation(c22348429.bbtop)
	c:RegisterEffect(e3)


end
function c22348429.btgfilter(c)
	return c:IsSetCard(0xac) and c:IsType(TYPE_MONSTER) and c:IsFaceupEx()
end
function c22348429.btcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22348429.btgfilter,1,nil)
end
function c22348429.filter(c,e,tp)
	return c:IsSetCard(0xac) and c:IsLevel(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22348429.bbttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c22348429.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c22348429.bbtop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c22348429.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c22348429.bbcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return tc:IsControler(tp) and tc:IsPosition(POS_FACEUP) and tc:IsSetCard(0xac)
end
function c22348429.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c22348429.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		c:RegisterEffect(e1)
	   --draw
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(22348429,1))
		e2:SetCategory(CATEGORY_DRAW)
		e2:SetType(EFFECT_TYPE_IGNITION)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetRange(LOCATION_SZONE)
		e2:SetCost(c22348429.cost)
		e2:SetTarget(c22348429.drtg)
		e2:SetOperation(c22348429.drop)
		e2:SetCountLimit(1,22348429)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		c:RegisterEffect(e2)
	   --Recover
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(22348429,2))
		e3:SetCategory(CATEGORY_RECOVER)
		e3:SetType(EFFECT_TYPE_IGNITION)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetRange(LOCATION_SZONE)
		e3:SetCost(c22348429.cost)
		e3:SetTarget(c22348429.rctg)
		e3:SetOperation(c22348429.rcop)
		e3:SetCountLimit(1,22349429)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		c:RegisterEffect(e3)
	   --tograve
		local e4=Effect.CreateEffect(c)
		e4:SetDescription(aux.Stringid(22348429,3))
		e4:SetCategory(CATEGORY_TOGRAVE)
		e4:SetType(EFFECT_TYPE_IGNITION)
		e4:SetRange(LOCATION_SZONE)
		e4:SetCost(c22348429.cost)
		e4:SetTarget(c22348429.tgtg)
		e4:SetOperation(c22348429.tgop)
		e4:SetCountLimit(1,22350429)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		c:RegisterEffect(e4)
	   --SpecialSummon
		local e5=Effect.CreateEffect(c)
		e5:SetDescription(aux.Stringid(22348429,3))
		e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e5:SetType(EFFECT_TYPE_IGNITION)
		e5:SetRange(LOCATION_SZONE)
		e5:SetCost(c22348429.cost)
		e5:SetTarget(c22348429.sptg)
		e5:SetOperation(c22348429.spop)
		e5:SetCountLimit(1,22351429)
		e5:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		c:RegisterEffect(e5)
	end
end
function c22348429.spfilter(c,e,tp)
	return c:IsLevel(4) and c:IsAttackable(2000) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function c22348429.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c22348429.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c22348429.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c22348429.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c22348429.tgfilter(c)
	return c:IsSetCard(0xac) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c22348429.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348429.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c22348429.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c22348429.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c22348429.rctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,2000)
end
function c22348429.rcop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c22348429.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c22348429.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c22348429.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsAbleToGraveAsCost,1,1,REASON_COST)
end
