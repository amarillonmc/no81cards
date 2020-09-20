--撒！细数你的罪恶把
function c9980773.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c9980773.damcon2)
	e1:SetTarget(c9980773.target)
	e1:SetOperation(c9980773.activate)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c9980773.damcon)
	e2:SetTarget(c9980773.damtg)
	e2:SetOperation(c9980773.damop)
	c:RegisterEffect(e2)
end
function c9980773.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x3bc2) 
end
function c9980773.damcon2(e,tp,eg,ep,ev,re,r,rp)
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(c9980773.filter,c:GetControler(),LOCATION_MZONE,0,1,nil) and Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD+LOCATION_HAND)>=7
end
function c9980773.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_ONFIELD+LOCATION_HAND,0)>0 end
	Duel.SetTargetPlayer(1-tp)
	local dam=Duel.GetFieldGroupCount(1-tp,LOCATION_ONFIELD+LOCATION_HAND,0)*300
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c9980773.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local dam=Duel.GetFieldGroupCount(1-tp,LOCATION_ONFIELD+LOCATION_HAND,0)*300
	Duel.Damage(p,dam,REASON_EFFECT)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980773,0))
end
function c9980773.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and c:IsReason(REASON_DESTROY)
		and c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetPreviousControler()==tp
end
function c9980773.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c9980773.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980773,0))
end
