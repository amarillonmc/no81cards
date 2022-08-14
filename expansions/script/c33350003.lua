--传说之魂 诚信
local cm,m,o=GetID()
function cm.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetCategory(CATEGORY_TOGRAVE+CATEGORY_ATKCHANGE)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCondition(cm.conditon1)
	e0:SetTarget(cm.target)
	e0:SetOperation(cm.operation1(200))
	c:RegisterEffect(e0)
	local e1=e0:Clone()
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP+TIMING_DAMAGE_STEP+TIMING_END_PHASE)
	e1:SetCondition(cm.conditon2)
	e1:SetOperation(cm.operation1(400))
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_XMATERIAL)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetCondition(cm.condition)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
cm.setname="TaleSouls"
function cm.spfilter(c,e,tp)
	return c:IsCode(33350001) and c:IsFaceup()
end
function cm.conditon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil,e,tp)
end
function cm.conditon2(e,tp,eg,ep,ev,re,r,rp)
	return  Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil,e,tp)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and e:GetHandler():GetFlagEffect(m)<4 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function cm.operation1(val)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local tc=Duel.GetFirstTarget()
		if not (tc:IsRelateToEffect(e) and tc:IsFaceup()) then return end
		local op={}
		local os={}
		local n=math.abs(e:GetHandler():GetControler()-tc:GetControler())
		if tc:GetSequence()>0 and Duel.CheckLocation(tc:GetControler(),4,tc:GetSequence()-1) then op[1]=aux.Stringid(m,n);os[1]=4 end
		if tc:GetSequence()<4 and Duel.CheckLocation(tc:GetControler(),4,tc:GetSequence()+1) then op[#op+1]=aux.Stringid(m,math.abs(n-1));os[#os+1]=0 end
		if #op==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
		op = #op==1 and os[1] or os[Duel.SelectOption(tp,table.unpack(op))+1]
		for i=0,4,1 do
			if Duel.CheckLocation(tc:GetControler(),LOCATION_MZONE,math.abs(op-i)) then
				os=math.abs(op-i)
			end
		end
		Duel.MoveSequence(tc,os)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-val)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		if not tc:IsAttack(0) then return end
		Duel.BreakEffect()
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
--效果1
function cm.condition(e)
	local c=e:GetHandler()
	return c.setname=="TaleSouls"
end