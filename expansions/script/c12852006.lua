--Lycoris-回避技能
function c12852006.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c12852006.target)
	e1:SetOperation(c12852006.operation)
	c:RegisterEffect(e1)   
	--Equip limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EQUIP_LIMIT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(c12852006.eqlimit)
	c:RegisterEffect(e3)  
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12852006,2))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_MOVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c12852006.descon)
	e2:SetTarget(c12852006.destg)
	e2:SetOperation(c12852006.desop)
	c:RegisterEffect(e2)
	--destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTarget(c12852006.reptg)
	e4:SetValue(c12852006.repval)
	e4:SetOperation(c12852006.repop)
	c:RegisterEffect(e4) 
	--Activate
	local e21=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12852006,1))
	e21:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DISABLE+CATEGORY_DESTROY)
	e21:SetType(EFFECT_TYPE_QUICK_O)
	e21:SetCode(EVENT_CHAINING)
	e21:SetRange(LOCATION_MZONE)
	e21:SetCondition(c12852006.condition)
	e21:SetTarget(c12852006.target1)
	e21:SetOperation(c12852006.activate1)
	local e32=Effect.CreateEffect(c)
	e32:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e32:SetRange(LOCATION_SZONE)
	e32:SetTargetRange(LOCATION_MZONE,0)
	e32:SetTarget(c12852006.eftg)
	e32:SetLabelObject(e21)
	c:RegisterEffect(e32)
end
function c12852006.eftg(e,c)
	return c:IsType(TYPE_MONSTER) and c:GetEquipGroup():IsContains(e:GetHandler())
end
function c12852006.desfilter(c,col,tp,e)
	return col==aux.GetColumn(c) and c:IsControler(tp) and c:IsSetCard(0xa75) and not c:GetEquipGroup():IsContains(e:GetHandler())
end
function c12852006.descon(e,tp,eg,ep,ev,re,r,rp)
	local col=aux.GetColumn(e:GetHandler())
	return col and eg:IsExists(c12852006.desfilter,1,e:GetHandler(),col,tp,e)
end
function c12852006.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local col=aux.GetColumn(e:GetHandler())
	if chk==0 then return e:GetHandler():GetFlagEffect(12852006)==0  end
	e:GetHandler():RegisterFlagEffect(12852006,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
	local og=eg:Filter(c12852006.desfilter,nil,col,tp,e)
	og:KeepAlive()
	e:SetLabelObject(og)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c12852006.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local col=aux.GetColumn(e:GetHandler())
	local tc=e:GetLabelObject():GetFirst()
	if not tc then return end
	if c:IsRelateToEffect(e)  and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
function c12852006.eqlimit(e,c)
	return c:IsSetCard(0xa75)
end
function c12852006.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xa75)
end
function c12852006.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c12852006.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c12852006.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c12852006.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c12852006.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
function c12852006.repfilter(c,tp,hc)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
		and c:IsControler(tp) and c:GetReasonPlayer()==1-tp and not c:IsReason(REASON_REPLACE) and c:IsSetCard(0xa75)
end
function c12852006.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_DESTROY_CONFIRMED)
		and eg:IsExists(c12852006.repfilter,1,nil,tp,e:GetHandler()) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c12852006.repval(e,c)
	return c12852006.repfilter(c,e:GetHandlerPlayer(),e:GetHandler())
end
function c12852006.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end
function c12852006.filter1(c,p)
	return c:GetControler()==p and c:IsOnField() and c:IsSetCard(0xa75)
end
function c12852006.condition(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainNegatable(ev) then return false end
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	local ex1,tg1,tc1=Duel.GetOperationInfo(ev,CATEGORY_REMOVE)
	return (ex and tg~=nil and tg:IsExists(c12852006.filter1,1,nil,tp)) or (ex1 and tg1~=nil and tg1:IsExists(c12852006.filter1,1,nil,tp))
end
function c12852006.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetFlagEffect(tp,c:GetCode()+10000)==0  end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	Duel.RegisterFlagEffect(tp,c:GetCode()+10000,RESET_PHASE+PHASE_END,0,1)
end
function c12852006.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end