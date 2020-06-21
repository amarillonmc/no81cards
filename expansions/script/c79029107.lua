--罗德岛·狙击干员-克洛斯
function c79029107.initial_effect(c)
	--to deck
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_F+EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_DECK)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetOperation(c79029107.operation)
	e1:SetCondition(c79029107.condition)
	c:RegisterEffect(e1) 
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(EVENT_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c79029107.spcon)
	e2:SetCost(c79029107.spcost)
	e2:SetTarget(c79029107.sptg)
	e2:SetOperation(c79029107.spop)
	c:RegisterEffect(e2)
	--Recover
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c79029107.condtion1)
	e3:SetTarget(c79029107.target1)
	e3:SetOperation(c79029107.operation1)
	c:RegisterEffect(e3)
	--Recover
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCondition(c79029107.condtion1)
	e3:SetTarget(c79029107.target1)
	e3:SetOperation(c79029107.operation1)
	c:RegisterEffect(e3)
end
function c79029107.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(79029107)==0
end
function c79029107.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetHandler(),1-tp,2,REASON_EFFECT)
	e:GetHandler():RegisterFlagEffect(79029107,RESET_PHASE+PHASE_END,0,9999)
end
function c79029107.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	return eg:IsContains(c)
end
function c79029107.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c79029107.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,1000)
end
function c79029107.spop(e,tp,eg,ep,ev,re,r,rp)
	 local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
	Duel.SendtoDeck(e:GetHandler(),tp,2,REASON_EFFECT)
end
function c79029107.condtion1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_DECK)
end
function c79029107.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function c79029107.operation1(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
	Duel.SendtoDeck(e:GetHandler(),1-tp,2,REASON_EFFECT)
end

