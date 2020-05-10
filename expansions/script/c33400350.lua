--天使-鏖杀公
function c33400350.initial_effect(c)
	  c:SetUniqueOnField(1,0,33400350)
c33400350.dfc_front_side=33400350
c33400350.dfc_back_side=33400351
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	  --
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33400350,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,33400350)
	e2:SetTarget(c33400350.seqtg)
	e2:SetOperation(c33400350.seqop)
	c:RegisterEffect(e2)
	 --destroy 
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33400350,2))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,33400350)
	e3:SetTarget(c33400350.destg)
	e3:SetOperation(c33400350.desop)
	c:RegisterEffect(e3)
	--change code
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_SZONE)
	e4:SetOperation(c33400350.changeop)
	c:RegisterEffect(e4)
end
function c33400350.seqfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x341)
end
function c33400350.seqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c33400350.seqfilter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c33400350.seqfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c33400350.seqop(e,tp,eg,ep,ev,re,r,rp)   
	if not e:GetHandler():IsRelateToEffect(e) or not Duel.IsExistingMatchingCard(c33400350.seqfilter,tp,LOCATION_MZONE,0,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(33400350,1))
	local tg=Duel.SelectMatchingCard(tp,c33400350.seqfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=tg:GetFirst()
	  local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetDescription(aux.Stringid(33400350,4))
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		tc:RegisterEffect(e2)
end

function c33400350.desfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5341)
end  
function c33400350.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chkc then return  chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c33400350.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c33400350.desfilter,tp,LOCATION_MZONE,0,1,nil) end 
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(33400350,3))
	Duel.SelectTarget(tp,c33400350.desfilter,tp,LOCATION_MZONE,0,1,1,nil) 
end
function c33400350.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc1=Duel.GetFirstTarget()   
	local tg1=tc1:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
		Duel.Destroy(tg1,REASON_EFFECT)
   local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc1:RegisterEffect(e1)
end

function c33400350.cfilter2(c,tp)
	return c:GetSummonPlayer()==tp and c:IsSetCard(0x3343) and c:IsFaceup()
end
function c33400350.changeop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
  if  eg:IsExists(c33400350.cfilter2,1,nil,tp) then 
	local tcode=c.dfc_back_side
	c:SetEntityCode(tcode,true)
	c:ReplaceEffect(tcode,0,0)
  end
end


