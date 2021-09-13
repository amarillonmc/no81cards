--情感的思索
local m=33502906
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,33502900)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.drtg)
	e1:SetOperation(cm.drop)
	c:RegisterEffect(e1)
	--act limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0,1)
	e3:SetCondition(cm.con)
	e3:SetValue(cm.aclimit)
	c:RegisterEffect(e3)	
end
function cm.tdfilter(c)
	return aux.IsCodeListed(c,33502900) and c:IsAbleToGrave() and c:IsFaceup()
end
function cm.thfilter(c)
	return aux.IsCodeListed(c,33502900) and c:IsAbleToHand()
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,tp,1)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tdfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	if Duel.SendtoGrave(g,REASON_EFFECT)~=0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.BreakEffect()
		local sg=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
		if #sg>0 then Duel.SendtoHand(sg,nil,REASON_EFFECT) end
	end
end

function cm.ccfilter(c)
	return c:IsFaceup() and c:IsCode(33502900)
end
function cm.con(e)
	return Duel.IsExistingMatchingCard(cm.ccfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function cm.aclimit(e,re,tp)
	return re:GetHandler():IsLocation(LOCATION_HAND) and re:GetHandler():IsType(TYPE_MONSTER)
end
