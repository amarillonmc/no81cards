--岑露妖
--21.06.19
local m=11451576
local cm=_G["c"..m]
function cm.initial_effect(c)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.con)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
function cm.cfilter(c,tp)
	return c:IsSummonPlayer(tp) and c:IsPreviousLocation(LOCATION_EXTRA)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,1-tp)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function cm.tgfilter(c,tp,g)
	return g:IsContains(c) and Duel.IsExistingMatchingCard(cm.tgfilter2,tp,LOCATION_EXTRA,0,1,nil,c)
end
function cm.tgfilter2(c,tc)
	for _,typ in pairs({TYPE_FUSION,TYPE_SYNCHRO,TYPE_XYZ,TYPE_LINK}) do
		if c:IsType(typ) and tc:IsType(typ) then return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() end
	end
	return false
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=eg:Filter(cm.cfilter,nil,1-tp)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.tgfilter(chkc,tp,g) end
	if chk==0 then return Duel.IsExistingTarget(cm.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp,g) end
	if #g==1 then
		Duel.SetTargetCard(g)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		Duel.SelectTarget(tp,cm.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp,g)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,cm.tgfilter2,tp,LOCATION_EXTRA,0,1,1,nil,tc)
		if #g>0 then Duel.SendtoGrave(g,REASON_EFFECT) end
	end
end