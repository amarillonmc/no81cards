--苍夜传说 马尔修斯 极速×坚壁
function c16323075.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x3dcf),4,3,c16323075.ovfilter,aux.Stringid(16323075,0))
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e11=e1:Clone()
	e11:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e11)
	--
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e12:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e12:SetRange(LOCATION_MZONE)
	e12:SetValue(c16323075.efilter)
	c:RegisterEffect(e12)
	--immune effect
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_SINGLE)
	e13:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e13:SetRange(LOCATION_MZONE)
	e13:SetCode(EFFECT_IMMUNE_EFFECT)
	e13:SetValue(c16323075.immunefilter)
	c:RegisterEffect(e13)
	--move
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1)
	e2:SetTarget(c16323075.seqtg)
	e2:SetOperation(c16323075.seqop)
	c:RegisterEffect(e2)
	--direct attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DIRECT_ATTACK)
	e3:SetCondition(c16323075.dircon)
	c:RegisterEffect(e3)
	--can not be effect target
	local e32=Effect.CreateEffect(c)
	e32:SetType(EFFECT_TYPE_FIELD)
	e32:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e32:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e32:SetRange(LOCATION_MZONE)
	e32:SetTargetRange(0x34,0x34)
	e32:SetCondition(c16323075.dircon2)
	e32:SetTarget(c16323075.etlimit)
	e32:SetValue(aux.tgoval)
	c:RegisterEffect(e32)
	--disable field
	local e33=Effect.CreateEffect(c)
	e33:SetType(EFFECT_TYPE_FIELD)
	e33:SetRange(LOCATION_MZONE)
	e33:SetCode(EFFECT_DISABLE_FIELD)
	e33:SetCondition(c16323075.dircon3)
	e33:SetValue(c16323075.disval)
	c:RegisterEffect(e33)
end
function c16323075.disval(e)
	local c=e:GetHandler()
	return c:GetColumnZone(LOCATION_ONFIELD,0)
end
function c16323075.etlimit(e,c)
	return c~=e:GetHandler()
end
function c16323075.dircon(e)
	local c=e:GetHandler()
	return c:GetColumnGroupCount()==0 and (c:GetSequence()==0 or c:GetSequence()==4)
end
function c16323075.dircon2(e)
	local c=e:GetHandler()
	return c:GetSequence()==2
end
function c16323075.dircon3(e)
	local c=e:GetHandler()
	return c:GetSequence()==1 or c:GetSequence()==3
end
function c16323075.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3dcf) and c:IsLevel(8) and c:IsRace(0x20)
end
function c16323075.immunefilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwner()~=e:GetOwner()
		and te:GetHandler():IsRace(0x20)
end
function c16323075.efilter(e,re,rp)
	return re:IsActiveType(TYPE_MONSTER) and e:GetHandlerPlayer()~=re:GetHandlerPlayer()
		and re:GetHandler():IsRace(0x20)
end
function c16323075.seqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end
end
function c16323075.seqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) or not c:IsControler(tp) or Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local fd=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	Duel.Hint(HINT_ZONE,tp,fd)
	local seq=math.log(fd,2)
	local pseq=c:GetSequence()
	Duel.MoveSequence(c,seq)
end