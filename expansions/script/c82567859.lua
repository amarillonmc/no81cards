--方舟骑士·雪峰领主 银灰
function c82567859.initial_effect(c)
		--synchro summon
	aux.AddSynchroProcedure(c,c82567859.tunerfilter,aux.NonTuner(nil),1,1)
	c:EnableReviveLimit()
	--Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(82567801,1))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,82567859)
	e1:SetCost(c82567859.descost)
	e1:SetTarget(c82567859.destg)
	e1:SetOperation(c82567859.desop)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(82567801,2))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DAMAGE_STEP_END)
	e2:SetCondition(c82567859.damcon)
	e2:SetOperation(c82567859.damop)
	c:RegisterEffect(e2) 
	 --immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c82567859.efcon)
	e4:SetValue(c82567859.efilter)
	c:RegisterEffect(e4)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c82567859.valcheck)
	e3:SetLabelObject(e4)
	c:RegisterEffect(e3)
	--add setname
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_ADD_SETCODE)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetValue(0x825)
	c:RegisterEffect(e9)
end
function c82567859.tglimit(e,re,rp)
	return rp==1-e:GetHandlerPlayer() and re:IsActiveType(TYPE_MONSTER) 
end
function c82567859.valcheck(e,c)
	local mg=c:GetMaterial()
	if mg:GetCount()>0 and not mg:IsExists(c82567859.mfilter,1,nil) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c82567859.mfilter(c)
	return not c:IsType(TYPE_SYNCHRO)
end
function c82567859.efcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return e:GetLabel()==1 and c:IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c82567859.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:GetOwner()~=e:GetOwner()
		and te:IsActiveType(TYPE_SPELL+TYPE_MONSTER)
end
function c82567859.tunerfilter(c)
	return c:IsSetCard(0x825) and c:IsType(TYPE_TUNER) and c:IsType(TYPE_SYNCHRO)
end 
function c82567859.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x5825,2,REASON_COST) and Duel.IsExistingMatchingCard(c82567859.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.RemoveCounter(tp,1,0,0x5825,2,REASON_COST)
end 
function c82567859.desfilter(c,atk,e)
	return (c:IsFacedown() and c:IsLocation(LOCATION_MZONE)) or c:IsLocation(LOCATION_SZONE)
end
function c82567859.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c82567859.desfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c82567859.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c82567859.desfilter,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
	Duel.Destroy(g,REASON_EFFECT)
end  
end
function c82567859.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_MZONE,1,nil)
end
function c82567859.damop(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroupCount(nil,tp,0,LOCATION_MZONE,nil)
		Duel.Damage(1-tp,g*500,REASON_EFFECT)
end