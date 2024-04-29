--魔导龙骑士-异色眼虹彩龙
function c98920734.initial_effect(c)
	c:SetUniqueOnField(1,0,98920734)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c98920734.ffilter,c98920734.fffilter,true)
	aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_MZONE,0,Duel.Release,REASON_COST+REASON_MATERIAL)
	--pendulum set/spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920734,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,98920734)
	e1:SetTarget(c98920734.sptg)
	e1:SetOperation(c98920734.spop)
	c:RegisterEffect(e1)
	--Negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920734,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c98920734.discon)
	e2:SetTarget(c98920734.distg)
	e2:SetOperation(c98920734.disop)
	c:RegisterEffect(e2)
	--material check
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(c98920734.matcon)
	e5:SetOperation(c98920734.matop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_MATERIAL_CHECK)
	e6:SetValue(c98920734.valcheck)
	e6:SetLabelObject(e5)
	c:RegisterEffect(e6)
	--pendulum
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920734,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c98920734.pencon)
	e2:SetTarget(c98920734.pentg)
	e2:SetOperation(c98920734.penop)
	c:RegisterEffect(e2)
end
function c98920734.ffilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsSetCard(0x99)
end
function c98920734.fffilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x98)
end
function c98920734.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return Duel.IsChainNegatable(ev) and e:GetHandler():GetFlagEffectLabel(98920734) and e:GetHandler():GetFlagEffectLabel(98920734)>0
end
function c98920734.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(98920733)<c:GetFlagEffectLabel(98920734)  end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	c:RegisterFlagEffect(98920733,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c98920734.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c98920734.matcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabel()>0
end
function c98920734.matop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(98920734,RESET_EVENT+RESETS_STANDARD,0,1,e:GetLabel())
end
function c98920734.valcheck(e,c)
	local g=c:GetMaterial()
	local ct=g:FilterCount(Card.IsFusionSetCard,nil,0x10f2)
	e:GetLabelObject():SetLabel(ct)
end
function c98920734.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c98920734.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c98920734.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c98920734.spfilter(c,e,tp)
	return c:IsSetCard(0x10f2) and (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c98920734.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable()
		and Duel.IsExistingMatchingCard(c98920734.spfilter,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_HAND)
end
function c98920734.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c98920734.spfilter,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end