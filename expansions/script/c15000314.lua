local m=15000314
local cm=_G["c"..m]
cm.name="须臾海的访客·赛农"
function cm.initial_effect(c)
	--cannot
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	cm.limiteffet_Synon=e1
	--cannot activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_HAND)
	e2:SetTargetRange(1,0)
	e2:SetCondition(cm.mcon)
	e2:SetValue(cm.ac2limit)
	c:RegisterEffect(e2)
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGrave() and c:GetFlagEffect(15000314)==0 end
	c:RegisterFlagEffect(15000314,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,c,1,tp,LOCATION_HAND)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsAbleToGrave() then return end
	Duel.SendtoGrave(c,REASON_EFFECT)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetTargetRange(1,0)
	e2:SetValue(cm.aclimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function cm.aclimit(e,re,tp)
	local c=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and c:IsLocation(LOCATION_MZONE)
end
function cm.mcon(e)
	return e:GetHandler():IsPublic() and e:GetHandler():IsLocation(LOCATION_HAND)
end
function cm.ac2limit(e,re,tp)
	local c=e:GetHandler()
	local tc=re:GetHandler()
	return not (tc:IsCode(15000314) and tc:IsLocation(LOCATION_HAND) and re:GetDescription()==aux.Stringid(m,1))
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and (Duel.GetFlagEffect(tp,15000314)==0 and Duel.GetFlagEffect(1-tp,15000314)==0) end
	Duel.RegisterFlagEffect(tp,15000314,RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
			e1:SetValue(1)
			c:RegisterEffect(e1)
			--send replace
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EFFECT_SEND_REPLACE)
			e2:SetRange(LOCATION_MZONE)
			e2:SetTarget(cm.rtg)
			e2:SetValue(cm.rval)
			e2:SetLabel(tp)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e2)
		end
	Duel.SpecialSummonComplete()
	end
end
function cm.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local p=e:GetLabel()
	if chk==0 then return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsAbleToHand() and re~=e end
	if c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsAbleToHand() then
		if Duel.SendtoHand(c,p,REASON_EFFECT+REASON_REDIRECT) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_PUBLIC)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1)
			c:RegisterFlagEffect(15000315,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0)) 
		end
		return true
	else return false end
end
function cm.rval(e,c)
	return false
end