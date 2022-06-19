--Fallacio Sharpshooter
function c31000009.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,31000009)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c31000009.spcon)
	e1:SetCost(c31000009.spcst)
	e1:SetTarget(c31000009.sptg)
	e1:SetOperation(c31000009.spop)
	c:RegisterEffect(e1)
	--Remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,31000010)
	e2:SetTarget(c31000009.target)
	e2:SetOperation(c31000009.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCountLimit(1)
	e5:SetCondition(c31000009.sycon)
	c:RegisterEffect(e5)
	--Search
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_SEARCH)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetTarget(c31000009.tg)
	e6:SetOperation(c31000009.op)
	c:RegisterEffect(e6)
	Duel.AddCustomActivityCounter(31000009,ACTIVITY_SUMMON,c31000009.counterfilter)
	Duel.AddCustomActivityCounter(31000009,ACTIVITY_SPSUMMON,c31000009.counterfilter)
end

function c31000009.counterfilter(c)
	return c:IsSetCard(0x308) or c:IsCode(31000002)
end

function c31000009.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(31000009,tp,ACTIVITY_SUMMON)==0
	 	and Duel.GetCustomActivityCount(31000009,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c31000009.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e2,tp)
end

function c31000009.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x308) and not c:IsCode(31000002)
end

function c31000009.spcon(e,tp,eg,ep,ev,re,r,rp)
	local spfilter=function(c)
		return c:IsCode(31000002) and c:IsLevel(e:GetHandler():GetLevel())
	end
	return Duel.IsExistingMatchingCard(spfilter,tp,nil,LOCATION_MZONE,1,nil)
end

function c31000009.spcst(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,nil,1,nil)
		and c31000009.cost(e,tp,eg,ep,ev,re,r,rp,0) end
	local sg=Duel.SelectReleaseGroup(tp,nil,1,1,nil)
	Duel.Release(sg,REASON_COST)
	c31000009.cost(e,tp,eg,ep,ev,re,r,rp)
end

function c31000009.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function c31000009.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c31000009.spfilter(c,typ)
	return c:IsSetCard(0x308) and c:IsType(typ)
end

function c31000009.opfilter(c)
	return Duel.IsExistingMatchingCard(c31000009.spfilter,tp,LOCATION_DECK,nil,1,nil,c:GetType()) and c:IsPosition(POS_FACEUP)
end

function c31000009.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local filter=function(c)
		return c:IsSetCard(0x308)
	end
	local gc=Duel.GetMatchingGroupCount(filter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return Duel.GetFieldGroup(tp,0,LOCATION_HAND):GetCount()>=gc
		and c31000009.cost(e,tp,eg,ep,ev,re,r,rp,0) end
	e:SetLabel(gc)
	c31000009.cost(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,0,0,1-tp,e:GetLabel())
end

function c31000009.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()>=e:GetLabel() then
		local sg=g:RandomSelect(1-tp,e:GetLabel())
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		sg:KeepAlive()
		local c=e:GetHandler()
		local fid=c:GetFieldID()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(sg)
		e1:SetOperation(c31000009.retop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		for rc in aux.Next(sg) do
			rc:RegisterFlagEffect(31000009,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
		end
	end
end

function c31000009.retop(e,tp,eg,ep,ev,re,r,rp)
	local sg=e:GetLabelObject()
	for rc in aux.Next(sg) do
		if rc:GetFlagEffectLabel(31000009)~=e:GetLabel() then
			sg:RemoveCard(rc)
		end
	end
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
end

function c31000009.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_REMOVED) and c31000009.opfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c31000009.opfilter,tp,0,LOCATION_REMOVED,1,nil)
		and c31000009.cost(e,tp,eg,ep,ev,re,r,rp,0) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c31000009.opfilter,tp,0,LOCATION_REMOVED,1,1,nil)
	c31000009.cost(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetOperationInfo(0,CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK)
end

function c31000009.op(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(c31000009.spfilter,tp,LOCATION_DECK,0,nil,c:GetType())
	if c:IsRelateToEffect(e) and g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		if tc and Duel.IsPlayerCanSendtoHand(tp,tc) then
			Duel.SendtoHand(sg,tp,REASON_EFFECT)
		end
	end
end

function c31000009.sycon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsType(TYPE_SYNCHRO)
end
