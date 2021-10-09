--亚马逊骑士·Neo素体形态
function c9980923.initial_effect(c)
	 c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,9980920,aux.FilterBoolFunction(Card.IsFusionSetCard,0x4),1,true,true)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c9980923.efilter)
	c:RegisterEffect(e1)
	--activate limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetCondition(c9980923.actcon)
	e3:SetValue(c9980923.actlimit)
	c:RegisterEffect(e3)
	--attack all
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_ATTACK_ALL)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--pierce
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e5)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9980923,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCondition(c9980923.damcon)
	e2:SetTarget(c9980923.damtg)
	e2:SetOperation(c9980923.damop)
	c:RegisterEffect(e2)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9980923.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9980923.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980923,0))
end
function c9980923.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c9980923.actcon(e)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c9980923.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
function c9980923.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return  c:IsRelateToBattle() and bc:IsLocation(LOCATION_GRAVE) and bc:IsType(TYPE_MONSTER)
end
function c9980923.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetHandler():GetBattleTarget()
	if chk==0 then return bc:IsAbleToRemove() end
	Duel.SetTargetCard(bc)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,bc,1,bc:GetControler(),LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,bc:GetBaseAttack())
end
function c9980923.damop(e,tp,eg,ep,ev,re,r,rp)
	local bc=Duel.GetFirstTarget()
	if bc:IsRelateToEffect(e) and Duel.Remove(bc,POS_FACEUP,REASON_EFFECT)>0 then
		Duel.Damage(1-tp,bc:GetBaseAttack(),REASON_EFFECT)
		Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980923,0))
	end
end