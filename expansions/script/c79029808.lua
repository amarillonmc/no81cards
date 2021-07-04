--升格构造 阿尔法
function c79029808.initial_effect(c)
	c:SetSPSummonOnce(79029808)
	c:EnableReviveLimit()
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1) 
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79029808,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCondition(c79029808.spcon)
	e2:SetOperation(c79029808.spop)
	c:RegisterEffect(e2)
	--cannot target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c79029808.ctcon)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c79029808.ctcon)
	e4:SetValue(aux.indoval)
	c:RegisterEffect(e4)
	--damage
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(79029808,1))
	e5:SetCategory(CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_BATTLE_CONFIRM)
	e5:SetCondition(c79029808.damcon)
	e5:SetTarget(c79029808.damtg)
	e5:SetOperation(c79029808.damop)
	c:RegisterEffect(e5)
end
function c79029808.spcfilter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsSetCard(0xa991) and c:IsAbleToGraveAsCost() and c:IsType(TYPE_MONSTER)
end
function c79029808.mzfilter(c,tp)
	return c:GetSequence()<5
end
function c79029808.spzfilter(c,tp)
	return Duel.GetMZoneCount(tp,c,tp)>0
end
function c79029808.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local sg=Duel.GetMatchingGroup(c79029808.spcfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return sg:GetCount()>0 and (ft>0 or sg:IsExists(c79029808.spzfilter,1,nil,tp))
end
function c79029808.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c79029808.spcfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
	local num=5
	if #g<num then num=#g end
	local sg=g:SelectSubGroup(tp,c79029808.spzfilter,false,1,num,tp)
	Duel.SendtoGrave(sg,REASON_COST)
	local ct=#sg
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetValue(-ct)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(ct*500)
	e2:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e2) 
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
end
function c79029808.ctcon(e)
	return e:GetHandler():IsLevel(3)
end
function c79029808.damcon(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	return bc and bc:IsControler(1-tp)
end
function c79029808.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,e:GetHandler():GetBattleTarget():GetAttack())
end
function c79029808.damop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	if tc and tc:IsFaceup() and tc:IsControler(1-tp) and tc:IsRelateToBattle() then
		local atk=tc:GetAttack()
		Duel.Damage(1-tp,atk,REASON_EFFECT)
	end
end