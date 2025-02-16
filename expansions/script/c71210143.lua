--闇邪咏奏-邪魇始源神
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,71210113,aux.FilterBoolFunction(Card.IsRace,RACE_FIEND),1,true,true)
	if not s.global_flag then
		s.global_flag=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(s.regop)
		Duel.RegisterEffect(ge1,0)
	end
	s.check(c)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:IsCode(id) then
			local p=tc:GetSummonPlayer()
			Duel.RegisterFlagEffect(p,id,RESET_PHASE+PHASE_END,0,1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,0)
			e1:SetTarget(s.splimit)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function s.splimit(e,c)
	return c:IsCode(id) and c:IsLocation(LOCATION_EXTRA)
end

function s.check(c)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(1101)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetTarget(s.destg)
	e3:SetOperation(s.desop)
	c:RegisterEffect(e3)
end

function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x897) and c:IsType(TYPE_FUSION)  and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0	
		and tc:IsSetCard(0x897) and tc:IsType(TYPE_FUSION) and #g>0 and Duel.SelectYesNo(tp,2) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=g:Select(tp,1,1,nil):GetFirst()
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		local fid=c:GetFieldID()
		sc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetLabel(fid)
		e1:SetLabelObject(sc)
		e1:SetCondition(s.tgcon)
		e1:SetOperation(s.tgop)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(id)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetLabelObject(),nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end