--义手忍具 雾鸦
local s,id,o= GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,id)
	aux.AddCodeList(c,31740001)	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_NO_TURN_RESET)
	e2:SetCountLimit(1)
	e2:SetCondition(s.discon)
	e2:SetTarget(s.distg)
	e2:SetOperation(s.disop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_HAND)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetCondition(s.discon2)
	e3:SetOperation(s.disop2)
	c:RegisterEffect(e3)
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsCode(31740001) or aux.IsCodeListed(re:GetHandler(),31740001)
end
function s.discon2(e,tp,eg,ep,ev,re,r,rp)
	return (re:GetHandler():IsCode(31740001) or aux.IsCodeListed(re:GetHandler(),31740001)) and e:GetHandler():IsPublic() and Duel.GetFlagEffect(tp,id)==0
end
function s.disop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
	local g=Group.CreateGroup()
	Duel.Hint(HINT_CARD,0,id)
		Duel.ChangeTargetCard(0,g)
		Duel.ChangeChainOperation(0,s.repop)	
		local c = e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,1))
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVING)
		e1:SetReset(RESET_CHAIN)
		e1:SetCondition(s.lfcon)
		e1:SetOperation(s.lfop)
		Duel.RegisterEffect(e1,tp)
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	end
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	
	local g=Group.CreateGroup()
		Duel.ChangeTargetCard(0,g)
		Duel.ChangeChainOperation(ev,s.repop)	
		local c = e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,1))
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVING)
		e1:SetReset(RESET_CHAIN)
		e1:SetCondition(s.lfcon)
		e1:SetOperation(s.lfop)
		Duel.RegisterEffect(e1,tp)
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
		local g = Duel.SelectMatchingCard(tp, s.skrfilter1, tp, LOCATION_MZONE, 0, 1, 1, nil)
	if g:GetCount() > 0 then
		local tc = g:GetFirst()
		Duel.Remove(tc, POS_FACEUP, REASON_EFFECT) 
	end
end
function s.lfcon(e,tp,eg,ep,ev,re,r,rp)
	 
	return re:GetHandlerPlayer()==1-tp and not Duel.IsExistingMatchingCard(s.skrfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function s.skrfilter(c)
	return c:IsCode(31740001) and c:IsFaceup()
end
function s.skrfilter1(c)
	return c:IsCode(31740001) and c:IsFaceup() and c:IsAbleToRemove()
end
function s.skrfilter2(c,e,tp)
	return c:IsCode(31740001) and c:IsFaceup() and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end
function s.lfop(e,tp,eg,ep,ev,re,r,rp)
		local g=Group.CreateGroup()
		Duel.ChangeTargetCard(0,g)
		
		Duel.ChangeChainOperation(0,s.repop2)	
end
function s.repop2(e,tp,eg,ep,ev,re,r,rp)
		local tc = Duel.SelectMatchingCard(1-tp, s.skrfilter2, 1-tp, LOCATION_REMOVED, 0, 1, 1, nil,e,1-tp):GetFirst()
	if tc  then
		Duel.SpecialSummon(tc, 0, 1-tp, 1-tp, false, false, POS_FACEUP) 
	end
end