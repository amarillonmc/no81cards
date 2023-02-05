--复仇死者 进化者
function c98920015.initial_effect(c)
		--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,98920015)
	e1:SetTarget(c98920015.sptg)
	e1:SetOperation(c98920015.spop)
	c:RegisterEffect(e1) 
   --gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_EVENT_PLAYER)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCountLimit(1,98930015)
	e2:SetCondition(c98920015.mtcon)
	e2:SetOperation(c98920015.mtop)
	c:RegisterEffect(e2)   
end
function c98920015.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x106) and (c:IsType(TYPE_RITUAL) or c:IsSummonLocation(LOCATION_EXTRA))
end
function c98920015.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c98920015.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c98920015.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and not Duel.IsPlayerAffectedByEffect(tp,EFFECT_NO_EFFECT_DAMAGE) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c98920015.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	local atk=tc:GetAttack()
	local def=tc:GetDefense()
	local val=math.min(atk,def)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,tp,val)
end
function c98920015.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
	local atk=tc:GetAttack()		
	if c:IsRelateToEffect(e) then
		if Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
		   local e1=Effect.CreateEffect(c)
		   e1:SetType(EFFECT_TYPE_SINGLE)
		   e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		   e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		   e1:SetValue(math.ceil(atk/2))
		   tc:RegisterEffect(e1)	
		   if tc:IsCode(4388680) and Duel.SelectYesNo(tp,aux.Stringid(98920015,0))then	   
			   Duel.BreakEffect()
			   Duel.Draw(tp,1,REASON_EFFECT)
		   end
		end	
		Duel.SpecialSummonComplete()
	end
end
function c98920015.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_RITUAL and e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
		and eg:IsExists(Card.IsSetCard,1,nil,0x106)
end
function c98920015.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=eg:Filter(Card.IsSetCard,nil,0x106)
	local rc=g:GetFirst()
	if not rc then return end
	local e3=Effect.CreateEffect(rc)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetValue(c98920015.aclimit)
	e3:SetCondition(c98920015.actcon)
	c:RegisterEffect(e3,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_ADD_TYPE)
		e3:SetValue(TYPE_EFFECT)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e3,true)
	end
	rc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(98920015,1))
end
function c98920015.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) or re:IsActiveType(TYPE_MONSTER)
end
function c98920015.actcon(e)
	return Duel.GetAttacker()==e:GetHandler()
end