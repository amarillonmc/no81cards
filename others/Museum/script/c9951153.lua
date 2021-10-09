--妖妖梦自机·十六夜 咲夜
function c9951153.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x3bd2),4,2)
	--atk down
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9951153,3))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetCost(c9951153.cost)
	e2:SetTarget(c9951153.target)
	e2:SetOperation(c9951153.operation)
	c:RegisterEffect(e2)
	--position
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9951153,2))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCost(c9951153.cost)
	e2:SetTarget(c9951153.postg)
	e2:SetOperation(c9951153.posop)
	c:RegisterEffect(e2)
  --spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9951153.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9951153.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951153,0))
end
function c9951153.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9951153.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c9951153.spfilter(c,e,tp)
	return c:IsSetCard(0x3bd2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9951153.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsType(TYPE_MONSTER) and not tc:IsImmuneToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(800)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9951153.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
		if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.SelectYesNo(tp,aux.Stringid(9951153,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tc=g:Select(tp,1,1,nil):GetFirst()
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			local fid=c:GetFieldID()
			tc:RegisterFlagEffect(9951153,RESET_EVENT+RESETS_STANDARD,0,1,fid)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e3:SetCode(EVENT_PHASE+PHASE_END)
			e3:SetCountLimit(1)
			e3:SetLabel(fid)
			e3:SetLabelObject(tc)
			e3:SetCondition(c9951153.rmcon)
			e3:SetOperation(c9951153.rmop)
			Duel.RegisterEffect(e3,tp)
		end
	end
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c9951153.splimit)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c9951153.splimit(e,c)
	return not c:IsSetCard(0x3bd2)
end
function c9951153.rmcon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject():GetFlagEffectLabel(9951153)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c9951153.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
end
function c9951153.posfilter(c)
	return c:IsAttackPos() and not c:IsDisabled()
end
function c9951153.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c9951153.posfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9951153.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c9951153.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
	Duel.SetChainLimit(c9951153.chlimit)
end
function c9951153.chlimit(e,ep,tp)
	return tp==ep
end
function c9951153.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsAttackPos() and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
	if c:IsRelateToEffect(e) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_EXTRA_ATTACK)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
	end
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951153,0))
end