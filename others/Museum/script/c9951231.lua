--贝利亚融合兽·贝蒙杰多
function c9951231.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFun(c,c9951231.matfilter,aux.FilterBoolFunction(Card.IsAttackBelow,3000),2,true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToDeckOrExtraAsCost,LOCATION_GRAVE,0,aux.tdcfop(c))
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
 --extra attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_EXTRA_ATTACK)
	e4:SetValue(1)
	c:RegisterEffect(e4)
 --damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9951231,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_CONFIRM)
	e1:SetCondition(c9951231.damcon)
	e1:SetTarget(c9951231.damtg)
	e1:SetOperation(c9951231.damop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9951231,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(c9951231.spcon)
	e2:SetTarget(c9951231.sptg)
	e2:SetOperation(c9951231.spop)
	c:RegisterEffect(e2)
 --disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCondition(c9951231.discon)
	e3:SetOperation(c9951231.disop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_BE_BATTLE_TARGET)
	c:RegisterEffect(e4)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_DISABLE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(0,LOCATION_MZONE)
	e6:SetTarget(c9951231.distg)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_DISABLE_EFFECT)
	c:RegisterEffect(e7)
 --spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9951231.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9951231.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951231,0))
end
function c9951231.matfilter(c)
	return not c:IsSummonableCard() and c:IsSetCard(0x6bd2) and c:IsType(TYPE_MONSTER)
end
function c9951231.damcon(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	return bc and bc:IsControler(1-tp)
end
function c9951231.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,e:GetHandler():GetBattleTarget():GetAttack())
end
function c9951231.damop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	if tc and tc:IsFaceup() and tc:IsControler(1-tp) and tc:IsRelateToBattle() then
		local atk=tc:GetAttack()
		Duel.Damage(1-tp,atk,REASON_EFFECT)
	end
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951231,0))
end
function c9951231.spfilter(c,e,tp)
	return c:IsSetCard(0x6bd2) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c9951231.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP)
		and (c:IsReason(REASON_BATTLE) or (rp==1-tp and c:IsReason(REASON_EFFECT) and c:GetPreviousControler()==tp))
end
function c9951231.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c9951231.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c9951231.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9951231.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c9951231.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x6bd2) and c:IsControler(tp)
end
function c9951231.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetAttackTarget()
	if not c then return false end
	if c:IsControler(1-tp) then c=Duel.GetAttacker() end
	return c and c9951231.cfilter(c,tp)
end
function c9951231.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttackTarget()
	if tc:IsControler(tp) then tc=Duel.GetAttacker() end
	tc:RegisterFlagEffect(9951231,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE,0,1)
end
function c9951231.distg(e,c)
	return c:GetFlagEffect(9951231)~=0
end