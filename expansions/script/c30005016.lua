--森之妖精 SatirII
local m=30005016
local cm=_G["c"..m]
function cm.initial_effect(c)
c:EnableReviveLimit()
	 --link summon
	 aux.AddLinkProcedure(c,cm.matfilter,2,4)
  --cannot remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_REMOVE)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	c:RegisterEffect(e2)
  --destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(cm.desreptg)
	e1:SetValue(cm.desrepval)
	e1:SetOperation(cm.desrepop)
	c:RegisterEffect(e1)
--activate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetOperation(cm.regop)
	c:RegisterEffect(e3)
end
function cm.matfilter(c)
	return c:IsLinkType(TYPE_EFFECT)
end

function cm.repfilter(c,tp)
	return  c:IsLocation(LOCATION_ONFIELD)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function cm.desfilter(c,e,tp)
	return  c:IsLocation(LOCATION_GRAVE) and c:IsAbleToDeck()
end
function cm.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(cm.repfilter,1,nil,tp)
		and Duel.IsExistingMatchingCard(cm.desfilter,tp,LOCATION_GRAVE,0,3,nil,e,tp) end
	if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,cm.desfilter,tp,LOCATION_GRAVE,0,3,3,nil,e,tp)
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	end
	return false
end
function cm.desrepval(e,c)
	return cm.repfilter(c,e:GetHandlerPlayer())
end
function cm.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local tg=e:GetLabelObject() 
	Duel.SendtoDeck(tg,nil,2,REASON_EFFECT+REASON_REPLACE)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsPreviousLocation(LOCATION_ONFIELD) then
		local e1=Effect.CreateEffect(c)
		e1:SetCategory(CATEGORY_TOHAND)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetRange(LOCATION_GRAVE)
		e1:SetCountLimit(1,m)
		e1:SetCost(cm.thcost)
		e1:SetTarget(cm.acttg)
		e1:SetOperation(cm.actop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtraAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function cm.actfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.actfilter,tp,LOCATION_GRAVE,0,1,nil) end
end
function cm.actop(e,tp,eg,ep,ev,re,r,rp)
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.actfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.BreakEffect() 
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
end


