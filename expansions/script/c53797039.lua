local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_PLANT),2)
	local e0=aux.AddThisCardInGraveAlreadyCheck(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(LOCATION_REMOVED)
	e1:SetTargetRange(0xfe,0xff)
	e1:SetTarget(s.rmtg)
	e1:SetCondition(s.rmcon)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PAY_LPCOST)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetLabelObject(e0)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_REMOVE)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:IsType(TYPE_MONSTER) then
			local p=tc:GetPreviousControler()
			local label=Duel.GetFlagEffectLabel(p,id)
			if not label then Duel.RegisterFlagEffect(p,id,RESET_PHASE+PHASE_END,0,1,tc:GetBaseAttack()+tc:GetBaseDefense()) else Duel.SetFlagEffectLabel(p,id,label+tc:GetBaseAttack()+tc:GetBaseDefense()) end
		end
	end
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local se=e:GetLabelObject():GetLabelObject()
	return ep==tp and ev>=2500 and (se==nil or e:GetHandler():GetReasonEffect()~=se)
end
function s.desfilter(c,dif)
	return c:IsAttackBelow(dif) and c:IsFaceup()
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(s.desfilter,tp,0,LOCATION_MZONE,1,nil,ev) end
	local g=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_MZONE,nil,ev)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local g=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_MZONE,nil,ev)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function s.rmtg(e,c)
	return c:GetOwner()~=e:GetHandlerPlayer() and not c:IsLocation(LOCATION_OVERLAY) and not c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function s.filter(c,tc)
	return tc:GetMutualLinkedGroup():IsContains(c) and c:IsFaceup() and c:IsType(TYPE_LINK) and c:IsRace(RACE_PLANT)
end
function s.rmcon(e)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_ONFIELD,0,nil,e:GetHandler())
	if #g==0 then return false end
	local _,atk=g:GetMinGroup(Card.GetAttack)
	local a=Duel.GetFlagEffectLabel(1-tp,id) or 0
	if a>=atk then Duel.RegisterFlagEffect(tp,id+500,RESET_PHASE+PHASE_END,0,1) end
	return Duel.GetFlagEffect(tp,id+500)==0
end
