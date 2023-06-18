--恶梦启示录
local m=33330400
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1)
	e2:SetCost(cm.cost)
	e2:SetCondition(cm.con)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetCondition(cm.poscon)
	e3:SetTarget(cm.postg)
	e3:SetOperation(cm.posop)
	c:RegisterEffect(e3)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_MZONE,0,1,nil,e,tp,eg,ep,ev,re,r,rp)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local tc=Duel.SelectMatchingCard(tp,Card.IsFacedown,tp,LOCATION_MZONE,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp):GetFirst()
	Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE,true)
	e:SetLabelObject(tc)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=aux.ExceptThisCard(e)
	if not c then return end
	local tc=e:GetLabelObject()
	if not tc:IsSetCard(0x6552) then return end
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_SZONE)
	e1:SetValue(cm.val)
	e1:SetOwnerPlayer(tp)
	c:RegisterEffect(e1,true)
	local te=tc.flip_effect
	if not te then return end
	local tg=te:GetTarget()
	if tg and not tg(e,tp,eg,ep,ev,re,r,rp,0) then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(m,2)) then return end
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end	
end
function cm.val(e,re)
	return re:GetOwnerPlayer()~=e:GetOwnerPlayer()
end
function cm.poscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end
function cm.posfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6552)
end
function cm.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.posfilter,tp,LOCATION_MZONE,0,1,nil,e,tp,eg,ep,ev,re,r,rp)
	end
end
function cm.posop(e,tp)
	local g=Duel.GetMatchingGroup(cm.posfilter,tp,LOCATION_MZONE,0,nil)
	if #g>0 then
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
		local sg=Duel.GetMatchingGroup(cm.sfilter,tp,LOCATION_MZONE,0,nil)
		Duel.ShuffleSetCard(sg)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_OPPO)
		local ac=Duel.SelectMatchingCard(1-tp,nil,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
		Duel.ChangeAttackTarget(ac)
	end
end
function cm.sfilter(c)
	return c:IsFacedown() and c:GetSequence()<5
end
