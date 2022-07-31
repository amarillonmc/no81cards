--键★高潮 潮鸣 || K.E.Y Climax - Maree Ruggenti
--Scripted by: XGlitchy30

local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--place orbs
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(s.descon)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
	--register destructions
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.chkfilter(c)
	if not c:IsReason(REASON_BATTLE+REASON_EFFECT) then return false end
	if c:IsPreviousLocation(LOCATION_ONFIELD) then
		return c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousTypeOnField()&TYPE_MONSTER>0 and c:IsPreviousSetCard(0x460) and c:GetPreviousAttributeOnField()&ATTRIBUTE_LIGHT>0
	else
		return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x460) and c:IsAttribute(ATTRIBUTE_LIGHT)
	end
end
function s.rpchk(c,tp)
	return c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==tp
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.chkfilter,nil)
	if #g<=0 then return end
	for p=tp,1-tp,1-2*tp do
		local ct1=g:FilterCount(Card.IsReason,nil,REASON_BATTLE)
		local ct2=g:FilterCount(s.rpchk,nil,p)
		if ct1+ct2>0 then
			if Duel.GetFlagEffect(p,id)<=0 then
				Duel.RegisterFlagEffect(p,id,RESET_PHASE+PHASE_END,0,1,0)
			end
			Duel.SetFlagEffectLabel(p,id,Duel.GetFlagEffectLabel(p,id)+ct1+ct2)
		end
	end
end

function s.condition(e,tp)
	return Duel.GetCurrentPhase()==PHASE_END and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and Duel.GetFlagEffect(1-tp,id)>0 and Duel.GetFlagEffectLabel(1-tp,id)>0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local exc=nil
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) and not e:GetHandler():IsType(TYPE_EQUIP+TYPE_FIELD+TYPE_CONTINUOUS) and not e:GetHandler():IsHasEffect(EFFECT_REMAIN_FIELD) then exc=e:GetHandler() end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,0,exc)
	local ct=Duel.GetFlagEffectLabel(1-tp,id)
	if chk==0 then
		if #g<=0 then return false end
		local total=0
		for tc in aux.Next(g) do
			for i=ct-total,1,-1 do
				if tc:IsCanAddCounter(0x1460,i) then
					total=total+i
					break
				end
			end
			if total==ct then
				return true
			end
		end
		return false	
	end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,g,ct,0,0x1460)
end
function s.counterchk(c)
	return c:IsCanAddCounter(0x1460,1)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0 then return end
	local c=e:GetHandler()
	local exc=nil
	if c:IsOnField() and c:IsFaceup() and e:IsHasType(EFFECT_TYPE_ACTIVATE) and not c:IsType(TYPE_EQUIP+TYPE_FIELD+TYPE_CONTINUOUS) and not c:IsHasEffect(EFFECT_REMAIN_FIELD) then exc=c end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,0,exc)
	if #g<=0 then return end
	local ct=Duel.GetFlagEffectLabel(1-tp,id)
	local total=0
	for tc in aux.Next(g) do
		for chk=ct-total,1,-1 do
			if tc:IsCanAddCounter(0x1460,chk) then
				total=total+chk
				break
			end
		end
		if total==ct then
			break
		end
	end
	if total~=ct then return end
	for i=1,ct do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
		local tc=g:FilterSelect(tp,s.counterchk,1,1,nil):GetFirst()
		if not tc then return end
		tc:AddCounter(0x1460,1)
	end
end

function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and c:IsReason(REASON_DESTROY) and rp~=tp and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEDOWN)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if #g>0 then
		Duel.SetOperationInfo(0,CATEGORY_COUNTER,g,#g,0,0x1460)
	end
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if #g<=0 then return end
	for tc in aux.Next(g) do
		if s.counterchk(tc) then
			tc:AddCounter(0x1460,1,REASON_EFFECT)
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e1:SetValue(s.matlimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		tc:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		tc:RegisterEffect(e3)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		tc:RegisterEffect(e4)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_UNRELEASABLE_SUM)
		e5:SetValue(1)
		e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		tc:RegisterEffect(e5)
		local e6=e5:Clone()
		e6:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		tc:RegisterEffect(e6)
	end
end
function s.matlimit(e,c)
	if not c then return false end
	return c:IsLocation(LOCATION_EXTRA)
end