--方舟骑士·天马曜环 瑕光
function c82567797.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,c82567797.tunerfilter,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--battle target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetValue(c82567797.atlimit)
	c:RegisterEffect(e2)
	--ChangePosition
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(82567797,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_POSITION+CATEGORY_RECOVER)
	e3:SetCountLimit(1)
	e3:SetCost(c82567797.poscost)
	e3:SetTarget(c82567797.postg)
	e3:SetOperation(c82567797.activate)
	c:RegisterEffect(e3)
	--add setname
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_ADD_SETCODE)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetValue(0x825)
	c:RegisterEffect(e9)
end
function c82567797.tunerfilter(c)
	return c:IsSetCard(0x825) and c:IsType(TYPE_TUNER) 
end 
function c82567797.atlimit(e,c)
	return c:IsFaceup() and not (c:GetBaseAttack() <= c:GetBaseDefense()) and c:IsSetCard(0x825)
end
function c82567797.filter(c)
	return c:IsFaceup() 
end
function c82567797.posfilter(c)
	return c:IsFaceup() and c:IsAttackPos() and c:IsCanChangePosition()
end
function c82567797.poscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x5825,2,REASON_COST) and Duel.GetCustomActivityCount(82567797,tp,ACTIVITY_SPSUMMON)==0 end
	Duel.RemoveCounter(tp,1,0,0x5825,2,REASON_COST)
end
function c82567797.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c82567797.posfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c82567797.posfilter,tp,0,LOCATION_MZONE,nil)
	local ag=Duel.GetMatchingGroup(c82567797.filter,tp,LOCATION_MZONE,0,nil)
	local gn=g:GetCount()
	local agn=ag:GetCount()
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,gn,0,0)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,ag,agn,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function c82567797.activate(e,tp,eg,ep,ev,re,r,rp,g,tg,sg)
	local c=e:GetHandler()
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c82567797.posfilter,tp,0,LOCATION_MZONE,nil)
	local gn=g:GetCount()
	local value=gn*500
	local ag=Duel.GetMatchingGroup(c82567797.filter,tp,LOCATION_MZONE,0,nil)
	Duel.ChangePosition(g,POS_FACEUP_DEFENSE)
	local tc=ag:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(value)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=ag:GetNext()
	end
	Duel.Recover(tp,value,REASON_EFFECT)
end


