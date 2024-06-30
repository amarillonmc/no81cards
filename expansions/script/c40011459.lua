--回溯之时少女 乌璐璐
function c40011459.initial_effect(c)
	--replace
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_BE_BATTLE_TARGET) 
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)  
	e1:SetCountLimit(1,40011459)
	e1:SetCost(c40011459.ccost)
	e1:SetTarget(c40011459.cbtg)
	e1:SetOperation(c40011459.cbop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,40011459)
	e2:SetCost(c40011459.ccost)
	e2:SetCondition(c40011459.cecon) 
	e2:SetTarget(c40011459.cetg)
	e2:SetOperation(c40011459.ceop)
	c:RegisterEffect(e2) 
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetCondition(function(e) 
	return e:GetHandler():IsStatus(STATUS_SPSUMMON_TURN) end)
	e3:SetValue(function(e,te)
	if te:GetOwnerPlayer()==e:GetHandlerPlayer() then return false end
	if not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return g and g:IsContains(e:GetHandler()) end) 
	c:RegisterEffect(e3)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE) 
	e3:SetCondition(function(e) 
	return e:GetHandler():IsStatus(STATUS_SPSUMMON_TURN) end)
	e3:SetValue(1500)
	c:RegisterEffect(e3) 
	--remove 
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetOperation(c40011459.regop)
	c:RegisterEffect(e4)
end
function c40011459.ccost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(function(c) return c:IsSetCard(0xaf1a) and c:IsAbleToRemoveAsCost() end,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,e:GetHandler()) end 
	local g=Duel.SelectMatchingCard(tp,function(c) return c:IsSetCard(0xaf1a) and c:IsAbleToRemoveAsCost() end,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,e:GetHandler()) 
	Duel.Remove(g,POS_FACEUP,REASON_COST) 
end 
function c40011459.cbfilter(c,e)
	return c:IsCanBeEffectTarget(e)
end
function c40011459.cbtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local ag=Duel.GetAttacker():GetAttackableTarget()
	local at=Duel.GetAttackTarget()
	ag:RemoveCard(at)
	if chk==0 then return Duel.GetAttacker():IsControler(1-tp) and at:IsControler(tp) and at:IsSetCard(0xaf1a) and ag:IsContains(e:GetHandler()) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0) 
end
function c40011459.cbop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and not Duel.GetAttacker():IsImmuneToEffect(e) then
		Duel.ChangeAttackTarget(c) 
	end
end
function c40011459.cecon(e,tp,eg,ep,ev,re,r,rp)
	if e==re or rp~=1-tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or g:GetCount()~=1 then return false end
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
	return tc:IsLocation(LOCATION_MZONE) and tc:IsSetCard(0xaf1a)
end 
function c40011459.cetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckChainTarget(ev,e:GetHandler()) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0) 
end
function c40011459.ceop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.ChangeTargetCard(ev,Group.FromCards(c)) 
	end
end
function c40011459.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c40011459.rmtg)
	e1:SetOperation(c40011459.rmop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function c40011459.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() end 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0) 
end
function c40011459.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then 
		Duel.Remove(c,POS_FACEUP,REASON_EFFECT) 
	end 
end 






