--幻叙·显鳞之龙巫女 LV6
function c10200104.initial_effect(c)
	c:EnableReviveLimit()
	-- 不能通常召唤
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
	-- 主动等级上升
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10200104,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,10200104)
	e1:SetOperation(c10200104.lvop1)
	c:RegisterEffect(e1)
	-- 等级上升
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10200104,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_RELEASE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,10200105)
	e2:SetCondition(c10200104.lvcon2a)
	e2:SetOperation(c10200104.lvop2)
	c:RegisterEffect(e2)
	local e2b=e2:Clone()
	e2b:SetCode(EVENT_BE_MATERIAL)
	e2b:SetCondition(c10200104.lvcon2b)
	c:RegisterEffect(e2b)
	-- 4星效果
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10200104,2))
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c10200104.lv4con)
	e3:SetTarget(c10200104.atktg)
	e3:SetOperation(c10200104.atkop)
	c:RegisterEffect(e3)
	-- 5星效果：直接攻击
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_PROPERTY_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_DIRECT_ATTACK)
	e4:SetCondition(c10200104.lv5con)
	c:RegisterEffect(e4)
	-- 5星效果：不受对方魔陷影响
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_PROPERTY_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetCondition(c10200104.lv5con)
	e5:SetValue(c10200104.efilter)
	c:RegisterEffect(e5)
	-- 6星效果：对方战阶不能发动
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_PROPERTY_PLAYER_TARGET)
	e6:SetCode(EFFECT_CANNOT_ACTIVATE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(0,1)
	e6:SetCondition(c10200104.lv6con)
	e6:SetValue(c10200104.aclimit)
	c:RegisterEffect(e6)
	-- 6星效果：对方怪兽攻击力-1000
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_UPDATE_ATTACK)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTargetRange(0,LOCATION_MZONE)
	e7:SetCondition(c10200104.lv6con)
	e7:SetValue(-1000)
	c:RegisterEffect(e7)
	-- 升级
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(10200104,3))
	e8:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetRange(LOCATION_MZONE)
	e8:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e8:SetCondition(c10200104.spcon)
	e8:SetCost(c10200104.spcost)
	e8:SetTarget(c10200104.sptg)
	e8:SetOperation(c10200104.spop)
	c:RegisterEffect(e8)
end
c10200104.lvup={10200106}
c10200104.lvdn={10200102}
-- 1
function c10200104.lvop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	end
end
-- 2
function c10200104.lvfilter2(c)
	return c:IsPreviousLocation(LOCATION_MZONE)
end
function c10200104.lvcon2a(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10200104.lvfilter2,1,nil)
end
function c10200104.lvcon2b(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10200104.lvfilter2,1,nil) 
		and (r&(REASON_FUSION+REASON_SYNCHRO+REASON_XYZ+REASON_LINK))~=0
end
function c10200104.lvop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local ct=eg:FilterCount(c10200104.lvfilter2,nil)
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
-- 3
function c10200104.lv4con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetLevel()>=4
end
function c10200104.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c10200104.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-1000)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
	end
end
-- 4
function c10200104.lv5con(e)
	return e:GetHandler():GetLevel()>=5
end
function c10200104.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
-- 5
function c10200104.lv6con(e)
	return e:GetHandler():GetLevel()>=6
end
function c10200104.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and Duel.IsBattlePhase()
end
-- 6
function c10200104.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetLevel()==6
end
function c10200104.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c10200104.spfilter(c,e,tp)
	return c:IsCode(10200106) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c10200104.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp,e:GetHandler())>0
		and Duel.IsExistingMatchingCard(c10200104.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c10200104.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10200104.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
	end
end
