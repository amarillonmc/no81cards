--无 限 世 界 ·奥 契 丝
local m=22348164
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,22348157)
	--public
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22348164,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,22348164)
	e1:SetOperation(c22348164.operation)
	c:RegisterEffect(e1)
	--link summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22348164,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,22349164)
	e2:SetCondition(c22348164.spcon)
	e2:SetTarget(c22348164.sptg)
	e2:SetOperation(c22348164.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetRange(LOCATION_HAND)
	e4:SetCondition(c22348164.checkcon)
	e4:SetOperation(c22348164.checkop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	--adjust
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e6:SetCode(EVENT_ADJUST)
	e6:SetRange(LOCATION_HAND)
	e6:SetOperation(c22348164.adjustop)
	c:RegisterEffect(e6)
end
function c22348164.checkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	return eg:IsExists(Card.IsCode,1,nil,22348157) and c:IsPublic()
end
function c22348164.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	while tc do
		local flag=c:GetFlagEffectLabel(22348164)
		if flag then
			c:SetFlagEffectLabel(22348164,flag+1)
		else
			c:RegisterFlagEffect(22348164,RESET_EVENT+RESETS_STANDARD,0,1,1)
		end
		tc=eg:GetNext()
	end
end
function c22348164.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	local c=e:GetHandler()
	local flag=c:GetFlagEffectLabel(22348164)
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	if not c:IsPublic() and flag then
	c:SetFlagEffectLabel(22348164,0)
	end
end
function c22348164.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local fid=c:GetFieldID()
	c:RegisterFlagEffect(22348165,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,EFFECT_FLAG_CLIENT_HINT,1,fid,66)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(22348164)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetLabel(fid)
	e2:SetLabelObject(c)
	e2:SetCondition(c22348164.indcon)
	e2:SetTarget(c22348164.indtg)
	e2:SetValue(1)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e2,tp)
end
function c22348164.indcon(e)
	local c=e:GetLabelObject()
	return c:GetFlagEffectLabel(22348165)==e:GetLabel()
end
function c22348164.indtg(e,c)
	return c:IsFacedown()
end
function c22348164.spfilter(c,tp)
	return c:IsFaceup() and c:IsCode(22348157) and c:IsControler(tp)
end
function c22348164.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22348164.spfilter,1,nil,tp)
end
function c22348164.desfilter(c,tp)
	return Duel.GetMZoneCount(tp,c)>0 and c:IsCode(22348157) and c:IsFaceup()
end
function c22348164.sppfilter(c,e,tp)
	return c:IsCode(22348165) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22348164.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local cl=e:GetHandler():GetFlagEffectLabel(22348164)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and chkc:IsFaceup() and c22348164.desfilter(chkc,tp) end
	if chk==0 then return cl and cl>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(c22348164.desfilter,tp,LOCATION_ONFIELD,0,1,nil,tp) 
		and (cl<3 or (Duel.IsExistingMatchingCard(c22348164.sppfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0))
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c22348164.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	if cl<3 then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	else
		c:RegisterFlagEffect(22348167,RESET_EVENT+RESET_CHAIN,0,1,1)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
	end
end
function c22348164.spppfilter(c,e,tp)
	return c:IsCode(22348165) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22348164.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local cl=c:GetFlagEffectLabel(22348167)
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		if cl and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c22348164.spppfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
		end
	end
end
