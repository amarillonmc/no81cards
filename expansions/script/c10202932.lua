--海神的使者
function c10202932.initial_effect(c)
	aux.AddCodeList(c,22702055)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	-- 神童启动
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10202932,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,10202932)
	e1:SetTarget(c10202932.tgp1)
	e1:SetOperation(c10202932.opp1)
	c:RegisterEffect(e1)
	-- -- 额外起跳
	-- local e2=Effect.CreateEffect(c)
	-- e2:SetType(EFFECT_TYPE_FIELD)
	-- e2:SetCode(EFFECT_SPSUMMON_PROC)
	-- e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	-- e2:SetRange(LOCATION_EXTRA)
	-- e2:SetCountLimit(1,10202935+EFFECT_COUNT_CODE_OATH)
	-- e2:SetCondition(c10202932.conp2)
	-- c:RegisterEffect(e2)
	-- local e3=Effect.CreateEffect(c)
	-- e3:SetType(EFFECT_TYPE_SINGLE)
	-- e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	-- c:RegisterEffect(e3)
	-- 遗言回血
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10202932,1))
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EVENT_REMOVE)
	e4:SetCountLimit(1,10202933)
	e4:SetTarget(c10202932.tg1)
	e4:SetOperation(c10202932.op1)
	c:RegisterEffect(e4)
	-- 魔陷无效
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(10202932,2))
	e5:SetCategory(CATEGORY_NEGATE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,10202934)
	e5:SetCondition(c10202932.con2)
	e5:SetCost(c10202932.cost2)
	e5:SetTarget(c10202932.tg2)
	e5:SetOperation(c10202932.op2)
	c:RegisterEffect(e5)
end
--p
function c10202932.filterp1(c,tp)
	return c:IsType(TYPE_CONTINUOUS) and c:IsSetCard(0x178)
		and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c10202932.tgp1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c10202932.filterp1,tp,LOCATION_DECK,0,1,nil,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c10202932.opp1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c10202932.filterp1,tp,LOCATION_DECK,0,1,1,nil,tp)
	if #g==0 or not Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true) then return end
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.BreakEffect()
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
--ps
-- function c10202932.filterp2(c)
-- 	return c:IsAttribute(ATTRIBUTE_WATER) or c:IsFacedown()
-- end
-- function c10202932.conp2(e)
-- 	local tp=e:GetHandlerPlayer()
-- 	return Duel.IsExistingMatchingCard(c10202932.filterp2,tp,LOCATION_MZONE,0,1,nil)
-- end
--1
function c10202932.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
end
function c10202932.op1(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
--2
function c10202932.filter22(c)
	return c:IsFaceup() and c:IsCode(22702055)
end
function c10202932.con2(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and Duel.IsExistingMatchingCard(c10202932.filte22,tp,LOCATION_ONFIELD,0,1,nil)
end
function c10202932.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0x178) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and c:IsAbleToGraveAsCost()
end
function c10202932.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10202932.filter2,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10202932.filter2,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c10202932.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c10202932.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end