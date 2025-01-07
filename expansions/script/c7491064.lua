--征服斗魂 GS欧希尔
local s,id,o=GetID()
function s.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--show dark for rtohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetLabel(1)
	e2:SetHintTiming(TIMING_END_PHASE,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCost(s.rthcost)
	e2:SetTarget(s.rthtg)
	e2:SetOperation(s.rthop)
	c:RegisterEffect(e2)
	--show dark and dark for activate
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(0)
	e3:SetLabel(2)
	e3:SetTarget(s.acttg)
	e3:SetOperation(s.actop)
	c:RegisterEffect(e3)
	--adjust
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e01:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e01:SetCode(EVENT_ADJUST)
	e01:SetRange(0xff)
	e01:SetOperation(s.adjustop)
	c:RegisterEffect(e01)
	--
	--[[if not s.globle_check then
		s.globle_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_ACTIVATE_COST)
		ge1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetCost(s.costchk)
		ge1:SetTargetRange(1,0)
		ge1:SetTarget(s.actarget)
		ge1:SetOperation(s.costop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		Duel.RegisterEffect(ge2,1)
		local g=Duel.GetMatchingGroup(s.actfilter,0,0xff,0xff,nil)
		for tc in aux.Next(g) do
			local te=tc:GetActivateEffect()
			if te:IsHasType(EFFECT_TYPE_ACTIVATE) and te:GetCode()==EVENT_FREE_CHAIN then
				local ge2=te:Clone()
				local con=ge2:GetCondition()
				local property=ge2:GetProperty()
				--ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
				ge2:SetCode(EVENT_CUSTOM+id)
				ge2:SetRange(LOCATION_DECK+LOCATION_GRAVE)
				if property then
					ge2:SetProperty(property|EFFECT_FLAG_DELAY)
				else
					ge2:SetProperty(EFFECT_FLAG_DELAY)
				end
				ge2:SetCondition(function (e,tp,eg,ep,ev,re,r,rp)
					return rp==tp and (not con or con(e,tp,eg,ep,ev,re,r,rp))
				end)
				tc:RegisterEffect(ge2)
			end
		end
	end]]
end
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	--
	if not s.globle_check then
		s.globle_check=true
		local c=e:GetHandler()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_ACTIVATE_COST)
		ge1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetCost(s.costchk)
		ge1:SetTargetRange(1,0)
		ge1:SetTarget(s.actarget)
		ge1:SetOperation(s.costop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		Duel.RegisterEffect(ge2,1)
		local g=Duel.GetMatchingGroup(s.actfilter,0,0xff,0xff,nil)
		for tc in aux.Next(g) do
			local te=tc:GetActivateEffect()
			if te:IsHasType(EFFECT_TYPE_ACTIVATE) and te:GetCode()==EVENT_FREE_CHAIN then
				local ge2=te:Clone()
				local con=ge2:GetCondition()
				local property=ge2:GetProperty()
				--ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
				ge2:SetCode(EVENT_CUSTOM+id)
				ge2:SetRange(LOCATION_DECK+LOCATION_GRAVE)
				if property then
					ge2:SetProperty(property|EFFECT_FLAG_DELAY)
				else
					ge2:SetProperty(EFFECT_FLAG_DELAY)
				end
				ge2:SetCondition(function (e,tp,eg,ep,ev,re,r,rp)
					return rp==tp and (not con or con(e,tp,eg,ep,ev,re,r,rp))
				end)
				tc:RegisterEffect(ge2)
			end
		end
	end
	e:Reset()
end
function s.spcfilter1(c)
	return c:GetSequence()<5
end
function s.spcfilter2(c)
	return c:GetSequence()<5 and c:IsSetCard(0x195) and c:IsFaceup()
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=1-tp then return false end
	local ct1=Duel.GetMatchingGroupCount(s.spcfilter1,tp,LOCATION_MZONE,0,nil)
	local ct2=Duel.GetMatchingGroupCount(s.spcfilter2,tp,LOCATION_MZONE,0,nil)
	return ct1==0 or ct1==ct2
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetFlagEffect(tp,id)==0 end
	Duel.RegisterFlagEffect(tp,id,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.rthfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and not c:IsPublic()
end
function s.rthcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	if chk==0 then return Duel.IsExistingMatchingCard(s.rthfilter,tp,LOCATION_HAND,0,ct,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.rthfilter,tp,LOCATION_HAND,0,ct,ct,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.RaiseEvent(g,EVENT_CUSTOM+9091064,e,REASON_COST,tp,tp,0)
	Duel.ShuffleHand(tp)
end
function s.thfilter(c,e,tp,ft)
	return c:IsFaceup() and c:IsAbleToHand() and (ft>0 or c:GetSequence()<5)
		and Duel.IsExistingMatchingCard(s.spfilter2,tp,LOCATION_HAND,0,1,nil,e,tp)
end
function s.spfilter2(c,e,tp)
	return c:IsSetCard(0x195) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.rthtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_MZONE,0,1,nil,e,tp,ft)
		and Duel.GetFlagEffect(tp,id)==0 end
	Duel.RegisterFlagEffect(tp,id,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.rthop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp,ft)
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,s.spfilter2,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if sg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function s.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 end
	Duel.RegisterFlagEffect(tp,id,RESET_CHAIN,0,1)
end
function s.actop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+id,e,REASON_EFFECT,tp,tp,0)
end

----------------------------------Activate--------------------------------------

function s.actfilter(c)
	return c:IsSetCard(0x195) and (c:IsType(TYPE_QUICKPLAY) or c:IsType(TYPE_TRAP)) and not c:IsForbidden()
end
function s.costchk(e,te,tp)
	local tc=te:GetHandler()
	return Duel.GetFlagEffect(tp,id+2)==0 and (tc:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
end
function s.actarget(e,te,tp)
	local tc=te:GetHandler()
	e:SetLabelObject(tc)
	return te:IsHasType(EFFECT_TYPE_ACTIVATE) and (tc:IsLocation(LOCATION_DECK) or tc:IsLocation(LOCATION_GRAVE)) and tc:IsSetCard(0x195)
end
function s.costop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.RegisterFlagEffect(tp,id+2,RESET_PHASE+PHASE_END,0,1)
	if tc:IsType(TYPE_FIELD) then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	else
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
