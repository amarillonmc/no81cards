function c10111127.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Set Quick or Trap
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10111127,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,10111127)
	e1:SetCost(c10111127.cost)
	e1:SetTarget(c10111127.settg)
	e1:SetOperation(c10111127.setop)
	c:RegisterEffect(e1)
    	--destroy replace
	local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_REMOVE+CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c10111127.repcon)
	e2:SetCost(c10111127.cost1)
	e2:SetTarget(c10111127.xxtg1) 
	e2:SetOperation(c10111127.xxop1) 
	c:RegisterEffect(e2)
end
function c10111127.rmfilter(c)
	return c:IsFacedown() and c:IsAbleToRemoveAsCost(POS_FACEDOWN)
end
function c10111127.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local check=Duel.GetCustomActivityCount(10111127,tp,ACTIVITY_SPSUMMON)==0
	local g=Duel.GetMatchingGroup(c10111127.rmfilter,tp,LOCATION_EXTRA,0,nil)
	if chk==0 then return #g>=2 and check end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c10111127.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=g:Select(tp,2,2,nil)
	Duel.Remove(rg,POS_FACEDOWN,REASON_COST)
end
function c10111127.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_PENDULUM)
end
function c10111127.setfilter(c)
	return c:IsSetCard(0x191) and c:IsSSetable()
		and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(10111127)
end
function c10111127.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10111127.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c10111127.setop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft<=0 then return end
	if ft>=4 then ft=2 end
	local g=Duel.GetMatchingGroup(c10111127.setfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,ft)
		if sg:GetCount()>0 then
			Duel.SSet(tp,sg)
		end
	end
end
function c10111127.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c10111127.rmfilter,tp,LOCATION_EXTRA,0,nil)
	if chk==0 then return #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=g:Select(tp,1,1,nil)
	Duel.Remove(rg,POS_FACEDOWN,REASON_COST)
end
function c10111127.repcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep==1-tp and re:GetHandler():IsOnField() and re:GetHandler():IsRelateToEffect(re) and re:IsActiveType(TYPE_MONSTER)
		and Duel.IsExistingMatchingCard(aux.AND(Card.IsFaceup,Card.IsCode),tp,LOCATION_EXTRA,0,1,nil,70155677)
end
function c10111127.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c10111127.rmfilter,tp,LOCATION_EXTRA,0,nil)
	if chk==0 then return #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=g:Select(tp,1,1,nil)
	Duel.Remove(rg,POS_FACEDOWN,REASON_COST)
end
function c10111127.xxtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:GetAttack()>0 end,tp,0,LOCATION_MZONE,1,nil) end  
end 
function c10111127.xxop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	for i=1,6 do 
		local g=Duel.GetMatchingGroup(function(c) return c:IsFaceup() and c:GetAttack()>0 end,tp,0,LOCATION_MZONE,nil) 
		if g:GetCount()>0 then  
			local tc=g:RandomSelect(tp,1):GetFirst() 
			local pratk=tc:GetAttack()
			local e2=Effect.CreateEffect(c) 
			e2:SetType(EFFECT_TYPE_SINGLE) 
			e2:SetCode(EFFECT_UPDATE_ATTACK) 
			e2:SetRange(LOCATION_MZONE) 
			e2:SetValue(-300) 
			e2:SetReset(RESET_EVENT+RESETS_STANDARD) 
			tc:RegisterEffect(e2)  
			if pratk~=0 and tc:GetAttack()==0 then 
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e2:SetCode(EFFECT_DISABLE)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e2)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e2)
				Duel.AdjustInstantly()
				Duel.NegateRelatedChain(tc,RESET_TURN_SET)
				Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)   
			end  
		end 
	end 
end