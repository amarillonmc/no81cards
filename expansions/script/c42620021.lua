--海晶少女的气泡冲击
local m=42620021
local cm=_G["c"..m]

function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.con)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	--destory
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_CUSTOM+42620021)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(cm.destg)
	e2:SetOperation(cm.desop)
	c:RegisterEffect(e2)
	--lpcheck
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(cm.lpcheck)
	c:RegisterEffect(e3)
end

function cm.confilter(c)
	return c:IsType(TYPE_LINK+TYPE_MONSTER) and c:IsLinkAbove(3)
end

function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.confilter,tp,0,LOCATION_ONFIELD,1,nil)
end

function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_ATTACK)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

function cm.tgfilter(c)
	local zone=c:GetLinkedZone()
	return c:IsFaceup() and c:IsSetCard(0x12b) and c:IsType(TYPE_LINK+TYPE_MONSTER) and c:IsLinkBelow(2) and zone~=0
end

function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.tgfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
end

function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetCategory(CATEGORY_DAMAGE)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
		e1:SetRange(LOCATION_SZONE)
		e1:SetLabelObject(tc)
		e1:SetCondition(cm.damagecon)
		e1:SetTarget(cm.damagetg)
		e1:SetOperation(cm.damageop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EVENT_SUMMON_SUCCESS)
		c:RegisterEffect(e2)
		c:SetCardTarget(tc)
	end
end

function cm.damagefilter(c,lg)
	return lg:IsContains(c) and c:IsSetCard(0x12b)
end

function cm.damagecon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local lg=tc:GetLinkedGroup()
	return eg:IsExists(cm.damagefilter,1,nil,lg)
end

function cm.damagetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tc=e:GetLabelObject()
	local lk=eg:GetFirst():GetLink()
	local damage=(tc:GetLink()+lk)*500
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(damage)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,damage)
end

function cm.damageop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end

function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end

function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_RULE)
	end
end

function cm.lpcheck(e,tp,eg,ep,ev,re,r,rp)
	if (Duel.GetCurrentPhase()==PHASE_END or (Duel.GetLP(1-tp)<=Duel.GetLP(tp)))
	and e:GetHandler():IsStatus(STATUS_EFFECT_ENABLED) then
		Duel.RaiseSingleEvent(e:GetHandler(),EVENT_CUSTOM+42620021,e,0,0,0,0)
	end
end