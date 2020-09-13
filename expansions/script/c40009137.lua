--天罗水将 苏格拉底
function c40009137.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSynchroType,TYPE_SYNCHRO),aux.NonTuner(Card.IsSynchroType,TYPE_SYNCHRO),1)
	c:EnableReviveLimit()   
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009137,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c40009137.spcon)
	e1:SetOperation(c40009137.atkop)
	c:RegisterEffect(e1) 
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40009137,1))
	e2:SetRange(LOCATION_MZONE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCountLimit(1)
	e2:SetCondition(c40009137.condition)
	e2:SetTarget(c40009137.settg)
	e2:SetOperation(c40009137.setop)
	c:RegisterEffect(e2)  
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c40009137.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and (ph>PHASE_MAIN1 and ph<PHASE_MAIN2)
end
function c40009137.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(100)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c40009137.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetBattledCount(tp)>5 
end
function c40009137.filter(c)
	return c:IsSetCard(0x6f1d) and c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function c40009137.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40009137.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c40009137.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c40009137.filter,tp,LOCATION_DECK,0,1,3,nil)
	local g1=g:SelectSubGroup(tp,aux.dncheck,false,1,3)
	if g1:GetCount()>0 then
		Duel.SSet(tp,g1)
	end
end


