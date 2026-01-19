--半魔的精灵
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,17337402)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.descon)
	e1:SetCost(s.descost)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end

function s.princessfilter(c)
	return c:IsCode(17337402) and c:IsFaceup()
end

function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.princessfilter,tp,LOCATION_MZONE,0,1,nil)
end

function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() end
	Duel.ConfirmCards(1-tp,c)
	Duel.ShuffleHand(tp)
end

function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,LOCATION_ONFIELD)
end

function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end

function s.cfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsCode(17337402) and c:IsPreviousPosition(POS_FACEUP) and c:GetReasonPlayer()==1-tp
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	if c:IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		g:AddCard(c) 
	end
	local excg=Group.CreateGroup()
	if c:IsLocation(LOCATION_HAND) then
		excg:AddCard(c) 
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
		if c:IsLocation(LOCATION_MZONE) then
			g:RemoveCard(c)
		end
		if #g>0 then
			local dg=Duel.Destroy(g,REASON_EFFECT)
			if dg>0 then
				local og=Duel.GetOperatedGroup()
				local codes={}
				local tc=og:GetFirst()
				while tc do
					local code=tc:GetOriginalCodeRule()
					if not codes[code] then
						codes[code]=true
					end
					tc=og:GetNext()
				end

				for code,_ in pairs(codes) do
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_FIELD)
					e1:SetCode(EFFECT_DISABLE)
					e1:SetTargetRange(LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED)
					e1:SetTarget(s.distg)
					e1:SetLabel(code)
					e1:SetReset(RESET_PHASE+PHASE_END)
					Duel.RegisterEffect(e1,tp)
					
					local e2=Effect.CreateEffect(c)
					e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e2:SetCode(EVENT_CHAIN_SOLVING)
					e2:SetCondition(s.discon)
					e2:SetOperation(s.disop)
					e2:SetLabel(code)
					e2:SetReset(RESET_PHASE+PHASE_END)
					Duel.RegisterEffect(e2,tp)
				end
			end
		end
	end
end

function s.distg(e,c)
	return c:IsOriginalCodeRule(e:GetLabel())
end

function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsOriginalCodeRule(e:GetLabel())
end

function s.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end