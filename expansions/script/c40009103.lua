--守护天使 扎拉琪耶尔
function c40009103.initial_effect(c)
	--summon with s/t
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e0:SetTargetRange(LOCATION_HAND,0)
	e0:SetTarget(function(e,c) return e:GetHandler()~=c and c:IsRace(RACE_FAIRY) and c:IsType(TYPE_MONSTER) end)
	e0:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e0)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009103,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1)
	e1:SetTarget(c40009103.target)
	e1:SetOperation(c40009103.activate)
	c:RegisterEffect(e1)   
	--damage 0
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CHANGE_DAMAGE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(1,0)
	e4:SetCondition(c40009103.descon)
	e4:SetValue(c40009103.damval)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e5) 
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_MATERIAL_CHECK)
	e6:SetValue(c40009103.valcheck)
	e6:SetLabelObject(e4)
	c:RegisterEffect(e6)
	--damage 0
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_CHANGE_DAMAGE)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTargetRange(0,1)
	e7:SetCondition(c40009103.descon2)
	e7:SetValue(c40009103.damval)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e8) 
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_MATERIAL_CHECK)
	e9:SetValue(c40009103.valcheck)
	e9:SetLabelObject(e7)
	c:RegisterEffect(e9)
end
function c40009103.filter(c,tp)
	return c:IsFaceup() 
		and Duel.IsExistingMatchingCard(c40009103.filter2,tp,0,LOCATION_MZONE,1,nil,c:GetAttack())
end
function c40009103.filter2(c,atk)
	return c:IsFaceup() and c:IsAttackBelow(atk)
end
function c40009103.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c40009103.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c40009103.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c40009103.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	local dg=Duel.GetMatchingGroup(c40009103.filter2,tp,0,LOCATION_MZONE,nil,g:GetFirst():GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
end
function c40009103.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local dg=Duel.GetMatchingGroup(c40009103.filter2,tp,0,LOCATION_MZONE,nil,tc:GetAttack())
		Duel.Destroy(dg,REASON_EFFECT)
		local lp=Duel.GetLP(tp)
		Duel.SetLP(tp,lp-tc:GetAttack())
	end
end
function c40009103.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabel()==1 and e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function c40009103.descon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabel()==1 and e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE) and (Duel.GetLP(e:GetHandlerPlayer())<=10000 or Duel.GetLP(1-tp)<=10000)
end
function c40009103.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return 0 end
	return val
end
function c40009103.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsSetCard,1,nil,0xf27) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end