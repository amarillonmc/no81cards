--虫融姬战国·二足骏义
function c10105901.initial_effect(c)
	--SpecialSummon
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetRange(LOCATION_DECK) 
	e1:SetCondition(c10105901.dspcon) 
	e1:SetOperation(c10105901.dspop) 
	c:RegisterEffect(e1) 
	--set
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,10105901) 
	e2:SetCost(c10105901.setcost)
	e2:SetTarget(c10105901.settg)
	e2:SetOperation(c10105901.setop)
	c:RegisterEffect(e2) 
	--race 
	local e3=Effect.CreateEffect(c) 
	e3:SetType(EFFECT_TYPE_SINGLE) 
	e3:SetCode(EFFECT_ADD_RACE)   
	e3:SetValue(RACE_BEASTWARRIOR) 
	e3:SetCondition(function(e) 
	return e:GetHandler():IsLocation(LOCATION_MZONE) end)
	c:RegisterEffect(e3) 
	--negate
	local e4=Effect.CreateEffect(c) 
	e4:SetCategory(CATEGORY_NEGATE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,20105901)
	e4:SetCondition(c10105901.discon)
	e4:SetCost(c10105901.discost)
	e4:SetTarget(c10105901.distg)
	e4:SetOperation(c10105901.disop)
	c:RegisterEffect(e4)
end
function c10105901.dsck(c) 
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and c:IsSetCard(0x8cdd)   
end 
function c10105901.dspcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10105901.dsck,1,nil) and Duel.GetFlagEffect(tp,10105901)==0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0   
end 
function c10105901.dspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,10105901)==0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectEffectYesNo(tp,c,aux.Stringid(10105901,0)) then 
		Duel.RegisterFlagEffect(tp,10105901,RESET_PHASE+PHASE_END,0,1)
		Duel.Hint(HINT_CARD,0,10105901)
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end 
end
function c10105901.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end 
function c10105901.stfilter(c,tp)
	return c:IsCode(10105900) and c:IsType(TYPE_FIELD) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c10105901.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10105901.stfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
end
function c10105901.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c10105901.stfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	end
end
function c10105901.fckfil(c) 
	return c:IsFaceup() and c:IsSetCard(0x8cdd) and c:IsType(TYPE_FUSION) 
end 
function c10105901.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev) and Duel.IsExistingMatchingCard(c10105901.fckfil,tp,LOCATION_MZONE,0,1,nil)
end
function c10105901.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST) 
end
function c10105901.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c10105901.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end


