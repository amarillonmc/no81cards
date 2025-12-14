-- 蚀金玫瑰 红狼
function c11771580.initial_effect(c)
	-- 特殊召唤限制
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c11771580.splimit)
	c:RegisterEffect(e0)
	-- 手卡特召
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11771580,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,11771580)
	e1:SetCondition(c11771580.spcon1)
	e1:SetTarget(c11771580.sptg)
	e1:SetOperation(c11771580.spop)
	c:RegisterEffect(e1)
	-- 连锁特召
	local e1b=Effect.CreateEffect(c)
	e1b:SetDescription(aux.Stringid(11771580,0))
	e1b:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1b:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1b:SetCode(EVENT_CHAINING)
	e1b:SetProperty(EFFECT_FLAG_DELAY)
	e1b:SetRange(LOCATION_HAND)
	e1b:SetCountLimit(1,11771580)
	e1b:SetCondition(c11771580.spcon2)
	e1b:SetTarget(c11771580.sptg)
	e1b:SetOperation(c11771580.spop)
	c:RegisterEffect(e1b)
	-- 破坏场上卡
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11771580,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,11771581)
	e2:SetTarget(c11771580.destg)
	e2:SetOperation(c11771580.desop)
	c:RegisterEffect(e2)
	-- 加入手卡
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11771580,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BECOME_TARGET)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,11771582)
	e3:SetCondition(c11771580.thcon)
	e3:SetTarget(c11771580.thtg)
	e3:SetOperation(c11771580.thop)
	c:RegisterEffect(e3)
end
-- 1
function c11771580.splimit(e,se,sp,st)
	return se and se:IsActiveType(TYPE_MONSTER) and se:GetHandler():IsRace(RACE_WARRIOR)
end
function c11771580.cfilter(c)
	return c:IsFaceup()
		and not c:IsSummonableCard()
		and (c:IsSummonLocation(LOCATION_HAND) or c:IsSummonLocation(LOCATION_GRAVE))
end
function c11771580.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c11771580.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c11771580.spcon2(e,tp,eg,ep,ev,re,r,rp)
	if not re then return false end
	local rc=re:GetHandler()
	return rp==tp 
		and re:GetActivateLocation()==LOCATION_MZONE
		and rc:IsLocation(LOCATION_MZONE) 
		and rc:IsFaceup() 
		and not rc:IsSummonableCard()
		and re:IsActiveType(TYPE_MONSTER)
		and rc:IsSummonType(SUMMON_TYPE_SPECIAL)
		and (rc:IsSummonLocation(LOCATION_HAND) or rc:IsSummonLocation(LOCATION_GRAVE))
end
-- 2
function c11771580.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c11771580.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
-- 3
function c11771580.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,math.min(3,g:GetCount()),0,0)
end
function c11771580.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,3,3,nil)
	if g:GetCount()>0 then
		local ct=Duel.Destroy(g,REASON_EFFECT)
		if ct>0 then
			local dg=Duel.GetOperatedGroup()
			-- 检查是否破坏了自己的卡
			if not dg:IsExists(Card.IsPreviousControler,1,nil,tp) then
				-- 没有破坏自己的卡，破坏自己场上所有卡
				local mg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
				if mg:GetCount()>0 then
					Duel.BreakEffect()
					Duel.Destroy(mg,REASON_EFFECT)
				end
			end
		end
	end
end
-- 4
function c11771580.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsLocation,1,nil,LOCATION_ONFIELD)
end
function c11771580.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c11771580.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
