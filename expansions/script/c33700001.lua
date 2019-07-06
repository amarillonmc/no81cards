--上级Protoform 乞力马扎罗
function c33700001.initial_effect(c)
	--spsummon limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetCondition(c33700001.sumcon)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(aux.penlimit)
	c:RegisterEffect(e2)
	local g=Group.CreateGroup()
	g:KeepAlive()
	--adjust
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c33700001.adjustop)
	e3:SetLabelObject(g)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCondition(c33700001.imcon)
	e4:SetValue(c33700001.efilter)
	e4:SetLabelObject(g)
	c:RegisterEffect(e4)
	--tograve
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_LEAVE_FIELD_P)
	e5:SetOperation(c33700001.checkop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(9047460,0))
	e6:SetCategory(CATEGORY_HANDES+CATEGORY_DAMAGE)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetLabelObject(e5)
	e6:SetCondition(c33700001.descon)
	e6:SetTarget(c33700001.destg)
	e6:SetOperation(c33700001.desop)
	c:RegisterEffect(e6)
end
function c33700001.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		local preg=e:GetLabelObject()
	if g:GetCount()>0 then
		local ag=g:GetMaxGroup(Card.GetAttack)
		if ag:GetFirst():GetAttack()>e:GetHandler():GetAttack() then
		preg:Clear()
	else
		if  preg:GetCount()~=0 then return end
		preg:AddCard(e:GetHandler())
	end
	else
	if  preg:GetCount()~=0 then return end
		preg:AddCard(e:GetHandler())
	end
	Duel.AdjustInstantly(e:GetHandler())
end
function c33700001.checkop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsDisabled() then
		e:SetLabel(1)
	else e:SetLabel(0) end
end
function c33700001.sumcon(e)
	return not Duel.IsExistingMatchingCard(Card.IsSetCard,e:GetHandlerPlayer(),LOCATION_PZONE,0,1,nil,0x3440)
end
function c33700001.sfilter(c)
	return c:IsSetCard(0x3440) and c:IsFaceup()
end
function c33700001.atkfilter(c,atk)
	return c:IsFaceup() and c:GetAttack()>atk
end
function c33700001.imcon(e)
	return Duel.IsExistingMatchingCard(c33700001.sfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
	and e:GetLabelObject():IsContains(e:GetHandler())
end
function c33700001.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer() 
end
function c33700001.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:GetLocation()~=LOCATION_DECK
	and Duel.IsExistingMatchingCard(c33700001.sfilter,tp,LOCATION_ONFIELD,0,1,nil) 
	and  e:GetLabelObject():GetLabel()==0
end
function c33700001.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	local dam=Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)*1000
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c33700001.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if Duel.SendtoGrave(g,REASON_EFFECT)>0 then
		local og=Duel.GetOperatedGroup()
		local dam=og:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)*1000
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		Duel.Damage(p,dam,REASON_EFFECT)
	end
end