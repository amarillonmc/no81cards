--「CR-Unit」 Ashcroft-Alice
function c33400458.initial_effect(c)
	c:SetUniqueOnField(1,0,33400458)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c33400458.target)
	e1:SetOperation(c33400458.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EQUIP_LIMIT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(c33400458.eqlimit)
	c:RegisterEffect(e3)	 
	--ZONE
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,33400458)
	e4:SetOperation(c33400458.zoneop)
	c:RegisterEffect(e4)
	--equip
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_EQUIP)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCountLimit(1,33400458+10000)
	e5:SetCondition(c33400458.eqcon)
	e5:SetTarget(c33400458.eqtg)
	e5:SetOperation(c33400458.operation)
	c:RegisterEffect(e5)
	--negate attack
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCode(EVENT_ATTACK_ANNOUNCE)
	e6:SetCountLimit(1,33400458+20000)
	e6:SetCondition(c33400458.condition)
	e6:SetOperation(c33400458.activate)
	c:RegisterEffect(e6)
end
function c33400458.eqlimit(e,c)
	return c:IsSetCard(0xc343)
end
function c33400458.eqfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0xc343)
end
function c33400458.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c33400458.eqfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c33400458.eqfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c33400458.eqfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c33400458.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() and c:CheckUniqueOnField(tp) then
		Duel.Equip(tp,c,tc)
	end
end

function c33400458.zoneop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--disable field
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_CHAIN)
	e1:SetOperation(c33400458.disop)
	c:RegisterEffect(e1)
end
function c33400458.disop(e,tp)
	local nm1=Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)
	local nm2=Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0)
	local nm3=nm1+nm2
	if nm3==0 then return end   
	local nm={}
	local i
	for i=1,9 do
	 if i<=nm3  then nm[i]=i   end
	end 
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(33400458,0))
	local sc1=Duel.AnnounceNumber(tp,table.unpack(nm))
	local dis1=Duel.SelectDisableField(tp,sc1,LOCATION_MZONE,LOCATION_MZONE,0x60)
	return dis1
end

function c33400458.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP)  
end
function c33400458.eqfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0xc343)
end
function c33400458.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c33400458.eqfilter2(chkc) end
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c33400458.eqfilter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c33400458.eqfilter2,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end

function c33400458.condition(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttacker()
	return d and d:IsControler(1-tp)
end
function c33400458.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end