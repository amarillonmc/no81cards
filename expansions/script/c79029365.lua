--巫恋·瑟谣浮收藏-惑之惧
function c79029365.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xa900),6,2,nil,nil,99)
	c:EnableReviveLimit()  
	--add code
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ADD_CODE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(79029199)
	c:RegisterEffect(e2)  
	--pos
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCost(c79029365.poscost)
	e2:SetTarget(c79029365.postg)
	e2:SetOperation(c79029365.posop)
	c:RegisterEffect(e2)	

end
function c79029365.poscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and Duel.GetFlagEffect(tp,79029365)==0 end
	Duel.RegisterFlagEffect(tp,79029365,0,0,0)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c79029365.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end
	local flag=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,0)
	e:SetLabel(flag)
	Duel.Hint(HINT_ZONE,tp,flag)
end
function c79029365.posop(e,tp,eg,ep,ev,re,r,rp)
	local flag=e:GetLabel()
	local seq=math.log(bit.rshift(flag,16),2)
	if not Duel.CheckLocation(1-tp,LOCATION_MZONE,seq)
		or Duel.GetFlagEffect(tp,79029365)~=0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_MUST_USE_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_NO_TURN_RESET)
	e1:SetTargetRange(0,1)
	e1:SetValue(flag | 0x600060)
	e1:SetCountLimit(1)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_ADJUST)
	e2:SetLabel(seq)
	e2:SetOperation(c79029365.adop)
	Duel.RegisterEffect(e2,tp)
end
function c79029365.ckfil(c,seq)
	return c:GetSequence()==seq
end
function c79029365.adop(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetLabel()
	if Duel.IsExistingMatchingCard(c79029365.ckfil,1-tp,LOCATION_MZONE,0,1,nil,seq) then
	Duel.ResetFlagEffect(tp,79029365)
	e:Reset() 
	Debug.Message("..")
	end
end






