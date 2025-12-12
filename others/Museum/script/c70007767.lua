--神域天使 治愈之风
local m=70007767
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--tograve
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,m+1)
	e2:SetCondition(cm.thcon)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
end
	function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_SZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(cm.reccon)
	e1:SetOperation(cm.recop)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	Duel.RegisterEffect(e2,tp)
end
	function cm.cfilter(c,tp)
	return c:IsSummonPlayer(tp)
end
	function cm.actfilter(c)
	return c:IsCode(70007758)
end
	function cm.etfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1276)
end
	function cm.reccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,1-tp) and Duel.IsExistingMatchingCard(cm.etfilter,tp,LOCATION_MZONE,0,1,nil)
end
	function cm.recop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Recover(tp,300,REASON_EFFECT)
	if Duel.GetMatchingGroupCount(cm.actfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)>=1 then
	Duel.Damage(1-tp,300,REASON_EFFECT)
	end
end
	function cm.cfilter2(c,tp)
	return c:IsPreviousLocation(LOCATION_GRAVE) and c:IsPreviousControler(tp)
		and c:IsSetCard(0x1276)
end
	function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter2,1,nil,tp)
end
	function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
	function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end