--赤月礼赞·TERRIBLE SIGHT
local m=33701432
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Atk Change
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetTarget(cm.target)
	e1:SetValue(cm.value)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(cm.tglimit)
	c:RegisterEffect(e2)
	--must attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_MUST_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_MUST_ATTACK_MONSTER)
	e4:SetValue(cm.atklimit)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetCondition(cm.condition)
	e5:SetTarget(cm.target)
	e5:SetOperation(cm.activate)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE+CATEGORY_DAMAGE)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCountLimit(1)
	e6:SetCost(cm.damcost)
	e6:SetTarget(cm.damtg)
	e6:SetOperation(cm.damop)
	c:RegisterEffect(e6)
	
end
function cm.target(e,c)
	return c:IsSetCard(0x9449)
end
function cm.value(e,c)
	return c:GetBaseAttack()*2
end
function cm.tglimit(e,c)
	return c and c:IsSetCard(0x9449)
end
function cm.atlimit(e,c)
	return c:IsFaceup() and c:IsSetCard(0x9449) and not c:IsImmuneToEffect(e)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.filter(c)
	return c:IsSetCard(0x9449)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		local atk=0
		while tc do
			local tatk=tc:GetTextAttack()
			if tatk>0 then atk=atk+tatk end
			tc=g:GetNext()
		end
		local dam=Duel.Damage(tp,atk,REASON_EFFECT)
		if Duel.GetLP(tp)>0 and dam>0 then
			Duel.BreakEffect()
			Duel.Damage(1-tp,math.floor(dam/2),REASON_EFFECT)
		end
	end
end
function cm.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function cm.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,0)
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
	if #g>0 then
		local tc=g:GetFirst()
		Duel.HintSelection(tc)
		if Duel.Destroy(tc,REASON_EFFECT)>0 then
			local ct1=Duel.Damage(1-tp,tc:GetDefense(),REASON_EFFECT,true)
			local ct2=Duel.Damage(tp,tc:GetDefense(),REASON_EFFECT,true)
			Duel.RDComplete()
			if ct1>0 or ct2>0 then
				Duel.BreakEffect()
				Duel.Draw(1-tp,math.floor(ct1/1000),REASON_EFFECT)
				Duel.Draw(tp,math.floor(ct2/1000),REASON_EFFECT)
			end
		end
	end
end
