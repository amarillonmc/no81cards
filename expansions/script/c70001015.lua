--闪赵云
local m=70001015
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),3)
	c:EnableReviveLimit()
	--Draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.dcon)
	e1:SetOperation(cm.dop)
	c:RegisterEffect(e1)
	--Attack Negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m+1)
	e2:SetCost(cm.cost)
	e2:SetCondition(cm.condition)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
	--leave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,3))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetOperation(cm.op)
	c:RegisterEffect(e3)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PHASE+PHASE_END)
		ge1:SetCountLimit(1,m+1)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
	function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(0,m,RESET_EVENT+RESETS_STANDARD,0,1)
end
	function cm.dcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(0,m)>0
end
	function cm.dop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(0,m)==1 then
	Duel.ResetFlagEffect(tp,m)
	Duel.Draw(e:GetOwnerPlayer(),1,REASON_EFFECT)
	Debug.Message("匹马行南北，何暇问死生！")
	else
	Duel.ResetFlagEffect(tp,m)
	Duel.Draw(e:GetOwnerPlayer(),2,REASON_EFFECT)
	Debug.Message("纵千万人，吾往矣！")
	end
end
	function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
	function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
	function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetAttacker()
	if chkc then return chkc==tg end
	if chk==0 then return tg:IsOnField() and tg:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(tg)
	local dam=tg:GetAttack()
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
	function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	Duel.NegateAttack()
	end
	if Duel.SelectYesNo(1-tp,aux.Stringid(m,1)) then
	Debug.Message("江山北望，熄天下烽火！")
	Duel.SetLP(1-tp,math.ceil(Duel.GetLP(1-tp)/2))
	else
	local c=e:GetHandler()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetTargetRange(1,0)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.negcon)
	e2:SetOperation(cm.negop)
	Duel.RegisterEffect(e2,tp)
	Debug.Message("龙吟震九州，翼展蔽日月！")
	end
end
	function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
	function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local rc=re:GetHandler()
	if Duel.NegateEffect(ev,true) and rc:IsRelateToEffect(re) then
		Duel.Destroy(rc,REASON_EFFECT)
	end
end
	function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("北伐！北伐…北伐……")
end