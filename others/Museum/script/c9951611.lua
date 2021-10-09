--Fate Grand Order
function c9951611.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c9951611.ffilter,3,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
--special summon (extra)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9951611,3))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c9951611.esptg)
	e4:SetOperation(c9951611.espop)
	c:RegisterEffect(e4)
--Equip
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c9951611.condition)
	e3:SetTarget(c9951611.target)
	e3:SetOperation(c9951611.operation)
	c:RegisterEffect(e3)
  --destroy
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(9951611,0))
	e7:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_LEAVE_FIELD)
	e7:SetCondition(c9951611.descon)
	e7:SetTarget(c9951611.destg)
	e7:SetOperation(c9951611.desop)
	c:RegisterEffect(e7)
	 --spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9951611.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9951611.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951611,0))
end
function c9951611.ffilter(c)
	return not c:IsFusionType(TYPE_EFFECT) and c:IsFusionSetCard(0xba5) and c:IsLevelAbove(10)
end
function c9951611.espfilter(c,e,tp)
	return c:IsSetCard(0xba5) and c:IsType(TYPE_FUSION) and not c:IsCode(9951611)
		and c:IsCanBeSpecialSummoned(e,124,tp,true,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c9951611.esptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9951611.espfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9951611.espop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9951611.espfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,124,tp,tp,true,false,POS_FACEUP)
	end
end
function c9951611.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c9951611.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xba5)
end
function c9951611.filter2(c)
	return not c:IsForbidden()
end
function c9951611.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c9951611.cfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c9951611.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c9951611.filter2,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c9951611.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,0)
end
function c9951611.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if not tc:IsFaceup() or not tc:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local sg=Duel.SelectMatchingCard(tp,c9951611.filter2,tp,0,LOCATION_MZONE,1,1,nil)
	local sc=sg:GetFirst()
	if sc then
		if not Duel.Equip(tp,sc,tc) then return end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c9951611.eqlimit)
		e1:SetLabelObject(tc)
		sc:RegisterEffect(e1)
	end
end
function c9951611.eqlimit(e,c)
	return e:GetLabelObject()==c
end
function c9951611.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and not c:IsLocation(LOCATION_DECK)
		and (not re or re:GetOwner()~=c)
end
function c9951611.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	if g:GetCount()~=0 then
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*1000)
	end
end
function c9951611.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	local ct=Duel.Destroy(g,REASON_EFFECT)
	if ct~=0 then
		Duel.Damage(1-tp,ct*1000,REASON_EFFECT)
	end
end
