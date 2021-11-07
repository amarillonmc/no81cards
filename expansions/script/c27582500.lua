--干涸的分身 传说的战士
local m=27582500
local cm=_G["c"..m]
	function cm.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_PREDRAW)
	e0:SetRange(LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA+LOCATION_REMOVED+LOCATION_SZONE+LOCATION_GRAVE)
	e0:SetOperation(cm.op)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
		--battle indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	   --immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE+LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA+LOCATION_REMOVED+LOCATION_SZONE+LOCATION_GRAVE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(cm.efilter)
	c:RegisterEffect(e3)
	  --dam 0
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	  -- effect damage immnue
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CHANGE_DAMAGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,0)
	e5:SetValue(cm.damval)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e6)
	  --immnue leave
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_SEND_REPLACE)
	e7:SetTarget(aux.TRUE)
	e7:SetValue(aux.TRUE)
	c:RegisterEffect(e7)
		--ATK/DEF
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_SET_BASE_ATTACK)
	e8:SetValue(2147483647)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EFFECT_SET_BASE_DEFENSE)
	c:RegisterEffect(e9)
end
	function cm.op(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	Duel.MoveToField(c,tp,tp,LOCATION_MZONE,POS_FACEUP_DEFENSE,true)
end
	function cm.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and te:GetOwner()~=e:GetOwner()
end
	function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
	function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
	function cm.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return 0
	else return val end
end