--魔皇剑 觉醒之魔剑
function c25000160.initial_effect(c)
	c:EnableCounterPermit(0xaf1)
	c:SetCounterLimit(0xaf1,3)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetCountLimit(1,25000160+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c25000160.target)
	e1:SetOperation(c25000160.operation)
	c:RegisterEffect(e1)
	--COUNTER
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCost(c25000160.ctcost)
	e2:SetTarget(c25000160.cttg)
	e2:SetOperation(c25000160.ctop)
	c:RegisterEffect(e2)
	--Equip limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_EQUIP_LIMIT)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetValue(c25000160.eqlimit)
	c:RegisterEffect(e4)
end
function c25000160.eqlimit(e,c)
	return c:IsRace(RACE_ZOMBIE)
end
function c25000160.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_ZOMBIE)
end
function c25000160.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c25000160.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c25000160.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c25000160.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c25000160.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c25000160.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,Duel.GetLP(tp)/2) end
	Duel.PayLPCost(tp,Duel.GetLP(tp)/2)
end
function c25000160.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=c:GetFlagEffect(25000160)==0
	local b2=c:GetFlagEffect(05000160)==0
	local b3=c:GetFlagEffect(15000160)==0
	if chk==0 then return e:GetHandler():GetEquipTarget()~=nil and e:GetHandler():IsCanAddCounter(0xaf1,1) and (b1 or b2 or b3) end  
end
function c25000160.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	c:AddCounter(0xaf1,1)
	local op=0
	local b1=c:GetFlagEffect(25000160)==0
	local b2=c:GetFlagEffect(05000160)==0
	local b3=c:GetFlagEffect(15000160)==0
	if b1 and b2 and b3 then 
	op=Duel.SelectOption(tp,aux.Stringid(25000160,0),aux.Stringid(25000160,1),aux.Stringid(25000160,2))
	elseif b1 and b2 then
	op=Duel.SelectOption(tp,aux.Stringid(25000160,0),aux.Stringid(25000160,1))
	elseif b2 and b3 then
	op=Duel.SelectOption(tp,aux.Stringid(25000160,1),aux.Stringid(25000160,2))+1
	elseif b1 and b3 then
	op=Duel.SelectOption(tp,aux.Stringid(25000160,0),aux.Stringid(25000160,2))
	if op==1 then op=op+1 end
	elseif b1 then  
	op=Duel.SelectOption(tp,aux.Stringid(25000160,0))
	elseif b2 then 
	op=Duel.SelectOption(tp,aux.Stringid(25000160,1))+1
	elseif b3 then 
	op=Duel.SelectOption(tp,aux.Stringid(25000160,2))+2
	end
	if op==0 then 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e1:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1) 
	c:RegisterFlagEffect(25000160,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(25000160,0))
	elseif op==1 then
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_ATTACK_ALL)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1) 
	c:RegisterFlagEffect(05000160,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(25000160,1))
	elseif op==2 then
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_INACTIVATE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetValue(c25000160.efilter)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	c:RegisterFlagEffect(15000160,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(25000160,2))
	end
	end
end
function c25000160.efilter(e,ct)
	local p=e:GetHandlerPlayer()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return te:GetHandler()==e:GetHandler():GetEquipTarget()
end






