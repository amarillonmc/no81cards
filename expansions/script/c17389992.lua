local s,id=GetID()
function s.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,id+1) 
	e2:SetOperation(s.regop)
	c:RegisterEffect(e2)
	
end

function s.desfilter1(c)
	return c:IsSetCard(0x5f51)
end

function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.IsExistingMatchingCard(s.desfilter1,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler()) 
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
end

function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectMatchingCard(tp,s.desfilter1,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
	if #g1>0 then
		local tc1=g1:GetFirst()
		local ty1=tc1:GetType()&(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
		if tc1:IsFacedown() or tc1:IsLocation(LOCATION_HAND) then 
			Duel.ConfirmCards(1-tp,tc1) 
		end		
		if Duel.Destroy(tc1,REASON_EFFECT)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g2=Duel.SelectMatchingCard(tp,function(c,ty)
				return c:IsSetCard(0x5f51) and not c:IsType(ty)
			end,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD,0,1,1,nil,ty1)			
			if #g2>0 then
				local tc2=g2:GetFirst()
				if tc2:IsFacedown() or tc2:IsLocation(LOCATION_HAND) then 
					Duel.ConfirmCards(1-tp,tc2) 
				end
				Duel.BreakEffect()
				Duel.Destroy(tc2,REASON_EFFECT)
			end
		end
	end
end

function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetOperation(s.delayed_des)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

function s.delayed_des(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	e:Reset() 
	local g=Duel.GetMatchingGroup(function(c)
		return c:IsSetCard(0x5f51) and not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,c:GetCode())
	end,tp,LOCATION_DECK,0,nil)	
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=g:Select(tp,1,1,nil)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end