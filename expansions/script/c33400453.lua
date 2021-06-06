--天使-绝灭天使 光剑
function c33400453.initial_effect(c)
 --Activate
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_ACTIVATE)
	e10:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e10)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33400453,0))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c33400453.con)
	e2:SetTarget(c33400453.tg)
	e2:SetOperation(c33400453.op)
	c:RegisterEffect(e2)
	   --change code
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33400453,1))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetHintTiming(0,TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
	e3:SetCountLimit(1,33400450)
	e3:SetTarget(c33400453.changetg)
	e3:SetOperation(c33400453.changeop)
	c:RegisterEffect(e3)
	 --back
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e9:SetCode(EVENT_ADJUST)
	e9:SetRange(LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_EXTRA)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e9:SetCondition(c33400453.backon)
	e9:SetOperation(c33400453.backop)
	c:RegisterEffect(e9)
end
function c33400453.uqfilter(c) 
		return c:IsSetCard(0x5343)
end

function c33400453.con(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetEquipTarget()
	local tc1=tc:GetBattleTarget()
	e:SetLabelObject(tc1)   
	return tc and tc:IsFaceup()
end
function c33400453.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetLabelObject():CreateEffectRelation(e)
end
function c33400453.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if  tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(1-tp) and not tc:IsImmuneToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(tc:GetAttack()/2)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetValue(tc:GetDefense()/2)
		tc:RegisterEffect(e2)   
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_DISABLE_EFFECT)
		e4:SetValue(RESET_TURN_SET)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e4)   
	end
end

function c33400453.changetg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	 if chkc then return true end
  if chk==0 then return true end
	 if e:GetHandler():IsLocation(LOCATION_SZONE) then  e:GetHandler():CreateEffectRelation(e) end   
	if chk==0 then return (33400450 or 33400451 or 33400452 or 33400454)  and 33400453==c:GetOriginalCode()  and Duel.IsExistingTarget(c33400453.eqfilter2,tp,LOCATION_MZONE,0,1,nil)  end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c33400453.changeop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() or c:IsImmuneToEffect(e) then return end
	local tcode
	local tg=Duel.SelectOption(tp,aux.Stringid(33400453,2),aux.Stringid(33400453,3),aux.Stringid(33400453,4),aux.Stringid(33400453,5)) 
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
	 local tg=Duel.SelectMatchingCard(tp,c33400453.eqfilter2,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=tg:GetFirst()  
		Duel.Equip(tp,c,tc)  
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(c33400453.eqlimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)		  
end
function c33400453.eqfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x5342) 
end
function c33400453.eqlimit(e,c)
	return c:GetControler()==e:GetHandlerPlayer() and c:IsSetCard(0x5342) 
end

function c33400453.backon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return 33400450 and c:GetOriginalCode()==33400453
end
function c33400453.backop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:SetEntityCode(33400450)
	Duel.ConfirmCards(tp,Group.FromCards(c))
	Duel.ConfirmCards(1-tp,Group.FromCards(c))
	c:ReplaceEffect(tcode,0,0)
end