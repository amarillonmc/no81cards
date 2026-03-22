local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
	
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(s.regcon)
	e3:SetOperation(s.regop)
	c:RegisterEffect(e3)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end

function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		local code = tc:GetCode()
		Duel.RegisterFlagEffect(0,code+1,RESET_PHASE+PHASE_END,0,1)
		Duel.RegisterFlagEffect(1,code+1,RESET_PHASE+PHASE_END,0,1)
	end
end

function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil,0x5f51)
		and Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,2,0,0)
end

function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,0x5f51)
	if #g1>0 then
		local tc1=g1:GetFirst()
		if tc1:IsFacedown() or tc1:IsLocation(LOCATION_HAND) then Duel.ConfirmCards(1-tp,tc1) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g2=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,tc1)
		if #g2>0 then
			g1:Merge(g2)
			Duel.Destroy(g1,REASON_EFFECT)
		end
	end
end
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,id+1)==0
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,id+1,RESET_PHASE+PHASE_END,0,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetOperation(s.delayed_sp_op)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.delayed_sp_op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(function(c,tp)
		return c:IsSetCard(0x5f51) and Duel.GetFlagEffect(tp,c:GetCode()+1)>0
	end,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil,tp)
	local tc=Duel.GetFirstMatchingCard(aux.NecroValleyFilter(function(c,e,tp)
		return c:IsCode(id) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
	end),tp,LOCATION_GRAVE,0,nil,e,tp)
	if #g>0 and tc and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_CARD,0,id)
		e:Reset() 		
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=g:Select(tp,1,1,nil)
		if #sg>0 then
			local sc=sg:GetFirst()
			if sc:IsFacedown() or sc:IsLocation(LOCATION_HAND) then Duel.ConfirmCards(1-tp,sc) end
			if Duel.Destroy(sg,REASON_EFFECT)>0 then
				Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
				tc:CompleteProcedure()
			end
		end
	end
end	