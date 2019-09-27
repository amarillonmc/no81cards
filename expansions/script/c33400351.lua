--魔王-暴虐公
function c33400351.initial_effect(c)
	  c:SetUniqueOnField(1,0,33400351)  
	--ATK UP
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33400351,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetHintTiming(0,TIMING_DAMAGE_STEP)
	e2:SetCountLimit(1,33400351)
	e2:SetTarget(c33400351.attg)
	e2:SetOperation(c33400351.atop)
	c:RegisterEffect(e2)
	 --destroy 
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33400351,2))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,33400351+10000)
	e3:SetTarget(c33400351.destg)
	e3:SetOperation(c33400351.desop)
	c:RegisterEffect(e3)
	--change code
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_ADJUST)
	e0:SetRange(LOCATION_SZONE) 
	e0:SetCondition(c33400351.changecon)
	e0:SetOperation(
		 function(e,tp,eg,ep,ev,re,r,rp) 
		 Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+33400351,e,0,0,0,0) 
		 end)
	c:RegisterEffect(e0)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetRange(LOCATION_SZONE) 
	e4:SetCode(EVENT_CUSTOM+33400351)
	e4:SetTarget(c33400351.changetg)
	e4:SetOperation(c33400351.changeop)
	c:RegisterEffect(e4)
end
function c33400351.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x5341)
end
function c33400351.attg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c33400351.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c33400351.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c33400351.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c33400351.atop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsControler(tp) and tc:IsRelateToEffect(e) then   
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_UPDATE_ATTACK)
		e3:SetValue(1000)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		e4:SetCountLimit(1)
		e4:SetValue(c33400351.valcon)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e4)
	end
end
function c33400351.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
function c33400351.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chkc then return  chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c33400351.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c33400351.filter,tp,LOCATION_MZONE,0,1,nil) end 
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(33400351,1))
	Duel.SelectTarget(tp,c33400351.filter,tp,LOCATION_MZONE,0,1,1,nil) 
end
function c33400351.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc1=Duel.GetFirstTarget()   
	local tg1=tc1:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
		Duel.Destroy(tg1,REASON_EFFECT)
end
function c33400351.chfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3343) and c:IsType(TYPE_MONSTER)
end
function c33400351.changecon(e,tp,eg,ep,ev,re,r,rp)
   return not Duel.IsExistingMatchingCard(c33400351.chfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c33400351.changetg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	c:RegisterFlagEffect(33400351,RESET_CHAIN,0,1) 
	if chk==0 then return 33400351 and 33400351==c:GetOriginalCode() and c:GetFlagEffect(33400360)<2 end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c33400351.changeop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() or c:IsImmuneToEffect(e) then return end
	c:SetEntityCode(33400350,true)
	c:ReplaceEffect(33400350,0,0)
end