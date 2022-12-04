function c4877088.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	c:EnableReviveLimit()
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.ritlimit)
	c:RegisterEffect(e0)
	   local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4877088,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,4877088)
	e1:SetTarget(c4877088.thtg)
	e1:SetOperation(c4877088.thop)
	c:RegisterEffect(e1)
		 local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_LSCALE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCondition(c4877088.condition)
	e3:SetValue(2)
	c:RegisterEffect(e3)
	local e8=e3:Clone()
	e8:SetCode(EFFECT_UPDATE_LSCALE)
	c:RegisterEffect(e8)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_UPDATE_RSCALE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCondition(c4877088.condition1)
	e6:SetValue(-2)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_UPDATE_LSCALE)
	c:RegisterEffect(e7)
		local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetValue(c4877088.indct)
	c:RegisterEffect(e2)
	  local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c4877088.matcon)
	e4:SetOperation(c4877088.matop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_MATERIAL_CHECK)
	e5:SetValue(c4877088.valcheck)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(4877088,1))
	e8:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetCode(EVENT_CHAINING)
	e8:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCondition(c4877088.discon)
	e8:SetTarget(c4877088.distg)
	e8:SetOperation(c4877088.disop)
	c:RegisterEffect(e8)
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(4877088,2))
	e9:SetType(EFFECT_TYPE_QUICK_O)
	e9:SetCode(EVENT_CHAINING)
	e9:SetCode(EVENT_FREE_CHAIN)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCountLimit(1,4877089)
	e9:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e9:SetCondition(c4877088.condition2)
	e9:SetTarget(c4877088.pentg)
	e9:SetOperation(c4877088.penop)
	c:RegisterEffect(e9)
end
function c4877088.cfilter1(c)
	return  c:IsType(TYPE_PENDULUM)
end
function c4877088.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c4877088.cfilter,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler()==Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_PZONE,0)
end
function c4877088.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
	  
end
function c4877088.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c4877088.cfilter,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler()==Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_PZONE,1)
end
function c4877088.penfilter(c,e,tp)
	return c:IsAbleToHand()
end
function c4877088.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c4877088.penfilter,tp,LOCATION_PZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_PZONE)
end
function c4877088.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c4877088.penfilter,tp,LOCATION_PZONE,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SendtoHand(g,tp,REASON_EFFECT)>0 then
		Duel.SendtoExtraP(c,nil,REASON_EFFECT)
	end
end
function c4877088.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and e:GetHandler():GetFlagEffectLabel(4877089) and e:GetHandler():GetFlagEffectLabel(4877089)>0
end
function c4877088.distg(e,tp,eg,ep,ev,re,r,rp,chk)
   local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(4877088)<c:GetFlagEffectLabel(4877089) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	c:RegisterFlagEffect(4877088,RESET_EVENT+RESETS_STANDARD,0,1)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c4877088.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	 local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) 
		then
	   Duel.Destroy(rc,REASON_EFFECT)
	end
end
function c4877088.matcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL) and e:GetLabel()>0
end
function c4877088.matop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(4877089,RESET_EVENT+RESETS_STANDARD,0,1,e:GetLabel())
end
function c4877088.valcheck(e,c)
	local g=c:GetMaterial()
	local ct=0
	local tc=g:GetFirst()
	while tc do
	if bit.band(tc:GetOriginalType(),0x81)==0x81 then
	ct=ct+1
	end
	tc=g:GetNext()
	end
	e:GetLabelObject():SetLabel(ct)
end
function c4877088.thfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c4877088.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4877088.thfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil) and e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c4877088.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c4877088.thfilter),tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) then
		if c:IsRelateToEffect(e) then
			Duel.BreakEffect()
			Duel.SendtoDeck(c,nil,1,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,c)
		end
	end
end
function c4877088.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE)~=0 then
		return 1
	else return 0 end
end
function c4877088.cfilter(c)
	return  c:GetSequence()<5 and c:IsType(TYPE_RITUAL)
end