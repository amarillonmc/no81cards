--天使-绝灭天使 炮冠
function c33400454.initial_effect(c)
	 --destroy 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33400454,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,33400454)
	e1:SetOperation(c33400454.desop)
	c:RegisterEffect(e1)
	   --change code
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33400454,1))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetHintTiming(0,TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
	e3:SetCountLimit(1,33400450)
	e3:SetTarget(c33400454.changetg)
	e3:SetOperation(c33400454.changeop)
	c:RegisterEffect(e3)
	 --back
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e9:SetCode(EVENT_ADJUST)
	e9:SetRange(LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_EXTRA)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e9:SetCondition(c33400454.backon)
	e9:SetOperation(c33400454.backop)
	c:RegisterEffect(e9)
end
function c33400454.uqfilter(c) 
		return c:IsSetCard(0x5343)
end

function c33400454.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetEquipTarget()
	local tg=tc:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
		Duel.Destroy(tg,REASON_EFFECT)
	 local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end

function c33400454.changetg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	 if chkc then return true end
  if chk==0 then return true end
	 if e:GetHandler():IsLocation(LOCATION_SZONE) then  e:GetHandler():CreateEffectRelation(e) end   
	if chk==0 then return (33400450 or 33400451 or 33400452 or 33400454)  and 33400454==c:GetOriginalCode()  and Duel.IsExistingTarget(c33400454.eqfilter2,tp,LOCATION_MZONE,0,1,nil)  end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c33400454.changeop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() or c:IsImmuneToEffect(e) then return end
	local tcode
	local tg=Duel.SelectOption(tp,aux.Stringid(33400454,2),aux.Stringid(33400454,3),aux.Stringid(33400454,4),aux.Stringid(33400454,5)) 
	if tg==0 then 
	 tcode=33400450
	end 
	if tg==1 then 
	 tcode=33400451
	end
	if tg==2 then  
	 tcode=33400452
	end 
	if tg==3 then 
	 tcode=33400454
	end
	c:SetEntityCode(tcode,true)
	c:ReplaceEffect(tcode,0,0)  
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	 local tg=Duel.SelectMatchingCard(tp,c33400454.eqfilter2,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=tg:GetFirst()  
		Duel.Equip(tp,c,tc)  
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(c33400454.eqlimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)		  
end
function c33400454.eqfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x5342) 
end
function c33400454.eqlimit(e,c)
	return c:GetControler()==e:GetHandlerPlayer() and c:IsSetCard(0x5342) 
end

function c33400454.backon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return 33400450 and c:GetOriginalCode()==33400454
end
function c33400454.backop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:SetEntityCode(33400450)
	Duel.ConfirmCards(tp,Group.FromCards(c))
	Duel.ConfirmCards(1-tp,Group.FromCards(c))
	c:ReplaceEffect(tcode,0,0)
end