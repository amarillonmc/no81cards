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
	  --move
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33400350,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
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
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTarget(c33400350.changetg)
	e4:SetOperation(c33400350.changeop)
	e4:SetCondition(c33400350.changecon)
	c:RegisterEffect(e4)
end
function c33400350.seqfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x341)
end
function c33400350.seqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c33400350.seqfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c33400350.seqfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(33400350,1))
	Duel.SelectTarget(tp,c33400350.seqfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c33400350.seqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	Duel.MoveSequence(tc,nseq)
end
function c33400350.desfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5341)
end  
function c33400350.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chkc then return  chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c33400350.seqfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c33400350.seqfilter,tp,LOCATION_MZONE,0,1,nil) end 
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(33400350,3))   
	Duel.SelectTarget(tp,c33400350.desfilter,tp,LOCATION_MZONE,0,1,1,nil) 
end
function c33400350.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc2=Duel.GetFirstTarget()   
	local tg1=tc2:GetColumnGroup() 
	tg1:AddCard(tc2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=tg1:Select(tp,1,1,nil)  
	Duel.Destroy(g2,REASON_EFFECT)  
	if e:GetHandler():GetFlagEffect(33400350)==1 then
		Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
	else 
		e:GetHandler():RegisterFlagEffect(33400350,RESET_EVENT+RESETS_STANDARD,0,1)
	end
end
function c33400350.cfilter2(c,tp)
	return c:GetSummonPlayer()==tp and c:IsSetCard(0x3343) and c:IsFaceup()
end
function c33400350.changecon(e,tp,eg,ep,ev,re,r,rp)
   return eg:IsExists(c33400350.cfilter2,1,nil,tp)
end
function c33400350.changetg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c.dfc_back_side and c.dfc_front_side==c:GetOriginalCode() end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c33400350.changeop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() or c:IsImmuneToEffect(e) then return end
	local tcode=c.dfc_back_side
	c:SetEntityCode(tcode,true)
	c:ReplaceEffect(tcode,0,0)
end


