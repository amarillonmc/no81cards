--辉翼天骑 银枪之天马
function c76029037.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c76029037.mfilter,1,1)
	c:EnableReviveLimit()   
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(76029037,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,76029037)
	e1:SetCondition(c76029037.condition)
	e1:SetTarget(c76029037.settg)
	e1:SetOperation(c76029037.setop)
	c:RegisterEffect(e1)  
	--NegateActivation
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE) 
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,16029037) 
	e2:SetCondition(c76029037.negcon)  
	e2:SetCost(c76029037.negcost)
	e2:SetTarget(c76029037.negtg)
	e2:SetOperation(c76029037.negop)
	c:RegisterEffect(e2)
end
c76029037.named_with_Kazimierz=true 
function c76029037.mfilter(c)
	return c:IsLinkRace(RACE_BEASTWARRIOR+RACE_WINDBEAST) and c:IsLinkType(TYPE_SYNCHRO)
end
function c76029037.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c76029037.setfilter(c)
	return c.named_with_Kazimierz and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c76029037.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c76029037.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c76029037.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c76029037.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then 
	   local sc=g:GetFirst()
	   if sc and Duel.SSet(tp,sc)~=0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
			sc:RegisterEffect(e2)
		end
	end
end

function c76029037.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c76029037.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c76029037.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.nbcon(tp,re) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c76029037.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end



