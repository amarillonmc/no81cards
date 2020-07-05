--捕食植物 土瓶草蜗牛
function c79029518.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c) 
	--avoid damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(16178681,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c79029518.rdcon)
	e1:SetOperation(c79029518.rdop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(c79029518.drcon)
	e2:SetTarget(c79029518.drtg)
	e2:SetOperation(c79029518.drop)
	c:RegisterEffect(e2)
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetTarget(c79029518.sptg)
	e3:SetOperation(c79029518.spop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--indes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e5:SetValue(1)
	e5:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e5)
end
function c79029518.rdcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc:IsControler(tp) then tc=Duel.GetAttackTarget() end
	return ep==tp and tc and tc:GetCounter(0x1041)>0
end
function c79029518.rdop(e,tp,eg,ep,ev,re,r,rp)
		Duel.ChangeBattleDamage(tp,0)
end
function c79029518.filter(e,c,counter)
	return c:GetCounter(0x1041)>0
end
function c79029518.drfil(c)
	return c:IsSummonType(SUMMON_TYPE_FUSION)
end
function c79029518.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c79029518.drfil,1,nil) and rp==tp
end
function c79029518.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c79029518.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c79029518.sfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x10f3)
end
function c79029518.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsExistingTarget(c79029518.sfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c79029518.sfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function  c79029518.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
end

