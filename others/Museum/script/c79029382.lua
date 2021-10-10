--炎·岁·重装干员-年
function c79029382.initial_effect(c)
	c:EnableReviveLimit()
	--fusion material
	aux.AddFusionProcFunFunRep(c,c79029382.matfilter1,c79029382.matfilter2,1,99,true)
	--spsummon condition
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(aux.fuslimit)
	c:RegisterEffect(e2)
	--spsummon success
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(c79029382.sucop)
	c:RegisterEffect(e3)
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(1)
	e2:SetCondition(c79029382.actcon)
	c:RegisterEffect(e2)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetCondition(c79029382.incon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_DEFENSE)
	e1:SetTargetRange(LOCATION_MZONE,0) 
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c79029382.atkcon)
	e1:SetTarget(c79029382.deftg)
	e1:SetValue(c79029382.defval)
	c:RegisterEffect(e1)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(c79029382.deftg)
	e1:SetCondition(c79029382.atkcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	--to grave
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_TOGRAVE)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e6:SetCountLimit(1,79029382)
	e6:SetTarget(c79029382.tgtg)
	e6:SetOperation(c79029382.tgop)
	c:RegisterEffect(e6)
end
function c79029382.matfilter1(c)
	return c:GetSequence()>4 and c:IsOnField()
end
function c79029382.matfilter2(c)
	return c:IsSetCard(0xa900)
end
function c79029382.sucop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(c:GetMaterialCount()*1500)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	c:RegisterEffect(e2)
end
function c79029382.actcon(e)
	return (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) and e:GetHandler():IsDefensePos()
end
function c79029382.incon(e)
	return e:GetHandler():IsDefensePos()
end
function c79029382.atkcon(e)
	return e:GetHandler():IsAttackPos()
end
function c79029382.deftg(e,c)
	return c~=e:GetHandler()
end
function c79029382.defval(e,c)
	return c:GetDefense()*2
end
function c79029382.tgfil(c,e)
	return c:IsAttackBelow(e:GetHandler():GetBaseAttack())
end
function c79029382.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) and Duel.IsExistingMatchingCard(c79029382.tgfil,tp,0,LOCATION_MZONE,1,nil,e) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,tp,LOCATION_MZONE)
end
function c79029382.tgop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("以子之矛攻子之盾，就会产生大爆炸！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029382,0))
	local g=Duel.GetMatchingGroup(c79029382.tgfil,tp,0,LOCATION_MZONE,nil,e)
	if g:GetCount()<=0 then return end
	local x=Duel.SendtoGrave(g,REASON_EFFECT+REASON_RULE)
	Duel.SetLP(1-tp,Duel.GetLP(1-tp)-x*500) 
end







