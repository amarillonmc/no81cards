--顺序码语者
function c13131366.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_CYBERSE),2)
	c:EnableReviveLimit()	 
	--draw 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_DRAW) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCountLimit(1,13131366) 
	e1:SetTarget(c13131366.drtg) 
	e1:SetOperation(c13131366.drop)  
	c:RegisterEffect(e1) 
	--Negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13131366,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c13131366.negcon)
	e2:SetCost(c13131366.negcost)
	e2:SetTarget(c13131366.negtg)
	e2:SetOperation(c13131366.negop)
	c:RegisterEffect(e2)
	--Revive
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(13131366,1))
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1)
	e3:SetTarget(c13131366.sumtg)
	e3:SetOperation(c13131366.sumop)
	c:RegisterEffect(e3)
end
function c13131366.drtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local x=e:GetHandler():GetLinkedGroupCount() 
	if chk==0 then return x>0 and Duel.IsPlayerCanDraw(tp,x) end 
	Duel.SetTargetPlayer(tp) 
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,x) 
end 
function c13131366.drop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler() 
	local x=e:GetHandler():GetLinkedGroupCount() 
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	if x>0 then 
	Duel.Draw(p,x,REASON_EFFECT)
	end 
end	 
function c13131366.negcon(e,tp,eg,ep,ev,re,r,rp) 
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) or not Duel.IsChainNegatable(ev) then return false end  
	return re:IsActiveType(TYPE_MONSTER) and e:GetHandler():GetSequence()>4  
end
function c13131366.negcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsReleasable() end 
	Duel.Release(e:GetHandler(),REASON_COST) 
end
function c13131366.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c13131366.negop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
	c:RegisterFlagEffect(13131366,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
end
function c13131366.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:GetFlagEffect(13131366)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c13131366.sumop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end






