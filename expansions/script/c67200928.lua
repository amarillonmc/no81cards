--众星修正者 雷獠
function c67200928.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200928,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_TOEXTRA)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,67200928)
	e1:SetCondition(c67200928.negcon)
	e1:SetTarget(c67200928.negtg)
	e1:SetOperation(c67200928.negop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200928,1))
	e2:SetCategory(CATEGORY_TOEXTRA)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_DECK)
	e2:SetCountLimit(1,67200928)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(c67200928.tetg)
	e2:SetOperation(c67200928.teop)
	c:RegisterEffect(e2)	
end
--
function c67200928.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c67200928.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,0,0)
end
function c67200928.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) then
		Duel.SendtoExtraP(e:GetHandler(),nil,REASON_EFFECT)
	end
end
--
function c67200928.filter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xa67a) and not c:IsCode(67200928)
end
function c67200928.tetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200928.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK)
end
function c67200928.teop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(67200928,2))
	local g=Duel.SelectMatchingCard(tp,c67200928.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoExtraP(g,nil,REASON_EFFECT)
	end
end
