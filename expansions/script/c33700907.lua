--断罪的天火
function c33700907.initial_effect(c)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c33700907.damtg)
	e1:SetOperation(c33700907.damop)
	c:RegisterEffect(e1)	
end
function c33700907.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)>0 end
	local g=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
	local ct=g:FilterCount(c33700907.cfilter,nil,g)
	Duel.SetTargetPlayer(1-tp)
	if ct==#g then
		Duel.SetTargetParam(ct*100)  
	else
		Duel.SetTargetParam(ct*50) 
	end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c33700907.cfilter(c,g)
	return not g:IsExists(Card.IsCode,1,c,c:GetCode())
end
function c33700907.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local g=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
	local ct=g:FilterCount(c33700907.cfilter,nil,g)
	local dam=0
	if ct==#g then
		dam=ct*100
	else
		dam=ct*50
	end
	Duel.Damage(p,dam,REASON_EFFECT)
end