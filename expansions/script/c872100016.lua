--别天津神·八意思兼
function c872100016.initial_effect(c)
	aux.AddFusionProcFunRep(c,c872100016.ffilter,5,true)
-----
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c872100016.efilter)
	c:RegisterEffect(e2)
----
-----
	 --copy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(872100016,0))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(TIMING_DAMAGE_STEP)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,872100016)
	e4:SetCost(c872100016.cost)
	e4:SetOperation(c872100016.operation)
	c:RegisterEffect(e4)
end
function c872100016.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0xba1) and (not sg or not sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode()))
end
----
function c872100016.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
-------
--------
function c872100016.cfilter2(c)
	return c:IsSetCard(0xba1) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c872100016.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(872100016)==0
		and Duel.IsExistingMatchingCard(c872100016.cfilter2,tp,LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c872100016.cfilter2,tp,LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_DECK,0,1,1,nil)
	e:SetLabel(g:GetFirst():GetOriginalCode())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:GetHandler():RegisterFlagEffect(872100016,RESET_PHASE+PHASE_DAMAGE,0,1)
end
function c872100016.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local code=e:GetLabel()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD,1)
	end
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(872100016,0))
end