--阿斗
function c11561042.initial_effect(c) 
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11561042,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c11561042.eqtg)
	e1:SetOperation(c11561042.eqop)
	c:RegisterEffect(e1)
	--unequip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11561042,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c11561042.sptg)
	e2:SetOperation(c11561042.spop)
	c:RegisterEffect(e2)
	--attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e2:SetValue(6)
	c:RegisterEffect(e2)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(-700)
	c:RegisterEffect(e2) 
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c11561042.desreptg)
	e2:SetValue(c11561042.desrepval)
	e2:SetOperation(c11561042.desrepop)
	c:RegisterEffect(e2)
	--eq 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_EQUIP) 
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e3:SetCode(EVENT_TO_GRAVE) 
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET) 
	e3:SetCondition(c11561042.xeqcon) 
	e3:SetTarget(c11561042.xeqtg) 
	e3:SetOperation(c11561042.xeqop) 
	c:RegisterEffect(e3) 
end 
function c11561042.filter(c)
	local ct1,ct2=c:GetUnionCount()
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR) and ct2==0
end
function c11561042.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c11561042.filter(chkc) end
	if chk==0 then return e:GetHandler():GetFlagEffect(11561042)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c11561042.filter,tp,LOCATION_MZONE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c11561042.filter,tp,LOCATION_MZONE,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
	c:RegisterFlagEffect(11561042,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c11561042.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	if not tc:IsRelateToEffect(e) or not c11561042.filter(tc) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	if Duel.Equip(tp,c,tc,false) then 
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT) 
		e1:SetLabelObject(tc)
		e1:SetValue(function(e,c)
		return e:GetLabelObject()==c end)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		c:RegisterEffect(e1)
	end 
end
function c11561042.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(11561042)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:GetEquipTarget() and c:IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	c:RegisterFlagEffect(11561042,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c11561042.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
end
function c11561042.repfilter(c,e,tp)
	return c==e:GetHandler():GetEquipTarget() 
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c11561042.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c11561042.repfilter,1,nil,e,tp) end
	return c:GetFlagEffect(21561042)<7
end
function c11561042.desrepval(e,c)
	return c11561042.repfilter(c,e,e:GetHandlerPlayer())
end
function c11561042.desrepop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(21561042,RESET_EVENT+RESETS_STANDARD,0,1)
	Duel.Hint(HINT_CARD,0,11561042)
end
function c11561042.xeqcon(e,tp,eg,ep,ev,re,r,rp) 
	return e:GetHandler():IsPreviousLocation(LOCATION_SZONE) 
end 
function c11561042.xeqtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(function(c) return c:IsFaceup() and c:IsCode(11561043) end,tp,LOCATION_MZONE,0,1,nil) end 
	local g=Duel.SelectTarget(tp,function(c) return c:IsFaceup() and c:IsCode(11561043) end,tp,LOCATION_MZONE,0,1,1,nil)
end 
function c11561042.xeqop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) then 
		local e1=Effect.CreateEffect(c) 
		e1:SetDescription(aux.Stringid(11561042,0))
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetCountLimit(1)
		e1:SetLabel(Duel.GetTurnCount()) 
		e1:SetLabelObject(c)
		e1:SetCondition(c11561042.xxeqcon) 
		e1:SetOperation(c11561042.xxeqop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		tc:RegisterEffect(e1) 
	end 
end 
function c11561042.xxeqcon(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=e:GetLabelObject() 
	return tc:IsLocation(LOCATION_GRAVE) and Duel.GetTurnCount()~=e:GetLabel()
end 
function c11561042.xxeqop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=e:GetLabelObject() 
	if tc:IsLocation(LOCATION_GRAVE) then 
		Duel.Hint(HINT_CARD,0,11561042) 
		if not Duel.Equip(tp,tc,c,false) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT) 
		e1:SetLabelObject(c)
		e1:SetValue(function(e,c)
		return e:GetLabelObject()==c end)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		tc:RegisterEffect(e1)
	end 
end 







