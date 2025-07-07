--神威骑士团堡垒（未解限）
function c24501073.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	-- 放置魔陷
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(24501073,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1,24501073)
	e1:SetCost(c24501073.cost1)
	e1:SetTarget(c24501073.tg1)
	e1:SetOperation(c24501073.op1)
	c:RegisterEffect(e1)
    -- 抗性提供
	local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
    e2:SetRange(LOCATION_FZONE)
    e2:SetTargetRange(LOCATION_ONFIELD,0)
    --e2:SetTarget(c24501073.tg2)
    e2:SetValue(c24501073.indct)
    c:RegisterEffect(e2)
	--[[local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_ONFIELD,0)
	e3:SetTarget(c24501073.tg22)
	e3:SetValue(c24501073.val3)
	c:RegisterEffect(e3)]]
    -- 抽二丢一
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(24501073,1))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCountLimit(1,24501074)
	e4:SetCondition(c24501073.con3)
	e4:SetTarget(c24501073.tg3)
	e4:SetOperation(c24501073.op3)
	c:RegisterEffect(e4)
end
-- 1
function c24501073.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c24501073.filter1(c,tp)
	return c:IsType(TYPE_CONTINUOUS)
		and c:IsSetCard(0x501)
		and not c:IsForbidden()
		and c:CheckUniqueOnField(tp)
end
function c24501073.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c24501073.filter1,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c24501073.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c24501073.filter1,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
-- 2
--[[function c24501073.tg2(e,c)
    return c:IsSetCard(0x501)
end]]
function c24501073.indct(e,re,r,rp)
    if bit.band(r,REASON_EFFECT)~=0 and rp==1-e:GetHandlerPlayer() then
        return 1
    else
        return 0
    end
end
--[[function c24501073.tg22(e,c)
    return c:IsSetCard(0x501) and c:IsFaceup()
end
function c24501073.val3(e,re)
    return re:GetHandlerPlayer()==e:GetHandlerPlayer()
end]]
-- 3
function c24501073.filter3(c,tp,rp)
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp) and c:IsPreviousSetCard(0x501)
		and rp==1-tp and c:IsReason(REASON_EFFECT)
end
function c24501073.con3(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c24501073.filter3,1,nil,tp,rp) and not eg:IsContains(e:GetHandler())
end
function c24501073.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c24501073.op3(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	if Duel.Draw(p,2,REASON_EFFECT)==2 then
		Duel.ShuffleHand(p)
		Duel.BreakEffect()
		Duel.DiscardHand(p,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end
