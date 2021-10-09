--骨刀（无铭）
function c9950157.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c9950157.target)
	e1:SetOperation(c9950157.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EQUIP_LIMIT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(c9950157.eqlimit)
	c:RegisterEffect(e3)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetCondition(c9950157.atkcon)
	e3:SetValue(c9950157.atkval)
	c:RegisterEffect(e3)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9950157,0))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c9950157.con)
	e3:SetTarget(c9950157.tg)
	e3:SetOperation(c9950157.op)
	c:RegisterEffect(e3)
   --destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(9950157,2))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTarget(c9950157.destg)
	e5:SetOperation(c9950157.desop)
	c:RegisterEffect(e5)
end
function c9950157.eqlimit(e,c)
	return c:IsRace(RACE_ZOMBIE) or c:IsSetCard(0xba5)
end
function c9950157.filter(c)
	return c:IsFaceup() and (c:IsRace(RACE_ZOMBIE) or c:IsSetCard(0x9ba5))
end
function c9950157.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and c9950157.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9950157.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c9950157.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c9950157.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c9950157.atkcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetLP(tp)<Duel.GetLP(1-tp)
end
function c9950157.atkval(e,c)
	return math.abs(Duel.GetLP(0)-Duel.GetLP(1))
end
function c9950157.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetPreviousLocation()==LOCATION_SZONE and not c:IsReason(REASON_LOST_TARGET)
end
function c9950157.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c9950157.op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c9950157.desfilter(c)
	return c:IsFaceup()
end
function c9950157.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c9950157.desfilter(chkc) end
	if chk==0 then return e:GetHandler():GetEquipTarget():GetAttack()>=1000
		and Duel.IsExistingTarget(c9950157.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c9950157.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c9950157.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local ec=c:GetEquipTarget()
	if ec:GetAttack()<1000 then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(-1000)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	ec:RegisterEffect(e1)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not ec:IsHasEffect(EFFECT_REVERSE_UPDATE) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
