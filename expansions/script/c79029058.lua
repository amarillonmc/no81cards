--企鹅物流·据点-大地的尽头
function c79029058.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c79029058.target)
	e1:SetOperation(c79029058.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c79029058.eqlimit)
	c:RegisterEffect(e2)
	--coin
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(73206827,0))
	e3:SetCategory(CATEGORY_COIN)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetCondition(c79029058.coincon)
	e3:SetTarget(c79029058.cointg)
	e3:SetOperation(c79029058.coinop)
	c:RegisterEffect(e3) 
	--Pierce
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_PIERCE)
	e4:SetCondition(c79029058.pcon)
	c:RegisterEffect(e4) 
	--double attack
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_EXTRA_ATTACK)
	e5:SetValue(1)
	e5:SetCondition(c79029058.pcon2)
	c:RegisterEffect(e5)
	--Draw
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(42421606,0))
	e6:SetCategory(CATEGORY_DICE+CATEGORY_DRAW)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(c79029058.efcon)
	e6:SetCost(c79029058.efcost)
	e6:SetTarget(c79029058.eftg)
	e6:SetOperation(c79029058.efop)
	c:RegisterEffect(e6)
end
function c79029058.efcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():IsType(TYPE_CONTINUOUS)
end
function c79029058.eqlimit(e,c)
	return c:IsSetCard(0xf02)
end
function c79029058.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xf02)
end
function c79029058.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c79029058.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c79029058.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c79029058.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c79029058.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
c79029058.toss_coin=true
function c79029058.coincon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and e:GetHandler():IsType(TYPE_EQUIP+TYPE_SPELL)
end
function c79029058.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c79029058.coinop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local res=Duel.TossCoin(tp,1)
	if res==0 then
		c:RegisterFlagEffect(79029058,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,2)
	end
end
function c79029058.pcon(e)
	local c=e:GetHandler()
	return c:GetFlagEffect(79029058)~=0 or c:IsHasEffect(EFFECT_CANNOT_DISABLE)
end
function c79029058.pcon2(e)
	local c=e:GetHandler()
	return c:GetFlagEffect(79029058)==0 or c:IsHasEffect(EFFECT_CANNOT_DISABLE)
end
function c79029058.efcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1099,4,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x1099,4,REASON_COST)
end
function c79029058.eftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c79029058.efop(e,tp,eg,ep,ev,re,r,rp)
	local x=Duel.AnnounceNumber(tp,1,2,3,4,5,6)
	local dc=Duel.TossDice(tp,1)
	if x>=dc then 
	local a=x-dc
	Duel.Draw(tp,a,REASON_EFFECT)
	elseif x<=dc then
	local b=dc-x
	Duel.Draw(tp,b,REASON_EFFECT)
end
end


