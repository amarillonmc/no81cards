--能天使
function c9910621.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),3)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c9910621.spcon)
	e1:SetTarget(c9910621.sptg)
	e1:SetOperation(c9910621.spop)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c9910621.atkcon)
	e2:SetOperation(c9910621.atkop)
	c:RegisterEffect(e2)
end
function c9910621.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c9910621.spfilter(c,e,tp,mg)
	return c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and mg:IsContains(c)
end
function c9910621.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=e:GetHandler():GetMaterial()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9910621.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,mg) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c9910621.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=c:GetMaterial()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tg=Duel.GetMatchingGroup(c9910621.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp,mg)
	if ft>0 then
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		local g=nil
		if tg:GetCount()>ft then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			g=tg:Select(tp,ft,ft,nil)
		else
			g=tg
		end
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	if c:IsRelateToEffect(e) and c:GetFlagEffect(9910621)==0 then
		c:RegisterFlagEffect(9910622,RESET_PHASE+PHASE_END,0,1)
		local e10=Effect.CreateEffect(c)
		e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e10:SetCode(EVENT_BE_MATERIAL)
		e10:SetCondition(c9910621.regcon)
		e10:SetOperation(c9910621.regop)
		e10:SetReset(RESET_PHASE+PHASE_END)
		c:RegisterEffect(e10)
		local e11=Effect.CreateEffect(c)
		e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e11:SetCode(EVENT_SPSUMMON_SUCCESS)
		e11:SetOperation(c9910621.regop2)
		c:RegisterEffect(e11)
		local e12=e11:Clone()
		e12:SetCode(EVENT_MOVE)
		e12:SetCondition(c9910621.regcon2)
		c:RegisterEffect(e12)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetValue(c9910621.actlimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	else
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_ACTIVATE)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		e2:SetValue(c9910621.actlimit2)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function c9910621.regcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_LINK and e:GetHandler():GetFlagEffect(9910622)~=0
end
function c9910621.regop(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetHandler():GetReasonCard()
	rc:RegisterFlagEffect(9910621,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c9910621.regcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=c:IsLocation(LOCATION_MZONE) and c:IsPreviousLocation(LOCATION_REMOVED)
		and not c:IsReason(REASON_SPSUMMON)
	local b2=c:GetPreviousLocation()~=LOCATION_MZONE and c:IsReason(REASON_MATERIAL)
	return b1 or b2
end
function c9910621.regop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:ResetFlagEffect(9910622)
end
function c9910621.actlimit(e,re,rp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and rc:GetFlagEffect(9910621)==0
end
function c9910621.actlimit2(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
function c9910621.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:IsControler(tp) and at:IsType(TYPE_LINK)
end
function c9910621.atkop(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	local tg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	if tg:GetCount()>0 and at:IsFaceup() and at:IsRelateToBattle() then
		local sc=tg:GetFirst()
		while sc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(at:GetLink()*100)
			sc:RegisterEffect(e1)
			sc=tg:GetNext()
		end
		if Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>0
			and Duel.SelectYesNo(tp,aux.Stringid(9910621,0)) then
			local sg=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
			if sg:GetCount()>0 then
				Duel.BreakEffect()
				Duel.HintSelection(sg)
				Duel.Destroy(sg,REASON_EFFECT)
			end
		end
	end
end
