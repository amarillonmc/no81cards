--白骨冥王
function c98920087.initial_effect(c)
	aux.AddCodeList(c,32274490)
--synchro summon
	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,c98920087.matfilter1,nil,nil,aux.NonTuner(nil),1,99)
--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(c98920087.matcheck)
	c:RegisterEffect(e1)
--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920087,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c98920087.negcon)
	e2:SetTarget(c98920087.negtg)
	e2:SetOperation(c98920087.negop)
	c:RegisterEffect(e2)
--material check
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(c98920087.matcon)
	e5:SetOperation(c98920087.matop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_MATERIAL_CHECK)
	e6:SetValue(c98920087.valcheck)
	e6:SetLabelObject(e5)
	c:RegisterEffect(e6)
end
function c98920087.matfilter1(c)
	return c:IsSynchroType(TYPE_TUNER) or aux.IsCodeListed(c,32274490) or c:IsCode(32274490)
end
function c98920087.matfilter(c)
	return aux.IsCodeListed(c,32274490) or c:IsCode(32274490)
end
function c98920087.matcheck(e,c)
	local g=c:GetMaterial():Filter(c98920087.matfilter,nil)
	local atk=g:GetCount()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(atk*1000)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
end
function c98920087.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return (re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev) and e:GetHandler():GetFlagEffectLabel(98920390) and e:GetHandler():GetFlagEffectLabel(98920390)>0
end
function c98920087.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(98920087)<c:GetFlagEffectLabel(98920390) end
	c:RegisterFlagEffect(98920087,RESET_EVENT+RESETS_STANDARD,0,1)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c98920087.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c98920087.matcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetLabel()>0
end
function c98920087.matop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(98920390,RESET_EVENT+RESETS_STANDARD,0,1,e:GetLabel())
end
function c98920087.valcheck(e,c)
	local g=c:GetMaterial()
	local ct=g:FilterCount(c98920087.matfilter,nil)
	e:GetLabelObject():SetLabel(ct)
end