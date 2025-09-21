--守墓的斯芬克斯
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddLinkProcedure(c,s.mat,1,1)
	c:EnableReviveLimit()
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	--e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	--e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(s.spcon)
	e4:SetTarget(s.sptg)
	e4:SetOperation(s.spop)
	c:RegisterEffect(e4)
	Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,s.chainfilter)
end
function s.chainfilter(re,tp,cid)
	if (re:IsActiveType(TYPE_MONSTER) and re:GetHandler() and re:GetHandler():IsSetCard(0x2e)) then
		local rcode=re:GetHandler():GetCode()
		Duel.RegisterFlagEffect(tp,id+rcode,RESET_PHASE+PHASE_END,0,1)
		--[[Debug.Message("id+rcode")
		Debug.Message(id+rcode)]]
	end
	return not (re:IsActiveType(TYPE_MONSTER) and re:GetHandler() and re:GetHandler():IsSetCard(0x2e))
end
function s.mat(c)
	return c:IsLinkSetCard(0x2e) and not c:IsLinkType(TYPE_LINK)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function s.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local code=c:GetFlagEffectLabel(id)
	local boolean=true
	if code and code~=0 then
		--[[Debug.Message("id+code")
		Debug.Message(id+code)]]
		boolean=(Duel.GetFlagEffect(tp,id+code)>=1)
	end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND,0,1,nil,e,tp) and boolean end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.thfilter(c)
	return c:IsSetCard(0x2e) and c:IsAbleToHand()
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local hint=g:GetFirst():IsPublic()
		local sp=Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		local sg=Duel.GetOperatedGroup()
		if hint then
			Duel.ConfirmCards(1-tp,g)
		end
		if sp and #sg~=0 then
			local sc=sg:GetFirst()
			e:GetHandler():ResetFlagEffect(id)
			e:GetHandler():RegisterFlagEffect(id,RESET_PHASE+PHASE_END,0,1,sc:GetCode())
			local op=aux.SelectFromOptions(1-tp,{true,aux.Stringid(id,2)},{true,aux.Stringid(id,3)})
			if op==1 then
				if Duel.Release(sg,REASON_EFFECT)==0
					or not Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
					or not Duel.SelectYesNo(tp,aux.Stringid(id,4)) then return end
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
					local thg=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
					if thg:GetCount()>0 then
						Duel.BreakEffect()
						Duel.SendtoHand(thg,nil,REASON_EFFECT)
						Duel.ConfirmCards(1-tp,thg)
					end
			elseif Duel.ChangePosition(sg,POS_FACEUP_ATTACK)>0 then
				Duel.RaiseEvent(sc,EVENT_FLIP_SUMMON_SUCCESS,e,REASON_EFFECT,tp,0,0)
				Duel.RaiseSingleEvent(sc,EVENT_FLIP_SUMMON_SUCCESS,e,REASON_EFFECT,tp,0,0)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetDescription(aux.Stringid(id,6))
				e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e2:SetCode(EVENT_PHASE+PHASE_END)
				e2:SetRange(LOCATION_MZONE)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
				e2:SetCountLimit(1)
				e2:SetOperation(s.tgop)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				sc:RegisterEffect(e2)
			end
		end
	end
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Release(e:GetHandler(),REASON_EFFECT)
end
