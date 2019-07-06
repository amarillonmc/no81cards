--最强之盾·黑
function c33700148.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCondition(c33700148.condition)
	e1:SetTarget(c33700148.target)
	e1:SetOperation(c33700148.activate)
	c:RegisterEffect(e1)
end
function c33700148.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousDefenseOnField()>=4000 and c:GetPreviousControler()==tp
end
function c33700148.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:FilterCount(c33700148.cfilter,nil,tp)==1
end
function c33700148.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,33700148,0,0x21,4000,0,11,RACE_FAIRY,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c33700148.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e)
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,33700148,0,0x21,4000,0,11,RACE_FAIRY,ATTRIBUTE_DARK) then return end
	c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP)
	Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
	c:AddMonsterAttributeComplete()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetCondition(c33700148.dircon)
	c:RegisterEffect(e1,true) 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33700148,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e2:SetCondition(c33700148.tdcon)
	e2:SetOperation(c33700148.tdop)
	c:RegisterEffect(e2,true)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SET_BASE_ATTACK)
	e3:SetReset(RESET_EVENT+0x1fe0000)
	e3:SetValue(4000)
	c:RegisterEffect(e3,true)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_ADD_RACE)
	e4:SetValue(RACE_FAIRY)
	e4:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e4,true)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_ADD_ATTRIBUTE)
	e5:SetValue(ATTRIBUTE_DARK)
	e5:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e5,true)
	local e6=e3:Clone()
	e6:SetCode(EFFECT_CHANGE_LEVEL)
	e6:SetValue(11)
	e6:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e6,true)
	Duel.SpecialSummonComplete()
end
function c33700148.dircon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsPosition,tp,0,LOCATION_MZONE,1,nil,POS_DEFENSE)
end
function c33700148.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattledGroupCount()==1
end
function c33700148.tdop(e,tp,eg,ep,ev,re,r,rp)
	   if e:GetHandler():IsAbleToHand() then
	 Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
end
end