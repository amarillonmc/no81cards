--青眼蓝龙
function c9981041.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xdd),aux.FilterBoolFunction(Card.IsFusionType,TYPE_TUNER),true)
	 --code
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CHANGE_CODE)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetValue(89631139)
	c:RegisterEffect(e2)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9981041,0))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c9981041.negcon)
	e2:SetTarget(c9981041.negtg)
	e2:SetOperation(c9981041.negop)
	c:RegisterEffect(e2)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetCondition(aux.bdocon)
	e4:SetTarget(c9981041.damtg)
	e4:SetOperation(c9981041.damop)
	c:RegisterEffect(e4)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9981041.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9981041.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981041,0))
end
function c9981041.negcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetActivateLocation()==LOCATION_HAND and Duel.IsChainNegatable(ev)
end
function c9981041.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c9981041.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
function c9981041.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tc=e:GetHandler():GetBattleTarget()
	local atk=tc:GetBaseAttack()
	if atk<0 then atk=0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(atk)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
end
function c9981041.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end