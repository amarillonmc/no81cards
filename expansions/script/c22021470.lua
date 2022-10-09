--阿尔托莉雅之星
function c22021470.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22021470+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c22021470.cost)
	e1:SetTarget(c22021470.target)
	e1:SetOperation(c22021470.activate)
	c:RegisterEffect(e1)
	--sum limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetCondition(c22021470.chcon)
	e3:SetTarget(c22021470.splimit)
	c:RegisterEffect(e3)
end
c22021470.effect_with_altria=true
function c22021470.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c22021470.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,22021470,0xff9,TYPES_EFFECT_TRAP_MONSTER,0,1800,4,RACE_WARRIOR,ATTRIBUTE_LIGHT,POS_FACEUP) end
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22021470.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,22021470,0xff9,TYPES_EFFECT_TRAP_MONSTER,0,1800,4,RACE_WARRIOR,ATTRIBUTE_LIGHT,POS_FACEUP) then
		c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TUNER)
		Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP)
	end
end
function c22021470.chcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF
end
function c22021470.splimit(e,c,tp,sumtp,sumpos)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsSetCard(0xff9)
end
