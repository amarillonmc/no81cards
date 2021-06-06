--鹰身女郎 绯红爆裂
--21.06.02
local m=11451571
local cm=_G["c"..m]
function cm.initial_effect(c)
	--ritual summon
	c:EnableReviveLimit()
	--change name
	aux.EnableChangeCode(c,76812113,LOCATION_MZONE+LOCATION_GRAVE)
	--ritual fun
	local e1=aux.AddRitualProcGreater(c,cm.spfilter,nil,nil,nil)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m-1)
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop(e1:GetOperation()))
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.descon)
	e2:SetTarget(cm.destg)
	e2:SetOperation(cm.desop)
	c:RegisterEffect(e2)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER)
end
function cm.spfilter(c,e,tp,chk)
	return c==e:GetHandler()
end
function cm.spop(_op)
	return function(e,tp,eg,ep,ev,re,r,rp)
				if not e:GetHandler():IsRelateToEffect(e) then return end
				_op(e,tp,eg,ep,ev,re,r,rp)
			end
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		local tc=g:GetFirst()
		if Duel.Destroy(tc,REASON_EFFECT)>0 then Duel.Damage(1-tp,math.floor(tc:GetBaseAttack()/2),REASON_EFFECT) end
	end
end