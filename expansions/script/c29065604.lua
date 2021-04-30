--战械人形 AR15
function c29065604.initial_effect(c)
	--Equip
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,29065604)
	e1:SetTarget(c29065604.eqtg)
	e1:SetOperation(c29065604.eqop)
	c:RegisterEffect(e1)	
	--effect gain
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(29065604,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,29000026)
	e3:SetTarget(c29065604.rettg)
	e3:SetOperation(c29065604.retop)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(c29065604.eftg)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
end
function c29065604.eqfil(c) 
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x87ad) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and not c:IsCode(29065604) 
end
function c29065604.eqtfil(c)
	return c:IsSetCard(0x87ad) 
end
function c29065604.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29065604.eqfil,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c29065604.eqtfil,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,0,0)
end
function c29065604.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c29065604.eqfil,tp,LOCATION_DECK,0,nil)
	if g:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local tc=Duel.SelectMatchingCard(tp,c29065604.eqtfil,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	local ec=g:Select(tp,1,1,nil):GetFirst()
	if Duel.Equip(tp,ec,tc) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetLabelObject(tc)
			e1:SetValue(c29065604.eqlimit)
			ec:RegisterEffect(e1)
	end
end
function c29065604.eqlimit(e,c)
	return c==e:GetLabelObject() 
end
function c29065604.eftg(e,c)
	return e:GetHandler():GetEquipTarget()==c and c:IsSetCard(0x87ad)  
end
function c29065604.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c29065604.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1000)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetValue(1)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e2)
	--actlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e3:SetTargetRange(0,1)
	e3:SetValue(1)
	e3:SetCondition(c29065604.actcon)
	c:RegisterEffect(e3)
end
function c29065604.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end





