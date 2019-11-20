--「CR-Unit」 Pendragon
function c33400462.initial_effect(c)
		c:SetUniqueOnField(1,0,33400462)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c33400462.target)
	e1:SetOperation(c33400462.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c33400462.eqlimit)
	c:RegisterEffect(e2)  
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_ATKCHANGE)
	e3:SetDescription(aux.Stringid(33400462,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,33400462)
	e3:SetCondition(c33400462.descon1)
	e3:SetTarget(c33400462.destg)
	e3:SetOperation(c33400462.desop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetCondition(c33400462.descon2)
	c:RegisterEffect(e4)   
	 --equip
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_EQUIP)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCountLimit(1,33400462+10000)
	e5:SetCondition(c33400462.eqcon)
	e5:SetTarget(c33400462.eqtg)
	e5:SetOperation(c33400462.operation)
	c:RegisterEffect(e5)
	 --
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(33400462,3))
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCode(EVENT_CHAINING)
	e6:SetCountLimit(1,33400462+20000)
	e6:SetOperation(c33400462.frop)
	c:RegisterEffect(e6)
	--self destroy
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCategory(CATEGORY_EQUIP)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCode(EFFECT_SELF_TOGRAVE)
	e7:SetCondition(c33400462.sdcon)
	c:RegisterEffect(e7)
end
function c33400462.eqlimit(e,c)
	return c:IsSetCard(0xc343)
end
function c33400462.eqfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0xc343)
end
function c33400462.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c33400462.eqfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c33400462.eqfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c33400462.eqfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c33400462.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() and c:CheckUniqueOnField(tp) then
		Duel.Equip(tp,c,tc)
	end
end

function c33400462.descon1(e,tp,eg,ep,ev,re,r,rp)
	  return not (e:GetHandler():GetEquipTarget():IsType(TYPE_XYZ) )
end
function c33400462.descon2(e,tp,eg,ep,ev,re,r,rp)
	  return e:GetHandler():GetEquipTarget():IsType(TYPE_XYZ) 
end
function c33400462.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return e:GetHandler():GetEquipTarget():IsAttackAbove(2000) and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c33400462.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local tc1=e:GetHandler():GetEquipTarget()
	 if  not tc1 or tc1:GetAttack()<2000	   then   return end
	if tc:IsRelateToEffect(e) then
		  local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(-2000)
			tc1:RegisterEffect(e1)
	   Duel.Destroy(tc,REASON_EFFECT)
	end
end


function c33400462.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP)  
end
function c33400462.eqfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0xc343)
end
function c33400462.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c33400462.eqfilter2(chkc) end
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c33400462.eqfilter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c33400462.eqfilter2,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end

function c33400462.frop(e,tp,eg,ep,ev,re,r,rp)  
local tc1=e:GetHandler():GetEquipTarget()
		  local e4=Effect.CreateEffect(e:GetHandler())
				e4:SetType(EFFECT_TYPE_SINGLE)
				e4:SetCode(EFFECT_IMMUNE_EFFECT)
				e4:SetValue(c33400462.efilter)
				e4:SetReset(RESET_EVENT+0x1fe0000+RESET_CHAIN)
				e4:SetOwnerPlayer(tp)
				e4:SetLabelObject(tc1)
				tc1:RegisterEffect(e4)  
		   local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(-500)
			tc1:RegisterEffect(e1)
			
end
function c33400462.efilter(e,re)   
	return re:GetOwner()~=e:GetOwner() and re:GetOwner()~=e:GetLabelObject()
end

function c33400462.sdcon(e)
	return e:GetHandler():GetEquipTarget():GetAttack()==0   
end