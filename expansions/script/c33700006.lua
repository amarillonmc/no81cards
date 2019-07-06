--Protoform 叶龙
function c33700006.initial_effect(c)
	aux.EnablePendulumAttribute(c)   
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c33700006.ffilter,2,true)
	--actlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c33700006.actcon)
	e1:SetOperation(c33700006.actop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	c:RegisterEffect(e2)
	--special summon rule
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetValue(1)
	e3:SetCondition(c33700006.spcon)
	e3:SetOperation(c33700006.spop)
	c:RegisterEffect(e3)
   --pendulum
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCondition(c33700006.pencon)
	e4:SetTarget(c33700006.pentg)
	e4:SetOperation(c33700006.penop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_RELEASE)
	e5:SetCondition(c33700006.pencon2)
	c:RegisterEffect(e5)
	--destroy
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_SELF_DESTROY)
	e7:SetCondition(c33700006.descon)
	c:RegisterEffect(e7)
	--pierce
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e8)
end
function c33700006.ffilter(c)
	return c:IsFusionSetCard(0x6440)   and c:IsType(TYPE_MONSTER)
end
function c33700006.actcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc:IsControler(1-tp) then tc=Duel.GetAttackTarget() end
	return tc and tc:IsControler(tp) and (tc:IsSetCard(0x6440) or tc:IsSetCard(0x3440))
end
function c33700006.actop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c33700006.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function c33700006.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c33700006.rmfilter(c,fc,g)
	local tp=fc:GetControler()
	if not (c:IsFusionSetCard(0x6440) and c:IsAbleToGraveAsCost() and c:IsCanBeFusionMaterial(fc)) then return false end
	g:AddCard(c)
	local res=(g:GetCount()>=2 and Duel.GetLocationCountFromEx(tp,tp,g,fc)>0)
		or Duel.IsExistingMatchingCard(c33700006.rmfilter,tp,LOCATION_MZONE,0,1,g,fc,g)
	g:RemoveCard(c)
	return res
end
function c33700006.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Group.CreateGroup()
	return Duel.IsExistingMatchingCard(c33700006.rmfilter,tp,LOCATION_MZONE,0,1,g,c,g)
end
function c33700006.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Group.CreateGroup()	
	for i=1,2 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c33700006.rmfilter,tp,LOCATION_MZONE,0,1,1,g1,e:GetHandler(),g1)
		g1:Merge(g)
	end
	 local tc=g1:GetFirst()
	while tc do
		if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
		tc=g1:GetNext()
	end
	Duel.SendtoGrave(g1,REASON_COST)
	e:GetHandler():RegisterFlagEffect(33700006,RESET_EVENT+0x1fe0000,0,1)
end
function c33700006.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c33700006.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_PZONE)>0 end
end
function c33700006.penop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_PZONE)<=0 then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c33700006.pencon2(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end
function c33700006.actfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3440)
end
function c33700006.descon(e)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1 and not Duel.IsExistingMatchingCard(c33700006.actfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end