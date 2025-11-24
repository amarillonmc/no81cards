--幻叙·深渊之龙巫女 LV9
function c10200106.initial_effect(c)
	c:EnableReviveLimit()
	-- 不能通常召唤
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
	-- 等级上升
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10200106,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_RELEASE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,10200106)
	e1:SetCondition(c10200106.lvcon1a)
	e1:SetOperation(c10200106.lvop1)
	c:RegisterEffect(e1)
	local e1b=e1:Clone()
	e1b:SetCode(EVENT_BE_MATERIAL)
	e1b:SetCondition(c10200106.lvcon1b)
	c:RegisterEffect(e1b)
	-- 7星效果
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10200106,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c10200106.lv7con)
	e2:SetTarget(c10200106.lv7tg)
	e2:SetOperation(c10200106.lv7op)
	c:RegisterEffect(e2)
	-- 8星效果：对方怪兽效果无效
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCondition(c10200106.lv8con)
	e3:SetTarget(c10200106.distg)
	c:RegisterEffect(e3)
	-- 8星效果：不能改变表示形式
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetCondition(c10200106.lv8con)
	c:RegisterEffect(e4)
	-- 9星效果
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(10200106,2))
	e5:SetCategory(CATEGORY_TODECK+CATEGORY_ATKCHANGE+CATEGORY_RECOVER)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c10200106.lv9con)
	e5:SetTarget(c10200106.lv9tg)
	e5:SetOperation(c10200106.lv9op)
	c:RegisterEffect(e5)
	-- 升级
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(10200106,3))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_MZONE)
	e6:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e6:SetCondition(c10200106.spcon)
	e6:SetCost(c10200106.spcost)
	e6:SetTarget(c10200106.sptg)
	e6:SetOperation(c10200106.spop)
	c:RegisterEffect(e6)
end
c10200106.lvup={10200107}
c10200106.lvdn={10200104}
-- 1
function c10200106.lvfilter1(c)
	return c:IsPreviousLocation(LOCATION_MZONE)
end
function c10200106.lvcon1a(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10200106.lvfilter1,1,nil)
end
function c10200106.lvcon1b(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10200106.lvfilter1,1,nil) 
		and (r&(REASON_FUSION+REASON_SYNCHRO+REASON_XYZ+REASON_LINK))~=0
end
function c10200106.lvop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local ct=eg:FilterCount(c10200106.lvfilter1,nil)
		if ct>0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_LEVEL)
			e1:SetValue(ct)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			c:RegisterEffect(e1)
		end
	end
end
-- 2
function c10200106.lv7con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetLevel()>=7 and rp~=tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c10200106.lv7tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c10200106.lv7op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
-- 3
function c10200106.lv8con(e)
	return e:GetHandler():GetLevel()>=8
end
function c10200106.distg(e,c)
	return c:IsFaceup()
end
-- 4
function c10200106.lv9con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetLevel()>=9
end
function c10200106.lv9tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c10200106.lv9op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_GRAVE,0,1,1,nil)
	if #g>0 and Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 then
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(500)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			c:RegisterEffect(e1)
		end
		Duel.Recover(tp,1000,REASON_EFFECT)
	end
end
-- 5
function c10200106.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetLevel()==9
end
function c10200106.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c10200106.spfilter(c,e,tp)
	return c:IsCode(10200107) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c10200106.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp,e:GetHandler())>0
		and Duel.IsExistingMatchingCard(c10200106.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c10200106.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10200106.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
		g:GetFirst():CompleteProcedure()
	end
end
