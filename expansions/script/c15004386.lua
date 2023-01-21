local m=15004386
local cm=_G["c"..m]
cm.name="溶于苍白星海的无瑕"
function cm.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,cm.matfilter1,nil,nil,aux.NonTuner(nil),1,99)
	--add type & attack
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.tncon)
	e1:SetTarget(cm.tntg)
	e1:SetOperation(cm.tnop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(cm.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--activate cost
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_ACTIVATE_COST)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0,1)
	e3:SetCondition(cm.accon)
	e3:SetTarget(cm.actarget)
	e3:SetCost(cm.accost)
	e3:SetOperation(cm.acop)
	c:RegisterEffect(e3)
	--activate cost
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_ACTIVATE_COST)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(0,1)
	e4:SetCost(cm.costchk)
	e4:SetTarget(cm.costtg)
	e4:SetOperation(cm.costop)
	c:RegisterEffect(e4)
	--accumulate
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(0x10000000+15004387)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(0,1)
	c:RegisterEffect(e5)
end
function cm.matfilter1(c)
	return c:IsSynchroType(TYPE_TUNER) or (c:IsSynchroType(TYPE_SYNCHRO) and c:IsSetCard(0xcf30))
end
function cm.valcheck(e,c)
	local flag=0
	local g=c:GetMaterial()
	if g:IsExists(Card.IsSetCard,1,nil,0xcf30) then
		flag=flag|1
	end
	e:GetLabelObject():SetLabel(flag)
end
function cm.tncon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetLabel()>0
end
function cm.filter(c,tp)
	return c:IsSetCard(0xcf30) and c:IsType(TYPE_MONSTER) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function cm.tntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_GRAVE)
end
function cm.tnop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.filter),tp,LOCATION_GRAVE,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		if not Duel.Equip(tp,tc,c) then return end
		--Add Equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(cm.eqlimit)
		tc:RegisterEffect(e1)
	end
end
function cm.eqlimit(e,c)
	return e:GetOwner()==c
end
function cm.accon(e)
	c15004386[0]=false
	return true
end
function cm.actarget(e,te,tp)
	return te:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function cm.accost(e,te,tp)
	local count=e:GetHandler():GetEquipCount()
	return Duel.IsPlayerCanDiscardDeckAsCost(tp,count)
end
function cm.acop(e,tp,eg,ep,ev,re,r,rp)
	if c15004386[0] then return end
	local count=e:GetHandler():GetEquipCount()
	Duel.DiscardDeck(tp,count,REASON_COST)
	c15004386[0]=true
end
function cm.costchk(e,te_or_c,tp)
	local ct=Duel.GetFlagEffect(tp,15004387)
	local count=e:GetHandler():GetEquipCount()
	ct=ct*count
	return Duel.CheckLPCost(tp,ct*300)
end
function cm.costtg(e,te,tp)
	return te:IsActiveType(TYPE_MONSTER)
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	local count=e:GetHandler():GetEquipCount()
	Duel.PayLPCost(tp,count*300)
end