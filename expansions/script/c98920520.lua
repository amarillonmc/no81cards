--时间魔道士
function c98920520.initial_effect(c)
	aux.AddMaterialCodeList(c,71625222)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.FilterBoolFunction(Card.IsCode,71625222),1,1)
	c:EnableReviveLimit()
--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920520,0))
	e1:SetCategory(CATEGORY_COIN+CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c98920520.descon)
	e1:SetTarget(c98920520.destg)
	e1:SetOperation(c98920520.desop)
	c:RegisterEffect(e1)
	--fusion check
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCondition(c98920520.matcon)
	e2:SetOperation(c98920520.matop)
	c:RegisterEffect(e2)
end
c98920520.toss_coin=true
function c98920520.matcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c98920520.matop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(98920520,RESET_EVENT+0xd6c0000,0,1)
end
function c98920520.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(98920520)>0
end
function c98920520.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c98920520.damfilter(c)
	if c:IsPreviousPosition(POS_FACEUP) then
		return math.max(c:GetTextAttack(),0)
	else
		return 0
	end
end
function c98920520.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	local g2=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil)
	if g1:GetCount()>0 and g2:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COIN)
		local coin=Duel.AnnounceCoin(tp)
		local res=Duel.TossCoin(tp,1)
		if coin~=res then
			Duel.Destroy(g1,REASON_EFFECT)
			local og1=Duel.GetOperatedGroup()
			local atk=math.ceil((og1:GetSum(c98920520.damfilter))/2)
			Duel.Damage(1-tp,atk,REASON_EFFECT)
		else
			Duel.SendtoHand(g2,nil,REASON_EFFECT)
			local og=Duel.GetOperatedGroup()
			local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_HAND+LOCATION_EXTRA)
			Duel.Damage(tp,ct*500,REASON_EFFECT)
		end
	end
end