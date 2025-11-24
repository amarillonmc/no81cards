--幻叙·显鳞之龙巫女 LV3
function c10200102.initial_effect(c)
	-- 主动等级上升
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10200102,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,10200102)
	e1:SetOperation(c10200102.lvop1)
	c:RegisterEffect(e1)
	-- 等级上升
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10200102,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_RELEASE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,10200103)
	e2:SetCondition(c10200102.lvcon2a)
	e2:SetOperation(c10200102.lvop2)
	c:RegisterEffect(e2)
	local e2b=e2:Clone()
	e2b:SetCode(EVENT_BE_MATERIAL)
	e2b:SetCondition(c10200102.lvcon2b)
	c:RegisterEffect(e2b)
	-- 1星效果
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_PROPERTY_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetCondition(c10200102.lv1con)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e3b=Effect.CreateEffect(c)
	e3b:SetType(EFFECT_TYPE_SINGLE)
	e3b:SetProperty(EFFECT_PROPERTY_SINGLE_RANGE)
	e3b:SetRange(LOCATION_MZONE)
	e3b:SetCode(EFFECT_UPDATE_DEFENSE)
	e3b:SetCondition(c10200102.lv1con)
	e3b:SetValue(1000)
	c:RegisterEffect(e3b)
	-- 2星效果
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10200102,2))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DAMAGE_STEP_END)
	e4:SetCondition(c10200102.lv2con)
	e4:SetTarget(c10200102.destg)
	e4:SetOperation(c10200102.desop)
	c:RegisterEffect(e4)
	-- 3星效果
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(10200102,3))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c10200102.lv3con)
	e5:SetTarget(c10200102.thtg)
	e5:SetOperation(c10200102.thop)
	c:RegisterEffect(e5)
	-- 升级
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(10200102,4))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_MZONE)
	e6:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e6:SetCondition(c10200102.spcon)
	e6:SetCost(c10200102.spcost)
	e6:SetTarget(c10200102.sptg)
	e6:SetOperation(c10200102.spop)
	c:RegisterEffect(e6)
end
c10200102.lvup={10200104}
-- 1
function c10200102.lvop1(e,tp,eg,ep,ev,re,r,rp)
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
function c10200102.lvfilter2(c)
	return c:IsPreviousLocation(LOCATION_MZONE)
end
function c10200102.lvcon2a(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10200102.lvfilter2,1,nil)
end
function c10200102.lvcon2b(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10200102.lvfilter2,1,nil) 
		and (r&(REASON_FUSION+REASON_SYNCHRO+REASON_XYZ+REASON_LINK))~=0
end
function c10200102.lvop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local ct=eg:FilterCount(c10200102.lvfilter2,nil)
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
function c10200102.lv1con(e)
	return e:GetHandler():GetLevel()>=1
end
-- 4
function c10200102.lv2con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetLevel()>=2 and e:GetHandler():IsRelateToBattle()
end
function c10200102.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c10200102.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
-- 5
function c10200102.lv3con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetLevel()>=3
end
function c10200102.thfilter(c)
	return c:IsSetCard(0x838) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c10200102.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10200102.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c10200102.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10200102.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
-- 6
function c10200102.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetLevel()==3
end
function c10200102.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c10200102.spfilter(c,e,tp)
	return c:IsCode(10200104) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10200102.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp,e:GetHandler())>0
		and Duel.IsExistingMatchingCard(c10200102.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c10200102.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10200102.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
