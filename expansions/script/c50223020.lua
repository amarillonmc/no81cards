--真红眼究极龙
function c50223020.initial_effect(c)
	--fusion material
	aux.AddFusionProcCodeRep(c,74677422,3,true,true)
	c:EnableReviveLimit()
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(50223020,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,50223020)
	e2:SetCondition(c50223020.con2)
	e2:SetCost(c50223020.cost)
	e2:SetTarget(c50223020.tg2)
	e2:SetOperation(c50223020.op2)
	c:RegisterEffect(e2)
	--monster to deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(50223020,1))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,50223021)
	e3:SetCost(c50223020.cost)
	e3:SetTarget(c50223020.tg3)
	e3:SetOperation(c50223020.op3)
	c:RegisterEffect(e3)
	--search to deck
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(50223020,2))
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_HAND)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,50223022)
	e4:SetCondition(c50223020.con4)
	e4:SetCost(c50223020.cost)
	e4:SetTarget(c50223020.tg4)
	e4:SetOperation(c50223020.op4)
	c:RegisterEffect(e4)
end
c50223020.material_setcode=0x3b
function c50223020.costf(c)
	return c:IsSetCard(0x3b) and c:IsAbleToGraveAsCost()
end
function c50223020.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c50223020.costf,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c50223020.costf,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c50223020.con2(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainNegatable(ev)
end
function c50223020.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
	end
end
function c50223020.op2(e,tp,eg,ep,ev,re,r,rp)
	local ec=re:GetHandler()
	if Duel.NegateActivation(ev) and ec:IsRelateToEffect(re) then
		ec:CancelToGrave()
		if Duel.SendtoDeck(ec,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 then
			Duel.Damage(1-tp,800,REASON_EFFECT)
		end
	end
end
function c50223020.tg3f(c,e,tp)
	return c:IsSummonPlayer(1-tp) and c:IsLocation(LOCATION_MZONE) and c:IsAbleToRemove()
		and (not e or c:IsRelateToEffect(e))
end
function c50223020.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c50223020.tg3f,1,nil,nil,tp) end
	local g=eg:Filter(c50223020.tg3f,nil,nil,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
end
function c50223020.op3(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c50223020.tg3f,nil,e,tp)
	if g:GetCount()>0 then
		if Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 then
			Duel.Damage(1-tp,800,REASON_EFFECT)
		end
	end
end
function c50223020.con4(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DRAW
end
function c50223020.tg4f(c,tp)
	return c:IsControler(1-tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c50223020.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c50223020.tg4f,nil,tp)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
end
function c50223020.op4(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c50223020.tg4f,nil,tp)
	if g:GetCount()>0 then
		Duel.ConfirmCards(tp,g)
		if Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 then
			Duel.Damage(1-tp,800,REASON_EFFECT)
		end
	end
end