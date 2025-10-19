--黑耀的璀璨原钻
function c11607017.initial_effect(c)
	--fusion material
	aux.AddFusionProcFun2(c,c11607017.matfilter,aux.FilterBoolFunction(Card.IsSetCard,0x6225),true)
	c:EnableReviveLimit()
	-- 回收手卡
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11607017,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,11607017)
	e1:SetTarget(c11607017.thtg)
	e1:SetOperation(c11607017.thop)
	c:RegisterEffect(e1)
	-- 效果伤害
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11607017,1))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DAMAGE_STEP_END)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c11607017.damcon)
	e2:SetOperation(c11607017.damop)
	c:RegisterEffect(e2)
end
--fusion material
function c11607017.matfilter(c)
	return c:IsRace(RACE_ROCK) and c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK)
end
-- 1
function c11607017.thfilter(c)
	return c:IsRace(RACE_ROCK) and (c:IsLocation(LOCATION_GRAVE) or c:IsLocation(LOCATION_REMOVED))
end
function c11607017.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c11607017.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c11607017.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11607017.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
-- 2
function c11607017.damcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return a and d and a:IsSetCard(0x6225) and a:IsAttackPos() and d:IsAttackPos() or
	       a and d and d:IsSetCard(0x6225) and d:IsAttackPos() and a:IsAttackPos()
end
function c11607017.damop(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if a and d and a:IsSetCard(0x6225) and a:IsAttackPos() and d:IsAttackPos() then
		Duel.Damage(1-tp,d:GetBaseAttack(),REASON_EFFECT)
	elseif a and d and d:IsSetCard(0x6225) and d:IsAttackPos() and a:IsAttackPos() then
		Duel.Damage(1-tp,a:GetBaseAttack(),REASON_EFFECT)
	end
end
