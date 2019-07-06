--Protoform 巨树人
function c33700005.initial_effect(c)
	aux.EnablePendulumAttribute(c)   
   --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c33700005.ffilter,3,true)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(c33700005.indct)
	e1:SetTarget(c33700005.indtg)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetValue(1)
	e2:SetCondition(c33700005.spcon)
	e2:SetOperation(c33700005.spop)
	c:RegisterEffect(e2)
	--double
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e3:SetOperation(c33700005.damop)
	c:RegisterEffect(e3)
	--pendulum
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCondition(c33700005.pencon)
	e4:SetTarget(c33700005.pentg)
	e4:SetOperation(c33700005.penop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_RELEASE)
	e5:SetCondition(c33700005.pencon2)
	c:RegisterEffect(e5)
	--destroy
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_SELF_DESTROY)
	e7:SetCondition(c33700005.descon)
	c:RegisterEffect(e7)
end
function c33700005.ffilter(c)
	return c:IsFusionSetCard(0x6440)  and c:IsType(TYPE_MONSTER)
end
function c33700005.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
		return 1
	else return 0 end
end
function c33700005.indtg(e,c)
	return c:IsSetCard(0x6440) or c:IsSetCard(0x3440)
end
function c33700005.rmfilter(c,fc,g)
	local tp=fc:GetControler()
	if not (c:IsFusionSetCard(0x6440) and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial(fc)) then return false end
	g:AddCard(c)
	local res=(g:GetCount()>=3 and Duel.GetLocationCountFromEx(tp,tp,g,fc)>0)
		or Duel.IsExistingMatchingCard(c33700005.rmfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,g,fc,g)
	g:RemoveCard(c)
	return res
end
function c33700005.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Group.CreateGroup()
	return Duel.IsExistingMatchingCard(c33700005.rmfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,g,c,g)
end
function c33700005.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Group.CreateGroup()	
	for i=1,3 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c33700005.rmfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,g1,e:GetHandler(),g1)
		g1:Merge(g)
	end
	 local tc=g1:GetFirst()
	while tc do
		if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
		tc=g1:GetNext()
	end
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c33700005.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*2)
end
function c33700005.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c33700005.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_PZONE)>0 end
end
function c33700005.penop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_PZONE)<=0 then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c33700005.pencon2(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end
function c33700005.actfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3440)
end
function c33700005.descon(e)
	return  e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1 and not Duel.IsExistingMatchingCard(c33700005.actfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end