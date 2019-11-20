--「CR-Unit」 Brunnhilde
function c33400461.initial_effect(c)
 c:EnableCounterPermit(0x1)
   c:SetUniqueOnField(1,0,33400461)
	  --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c33400461.target)
	e1:SetOperation(c33400461.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c33400461.eqlimit)
	c:RegisterEffect(e2)
	 --add counter
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_CHAINING)
	e0:SetRange(LOCATION_SZONE)
	e0:SetOperation(aux.chainreg)
	c:RegisterEffect(e0)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(c33400461.acop)
	c:RegisterEffect(e3)
	 --
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(33400461,0))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCountLimit(1,33400461+10000)
	e4:SetCost(c33400461.cost)
	e4:SetOperation(c33400461.frop)
	c:RegisterEffect(e4)
	--equip
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_EQUIP)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCountLimit(1,33400461)
	e5:SetCondition(c33400461.eqcon)
	e5:SetTarget(c33400461.eqtg)
	e5:SetOperation(c33400461.operation)
	c:RegisterEffect(e5)
	  --atk/def
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_EQUIP)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetCondition(c33400461.condition)
	e6:SetValue(c33400461.atkval)
	c:RegisterEffect(e6)
	local e7=e3:Clone()
	e7:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e7)
end
function c33400461.eqlimit(e,c)
	return c:IsSetCard(0xc343)
end
function c33400461.eqfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0xc343)
end
function c33400461.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c33400461.eqfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c33400461.eqfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c33400461.eqfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c33400461.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() and c:CheckUniqueOnField(tp) then
		Duel.Equip(tp,c,tc)
	end
end

function c33400461.acop(e,tp,eg,ep,ev,re,r,rp)
	if bit.band(re:GetActivateLocation(),LOCATION_ONFIELD)~=0 and e:GetHandler():GetFlagEffect(1)>0 then
		e:GetHandler():AddCounter(0x1,1)
	end
end

function c33400461.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP)  
end
function c33400461.eqfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0xc343)
end
function c33400461.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c33400461.eqfilter2(chkc) end
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c33400461.eqfilter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c33400461.eqfilter2,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end

function c33400461.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x1,3,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x1,3,REASON_COST)
end
function c33400461.frop(e,tp,eg,ep,ev,re,r,rp)
	local tc1=e:GetHandler():GetEquipTarget()
		  local e4=Effect.CreateEffect(e:GetHandler())
				e4:SetType(EFFECT_TYPE_SINGLE)
				e4:SetCode(EFFECT_IMMUNE_EFFECT)
				e4:SetValue(c33400461.efilter)
				e4:SetReset(RESET_EVENT+0x1fe0000+RESET_CHAIN)
				e4:SetOwnerPlayer(tp)
				e4:SetLabelObject(tc1)
				tc1:RegisterEffect(e4)   
	
end
function c33400461.efilter(e,re)   
	return re:GetOwner()~=e:GetOwner() and re:GetOwner()~=e:GetLabelObject()
end

function c33400461.cnfilter(c)
	return c:IsSetCard(0x5343)
end
function c33400461.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c33400461.cnfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c33400461.atkval(e,c)
	return e:GetHandler():GetCounter(0x1)*500
end