--龙启之地的小道士
local m=23003005
local cm=_G["c"..m]
function cm.initial_effect(c)
	--send to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(cm.tgtg)
	e1:SetOperation(cm.tgop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(cm.indcon)
	e2:SetOperation(cm.indop)
	c:RegisterEffect(e2)
end
function cm.tgfilter(c)
	return c:IsSetCard(0x352) and c:IsAbleToGrave() and c:IsType(TYPE_NORMAL)
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end

function cm.indcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO and e:GetHandler():GetReasonCard():IsSetCard(0x352)
end
function cm.indop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(cm.target2)
	e1:SetOperation(cm.activate2)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
end
function cm.filter2(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsPreviousLocation(LOCATION_GRAVE) and c:IsSummonPlayer(1-tp)
		and c:IsAbleToRemove()
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(cm.filter2,1,nil,tp) end
	local g=eg:Filter(cm.filter2,nil,tp)
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function cm.filter3(c,e,tp)
	return c:IsFaceup() and c:IsPreviousLocation(LOCATION_GRAVE) and c:IsSummonPlayer(1-tp) and c:IsLocation(LOCATION_MZONE)
end
function cm.activate2(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.filter3,nil,e,tp)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT,LOCATION_REMOVED)
	end
end