--地 狱 恶 魔 的 终 点 之 路
local m=43999014
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddRitualProcGreater2(c,c43999014.filter,LOCATION_REMOVED+LOCATION_HAND,c43999014.mfilter)
	--apply effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(43999014,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,43999014)
	e2:SetCondition(c43999014.effcon)
	e2:SetTarget(c43999014.efftg)
	e2:SetOperation(c43999014.effop)
	c:RegisterEffect(e2)
	c43999014.SetCard_diyuemo=true
end
function c43999014.filter(c)
	return c:IsCode(43999015)
end
function c43999014.mfilter(c)
	return c:IsSetCard(0x45)
end
function c43999014.effcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler().SetCard_diyuemo
end
function c43999014.efffilter(c,e,tp,eg,ep,ev,re,r,rp)
	if not (c.SetCard_diyuemo and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove())
	then return false end
	local te=c.onfield_effect
	if not te then return false end
	local tg=te:GetTarget()
	return not tg or tg and tg(e,tp,eg,ep,ev,re,r,rp,0)
end
function c43999014.efftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	if chk==0 then return (not (g:GetCount()==1 and g:GetFirst():IsCode(22348136)) and
	Duel.IsExistingMatchingCard(c43999014.efffilter,tp,LOCATION_DECK+LOCATION_MZONE,0,1,nil,e,tp,eg,ep,ev,re,r,rp))
	or((g:GetCount()==1 and g:GetFirst():IsCode(22348136)) and
	Duel.IsExistingMatchingCard(c43999014.efffilter,tp,LOCATION_DECK+LOCATION_MZONE,0,1,g,e,tp,eg,ep,ev,re,r,rp))
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK+LOCATION_MZONE)
end
function c43999014.effop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	if g:GetCount()==1 and g:GetFirst():IsCode(22348136) then
	local tg=Duel.SelectMatchingCard(tp,c43999014.efffilter,tp,LOCATION_DECK+LOCATION_MZONE,0,1,1,g,e,tp)
	local tc=tg:GetFirst()
	local te=tc.onfield_effect
	local op=te:GetOperation()
	if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and op then op(e,tp,eg,ep,ev,re,r,rp) end
	else
	local tg=Duel.SelectMatchingCard(tp,c43999014.efffilter,tp,LOCATION_DECK+LOCATION_MZONE,0,1,1,nil,e,tp)
	local tc=tg:GetFirst()
	local te=tc.onfield_effect
	local op=te:GetOperation()
	if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end

