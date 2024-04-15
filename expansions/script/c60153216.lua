--器灵槎·灵魂位移
function c60153216.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,60153216)
	e1:SetTarget(c60153216.target)
	e1:SetOperation(c60153216.activate)
	c:RegisterEffect(e1)
	
	--2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60153216,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetCountLimit(1,6013216)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c60153216.e2tg)
	e2:SetOperation(c60153216.e2op)
	c:RegisterEffect(e2)
end

function c60153216.filter(c,e,tp)
	return c:IsSetCard(0x3b2a) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove() and Duel.IsExistingMatchingCard(c60153216.filter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp,c:GetCode())
end
function c60153216.filter2(c,e,tp,code)
	return c:IsSetCard(0x3b2a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(code)
end
function c60153216.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60153216.filter,tp,LOCATION_MZONE,0,1,nil,e,tp)  end
	local g=Duel.GetMatchingGroup(c60153216.filter,tp,LOCATION_MZONE,0,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c60153216.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c60153216.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.HintSelection(g)
		if Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
			tc:RegisterFlagEffect(60153216,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetLabelObject(tc)
			e1:SetCountLimit(1)
			e1:SetCondition(c60153216.retcon)
			e1:SetOperation(c60153216.retop)
			Duel.RegisterEffect(e1,tp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,c60153216.filter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp,tc:GetCode())
			if sg:GetCount()>0 then
				Duel.BreakEffect()
				local tc2=sg:GetFirst()
				if tc2 and Duel.SpecialSummonStep(tc2,0,tp,tp,false,false,POS_FACEUP) then
					local e5=Effect.CreateEffect(c)
					e5:SetType(EFFECT_TYPE_SINGLE)
					e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
					e5:SetRange(LOCATION_MZONE)
					e5:SetCode(EFFECT_IMMUNE_EFFECT)
					e5:SetValue(c60153216.e4opf)
					e5:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc2:RegisterEffect(e5,true)
					local fid=c:GetFieldID()
					tc2:RegisterFlagEffect(60153216,RESET_EVENT+RESETS_STANDARD,0,1,fid)
					local e3=Effect.CreateEffect(c)
					e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e3:SetCode(EVENT_PHASE+PHASE_END)
					e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
					e3:SetCountLimit(1)
					e3:SetLabel(fid)
					e3:SetLabelObject(tc2)
					e3:SetCondition(c60153216.rmcon1)
					e3:SetOperation(c60153216.rmop1)
					Duel.RegisterEffect(e3,tp)
				end
				Duel.SpecialSummonComplete()
			end
		end
	end
end
function c60153216.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetFlagEffect(60153216)~=0
end
function c60153216.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function c60153216.e4opf(e,te)
	return te:GetOwnerPlayer()~=e:GetOwnerPlayer()
end
function c60153216.rmcon1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(60153216)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c60153216.rmop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetLabelObject(),POS_FACEUP,REASON_EFFECT)
end



--------------------------------------------------------------------------------------

function c60153216.e2tgf(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function c60153216.e2tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then
		return Duel.IsExistingMatchingCard(c60153216.e2tgf,tp,LOCATION_DECK,0,1,nil,e,tp)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(c60153216.e2tgf,1-tp,LOCATION_DECK,0,1,nil,e,1-tp)
			and Duel.GetLocationCount(1-tp,LOCATION_MZONE,1-tp)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_DECK)
end
function c60153216.e2op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c60153216.e2tgf,tp,LOCATION_DECK,0,nil,e,tp)
	local g2=Duel.GetMatchingGroup(c60153216.e2tgf,1-tp,LOCATION_DECK,0,nil,e,tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and g:GetCount()>0 and g2:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		local sc=sg:GetFirst()
		Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetCode(EFFECT_UNRELEASABLE_SUM)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(1)
		sc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		sc:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e3:SetValue(c60153216.fuslimit)
		sc:RegisterEffect(e3)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		sc:RegisterEffect(e4)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		sc:RegisterEffect(e5)
		local e6=e1:Clone()
		e6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		sc:RegisterEffect(e6)
		local e7=Effect.CreateEffect(c)
		e7:SetType(EFFECT_TYPE_SINGLE)
		e7:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_COPY_INHERIT)
		e7:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e7)
		local e8=Effect.CreateEffect(e:GetHandler())
		e8:SetType(EFFECT_TYPE_SINGLE)
		e8:SetCode(EFFECT_CANNOT_TRIGGER)
		e8:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e8,true)
		local e9=Effect.CreateEffect(c)
		e9:SetType(EFFECT_TYPE_SINGLE)
		e9:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e9:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e9:SetValue(LOCATION_REMOVED)
		sc:RegisterEffect(e9,true)
		sc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(60153216,2))
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
		local sg2=g2:Select(1-tp,1,1,nil)
		local oc=sg2:GetFirst()
		Duel.SpecialSummonStep(oc,0,1-tp,1-tp,false,false,POS_FACEDOWN_DEFENSE)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetCode(EFFECT_UNRELEASABLE_SUM)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(1)
		oc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		oc:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e3:SetValue(c60153216.fuslimit)
		oc:RegisterEffect(e3)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		oc:RegisterEffect(e4)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		oc:RegisterEffect(e5)
		local e6=e1:Clone()
		e6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		oc:RegisterEffect(e6)
		local e7=Effect.CreateEffect(c)
		e7:SetType(EFFECT_TYPE_SINGLE)
		e7:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_COPY_INHERIT)
		e7:SetReset(RESET_EVENT+RESETS_STANDARD)
		oc:RegisterEffect(e7)
		local e8=Effect.CreateEffect(e:GetHandler())
		e8:SetType(EFFECT_TYPE_SINGLE)
		e8:SetCode(EFFECT_CANNOT_TRIGGER)
		e8:SetReset(RESET_EVENT+RESETS_STANDARD)
		oc:RegisterEffect(e8,true)
		local e9=Effect.CreateEffect(c)
		e9:SetType(EFFECT_TYPE_SINGLE)
		e9:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e9:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e9:SetValue(LOCATION_REMOVED)
		oc:RegisterEffect(e9,true)
		oc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(60153216,2))
		Duel.SpecialSummonComplete()
	end
end
function c60153216.fuslimit(e,c,st)
	return st==SUMMON_TYPE_FUSION
end

