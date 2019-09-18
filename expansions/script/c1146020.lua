--跨越时空之船的船长
function c1146020.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,2,c1146020.lcheck)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1146020,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c1146020.con1)
	e1:SetTarget(c1146020.tg1)
	e1:SetOperation(c1146020.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1146020,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetTarget(c1146020.tg2)
	e2:SetOperation(c1146020.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCondition(c1146020.con3)
	e3:SetOperation(c1146020.op3)
	c:RegisterEffect(e3)
--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1146020,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_REMOVED)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_DUEL)
	e4:SetCondition(c1146020.con4)
	e4:SetTarget(c1146020.tg4)
	e4:SetOperation(c1146020.op4)
	c:RegisterEffect(e4)
--
end
--
function c1146020.lcheck(g,lc)
	return g:IsExists(Card.IsRace,1,nil,RACE_ZOMBIE)
end
--
function c1146020.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
--
function c1146020.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local gc=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,gc,gc:GetCount(),0,0)
end
--
function c1146020.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local gc=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
	if Duel.Remove(gc,POS_FACEUP,REASON_EFFECT)>0 then
		local tg=Duel.GetOperatedGroup()
		local tc=tg:GetFirst()
		for tc in aux.Next(tg) do
			local e1_1=Effect.CreateEffect(c)
			e1_1:SetType(EFFECT_TYPE_SINGLE)
			e1_1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1_1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1_1:SetRange(LOCATION_REMOVED)
			e1_1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1_1)
		end
		if c:IsFacedown() then return end
		if c:GetControler()~=tp then return end
		if not c:IsRelateToEffect(e) then return end
		if not c:IsLocation(LOCATION_MZONE) then return end
		local fid=c:GetFieldID()
		local tc=tg:GetFirst()
		for tc in aux.Next(tg) do
			tc:RegisterFlagEffect(1146020,RESET_EVENT+0x1fe0000,0,0,fid)
		end
		local e1_2=Effect.CreateEffect(c)
		e1_2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1_2:SetCode(EVENT_LEAVE_FIELD)
		e1_2:SetLabel(fid)
		e1_2:SetLabelObject(c)
		e1_2:SetCondition(c1146020.con1_2)
		e1_2:SetOperation(c1146020.op1_2)
		Duel.RegisterEffect(e1_2,tp)
	end
end
--
function c1146020.con1_2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc and eg:IsContains(tc)
end
function c1146020.ofilter1_2(c,fid)
	return c:GetFlagEffectLabel(1146020)==fid
end
function c1146020.op1_2(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c1146020.ofilter1_2,tp,LOCATION_REMOVED,0,nil,e:GetLabel())
	if sg:GetCount()>0 then
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RETURN)
	end
	e:Reset()
end
--
function c1146020.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
--
function c1146020.op2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
--
function c1146020.con3(e,tp,eg,ep,ev,re,r,rp)
	return r and bit.band(r,REASON_EFFECT)~=0
end
--
function c1146020.op3(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsFacedown() then return end
	e:GetHandler():RegisterFlagEffect(1146021,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
--
function c1146020.con4(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(1146021)~=0
end
--
function c1146020.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
--
function c1146020.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local e4_1=Effect.CreateEffect(c)
	e4_1:SetDescription(aux.Stringid(1146020,3))
	e4_1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4_1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4_1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4_1:SetRange(LOCATION_REMOVED)
	e4_1:SetCountLimit(1)
	e4_1:SetOperation(c1146020.op4_1)
	e4_1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
	c:RegisterEffect(e4_1)
end
--
function c1146020.op4_1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=(Duel.GetMZoneCount(tp)>0)
	local b2=c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	if b1 and b2 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	e:Reset()
end
--
