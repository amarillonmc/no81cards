--梦蚀
xpcall(function() require("expansions/script/c71400001") end,function() require("script/c71400001") end)
function c71400025.initial_effect(c)
	--activate from hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e0:SetCondition(yume.nonYumeCon)
	c:RegisterEffect(e0)
	--Activate(nofield)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71400025,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(yume.nonYumeCon)
	e1:SetTarget(yume.YumeFieldCheckTarget(0,2))
	e1:SetCost(c71400025.cost1)
	e1:SetOperation(c71400025.op1)
	e1:SetCountLimit(1,71400025+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
	--Activate(field)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71400025,1))
	e2:SetCondition(yume.YumeCon)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,71400025+EFFECT_COUNT_CODE_OATH)
	e2:SetCost(c71400025.cost2)
	e2:SetTarget(c71400025.tg2)
	e2:SetOperation(c71400025.op2)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(71400025,ACTIVITY_SPSUMMON,c71400025.counterfilter)
end
function c71400025.counterfilter(c)
	return c:GetSummonLocation()~=LOCATION_EXTRA or c:IsType(TYPE_LINK)
end
function c71400025.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function c71400025.op1(e,tp,eg,ep,ev,re,r,rp)
	yume.FieldActivation(tp,nil,2)
end
function c71400025.filter2(c)
	return c:IsType(TYPE_LINK)
end
function c71400025.filter2a(c,e,tp)
	return c:IsSetCard(0x714) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c71400025.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(71400025,tp,ACTIVITY_SPSUMMON)==0 and Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c71400025.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c71400025.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not (c:IsType(TYPE_LINK)) and c:IsLocation(LOCATION_EXTRA)
end
function c71400025.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsType(TYPE_LINK) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c71400025.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(c71400025.filter2a,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c71400025.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c71400025.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local ft=math.min(Duel.GetLocationCount(tp,LOCATION_MZONE),tc:GetLink())
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c71400025.filter2a),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,ft,nil,e,tp)
	if sg:GetCount()>0 then
		local sc=sg:GetFirst()
		local fid=c:GetFieldID()
		while sc do
			if Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP) then
				sc:RegisterFlagEffect(71400025,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
			end
			sc=sg:GetNext()
		end
		Duel.SpecialSummonComplete()
		sg:KeepAlive()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetCondition(c71400025.rmcon)
		e1:SetOperation(c71400025.rmop)
		e1:SetLabel(fid)
		e1:SetLabelObject(sg)
		Duel.RegisterEffect(e1,tp)
	end
end
function c71400025.rmfilter(c,fid)
	return c:GetFlagEffectLabel(71400025)==fid
end
function c71400025.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c71400025.rmfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c71400025.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c71400025.rmfilter,nil,e:GetLabel())
	Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
end