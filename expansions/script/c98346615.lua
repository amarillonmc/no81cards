--女儿的秘仪
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,98346615+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c98346615.sptg)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98346615,0))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,id+o)
	e2:SetTarget(c98346615.atktg)
	e2:SetOperation(c98346615.atkop)
	c:RegisterEffect(e2)
	--Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_LEAVE_FIELD_P)
	e3:SetOperation(c98346615.checkop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetOperation(c98346615.desop)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
	--disable
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_TARGET)
	e5:SetCode(EFFECT_DISABLE)
	e5:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e5)
	--attackchange
	local e6=e5:Clone()
	e6:SetCode(EFFECT_SET_ATTACK_FINAL)
	e6:SetValue(0)
	c:RegisterEffect(e6)
	--indes
	e7=e6:Clone()
	e7:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e7:SetValue(1)
	c:RegisterEffect(e7)
	--immune effect
	e8=e7:Clone()
	e8:SetCode(EFFECT_IMMUNE_EFFECT)
	e8:SetValue(c98346615.efilter)
	c:RegisterEffect(e8)
end
function c98346615.spfilter(c,e,tp)
	return c:IsSetCard(0xaf7) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98346615.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c98346615.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c98346615.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e:SetOperation(c98346615.activate)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectTarget(tp,c98346615.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c98346615.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c98346615.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsFaceup() and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(aux.nzatk,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,aux.nzatk,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c98346615.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		c:SetCardTarget(tc)
	end
end
function c98346615.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c98346615.desfilter(c,rc)
	return rc:IsHasCardTarget(c)
end
function c98346615.checkop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsDisabled() then
		e:SetLabel(1)
	else e:SetLabel(0) end
end
function c98346615.desop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject():GetLabel()~=0 then return end
	local g=Duel.GetMatchingGroup(c98346615.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e:GetHandler())
	Duel.Destroy(g,REASON_EFFECT)
end