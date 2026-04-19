--廷达魔三角之牢兽
local s,id,o=GetID()
function s.initial_effect(c)
	--leavefield
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_LEAVE_FIELD_P)
	e3:SetOperation(s.checkop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetOperation(s.thop)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_MAIN_END,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--flip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetLabelObject(e3)
	e2:SetCountLimit(1,id+o)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
	--
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(s.checkop2)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.checkop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		--Debug.Message("0")
		if tc:IsSetCard(0x10b) and (tc:IsPreviousLocation(LOCATION_HAND) or tc:IsPreviousLocation(LOCATION_DECK)) then
		--Debug.Message("1")
			Duel.RegisterFlagEffect(0,id,RESET_PHASE+PHASE_END,0,1)
		end
		tc=eg:GetNext()
	end
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(0,id)>0 and Duel.IsMainPhase()
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and aux.NecroValleyFilter()(c) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)~=0 then
		Duel.ConfirmCards(1-tp,c)
		if Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,tp)
			and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,2,c,tp)
			Duel.HintSelection(tg)
			if Duel.Remove(tg,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
				local fid=c:GetFieldID()
				local og=Duel.GetOperatedGroup()
				local oc=og:GetFirst()
				while oc do
					oc:RegisterFlagEffect(id+o,RESET_EVENT+RESETS_STANDARD,0,1,fid)
					oc=og:GetNext()
				end
				c:RegisterFlagEffect(id+o,RESET_EVENT+RESET_TURN_SET+RESET_OVERLAY+RESET_TOFIELD,0,1,fid)
				og:KeepAlive()
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e1:SetCode(EVENT_LEAVE_FIELD)
				e1:SetLabel(fid)
				e1:SetLabelObject(og)
				e1:SetCondition(s.retcon)
				e1:SetOperation(s.retop)
				Duel.RegisterEffect(e1,tp)
			end
		end
	end
end
function s.retfilter(c,fid)
	return c:GetFlagEffectLabel(id+o)==fid
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetOwner()
	--Debug.Message("0")
	local g=e:GetLabelObject()
	if not s.retfilter(c,e:GetLabel()) then 
		e:Reset() 
		--Debug.Message("1") 
		return false 
	end
	local g=e:GetLabelObject()
	if not g:IsExists(s.retfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	end
	return eg:IsContains(c)
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(s.retfilter,nil,e:GetLabel())
	g:DeleteGroup()
	local tc=sg:GetFirst()
	while tc do
		Duel.ReturnToField(tc)
		tc=sg:GetNext()
	end
	e:Reset()
end
function s.desfilter(c)
	return c:IsSetCard(0x10b)
end
function s.filter2(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.desfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_DECK)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,s.desfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		if Duel.Destroy(g,REASON_EFFECT)>0 then
			c:SetCardTarget(g:GetFirst())
			if not e:GetLabelObject() then
				--leavefield
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
				e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e3:SetCode(EVENT_LEAVE_FIELD_P)
				e3:SetOperation(s.checkop)
				c:RegisterEffect(e3)
				local e4=Effect.CreateEffect(c)
				e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
				e4:SetCode(EVENT_LEAVE_FIELD)
				e4:SetOperation(s.thop)
				e4:SetLabelObject(e3)
				c:RegisterEffect(e4)
				--
				e:SetLabelObject(e3)
			end
		end
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsDisabled() then
		e:SetLabel(1)
	else e:SetLabel(0) end
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject():GetLabel()~=0 then return end
	local tc=e:GetHandler():GetFirstCardTarget()
	if tc and tc:IsLocation(LOCATION_GRAVE) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
