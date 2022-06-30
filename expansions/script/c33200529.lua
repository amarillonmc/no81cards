--逆转检事 狩魔豪
function c33200529.initial_effect(c)
	aux.AddCodeList(c,33200500)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,6,2)
	--destory
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c33200529.descon)
	e1:SetOperation(c33200529.desop)
	c:RegisterEffect(e1) 
	--change effect type
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c33200529.cost)
	e2:SetCondition(c33200529.tzcon)
	e2:SetOperation(c33200529.tzop)
	c:RegisterEffect(e2)
end

--e1
function c33200529.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()==0
end
function c33200529.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2000)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,2000)
end
function c33200529.desop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsOnField() and Duel.Destroy(e:GetHandler(),REASON_EFFECT) then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Damage(p,d,REASON_EFFECT)
	end
end

--e2
function c33200529.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c33200529.tzcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():GetFlagEffect(33200599)>0 and re:IsActiveType(TYPE_MONSTER) and rp==tp
end
function c33200529.tzop(e,tp,eg,ep,ev,re,r,rp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(33200505)
	e2:SetTargetRange(1,0)
	e2:SetReset(RESET_EVENT+RESET_CHAIN)
	Duel.RegisterEffect(e2,tp)
end
