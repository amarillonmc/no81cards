--天使-绝灭天使 基础
function c33400450.initial_effect(c)
  c:SetUniqueOnField(1,0,c33400450.uqfilter,LOCATION_ONFIELD)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	 --equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33400450,0))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,33400450+10000)
	e2:SetTarget(c33400450.eqtg)
	e2:SetOperation(c33400450.operation)
	c:RegisterEffect(e2)
	  --change code
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33400450,1))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetHintTiming(0,TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
	e3:SetCountLimit(1,33400450)
	e3:SetTarget(c33400450.changetg)
	e3:SetOperation(c33400450.changeop)
	c:RegisterEffect(e3)
   --Atk up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetValue(500)
	c:RegisterEffect(e4)
	--cannot be destroyed
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e5:SetValue(c33400450.valcon)
	e5:SetCountLimit(1)
	c:RegisterEffect(e5)   
 
end
function c33400450.uqfilter(c) 
		return c:IsSetCard(0x5343)
end
function c33400450.eqfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x5342) 
end
function c33400450.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c33400450.eqfilter2(chkc) end
	if e:GetHandler():IsLocation(LOCATION_SZONE) then  e:GetHandler():CreateEffectRelation(e) end
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) and Duel.IsExistingTarget(c33400450.eqfilter2,tp,LOCATION_MZONE,0,1,nil) end  
end
function c33400450.eqlimit(e,c)
	return c:GetControler()==e:GetHandlerPlayer() and c:IsSetCard(0x5342) 
end
function c33400450.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local tg=Duel.SelectMatchingCard(tp,c33400450.eqfilter2,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=tg:GetFirst()  
		Duel.Equip(tp,c,tc)  
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(c33400450.eqlimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
			 
end

function c33400450.changetg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	 if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c33400450.eqfilter2(chkc) end
	 if e:GetHandler():IsLocation(LOCATION_SZONE) then  e:GetHandler():CreateEffectRelation(e) end   
	if chk==0 then return (33400451 or 33400452 or 33400453 or 33400454)  and 33400450==c:GetOriginalCode() and e:GetHandler():IsRelateToEffect(e) and Duel.IsExistingTarget(c33400450.eqfilter2,tp,LOCATION_MZONE,0,1,nil)  end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c33400450.changeop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() or c:IsImmuneToEffect(e) then return end
	local tcode
	local tg=Duel.SelectOption(tp,aux.Stringid(33400450,2),aux.Stringid(33400450,3),aux.Stringid(33400450,4),aux.Stringid(33400450,5)) 
	if tg==0 then 
	 tcode=33400451
	end 
	if tg==1 then 
	 tcode=33400452
	end
	if tg==2 then  
	 tcode=33400453
	end 
	if tg==3 then 
	 tcode=33400454
	end
	c:SetEntityCode(tcode,true)
	c:ReplaceEffect(tcode,0,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local tc1=Duel.SelectMatchingCard(tp,c33400450.eqfilter2,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=tc1:GetFirst()
	Duel.Equip(tp,c,tc)
	local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(c33400450.eqlimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
end

function c33400450.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end
