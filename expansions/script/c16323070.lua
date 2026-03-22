--王·异甲同心
function c16323070.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c16323070.immtg)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD)
	e11:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e11:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e11:SetRange(LOCATION_SZONE)
	e11:SetTargetRange(1,0)
	e11:SetTarget(c16323070.splimit)
	c:RegisterEffect(e11)
	--to hand and spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,16323070)
	e2:SetTarget(c16323070.tstg)
	e2:SetOperation(c16323070.tsop)
	c:RegisterEffect(e2)
end
function c16323070.rmfilter(c,e,tp)
	return c:IsFaceup() and (c:IsSetCard(0x3dcf) or c:IsRace(0x20)) and c:IsAbleToRemove()
		and Duel.IsExistingMatchingCard(c16323070.spfilter,tp,0x12,0,1,nil,e,tp,c)
end
function c16323070.spfilter(c,e,tp,tc)
	return (c:IsSetCard(0x3dcf) or c:IsRace(0x20)) and c:IsLevel(tc:GetLevel())
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetMZoneCount(tp,tc)>0
end
function c16323070.tstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c16323070.rmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c16323070.rmfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c16323070.rmfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x12)
end
function c16323070.tsop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)~=0
		and tc:IsLocation(LOCATION_REMOVED) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(16323070,1))
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetLabelObject(tc)
		e1:SetCountLimit(1)
		e1:SetCondition(c16323070.retcon)
		e1:SetOperation(c16323070.retop)
		if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()<=PHASE_STANDBY then
			e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
			e1:SetValue(Duel.GetTurnCount())
			tc:RegisterFlagEffect(16323070,RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,2)
		else
			e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
			e1:SetValue(0)
			tc:RegisterFlagEffect(16323070,RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,1)
		end
		Duel.RegisterEffect(e1,tp)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c16323070.spfilter),tp,0x12,0,1,1,nil,e,tp,tc)
		if sg:GetCount()>0 then
			local sc=sg:GetFirst()
			if sc and Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)~=0 then
				local fid=e:GetHandler():GetFieldID()
				sc:RegisterFlagEffect(16323070,RESET_EVENT+RESETS_STANDARD,0,1,fid)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e2:SetCode(EVENT_PHASE+PHASE_END)
				e2:SetCountLimit(1)
				e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e2:SetLabel(fid)
				e2:SetLabelObject(sc)
				e2:SetCondition(c16323070.descon)
				e2:SetOperation(c16323070.desop)
				Duel.RegisterEffect(e2,tp)
			end
		end
	end
end
function c16323070.retcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp or Duel.GetTurnCount()==e:GetValue() then return false end
	return e:GetLabelObject():GetFlagEffect(16323070)~=0
end
function c16323070.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.ReturnToField(tc)
end
function c16323070.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(16323070)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c16323070.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetLabelObject(),REASON_EFFECT)
end
function c16323070.immtg(e,c)
	return c:IsRace(0x20) and c:IsStatus(STATUS_SPSUMMON_TURN)
end
function c16323070.splimit(e,c)
	return not (c:IsRace(RACE_MACHINE) or c:IsSetCard(0x3dcf))
end