local m=53799211
local cm=_G["c"..m]
cm.name="淅沥沥最强小姐"
if not require and Duel.LoadScript then
    function require(str)
        local name=str
        for word in string.gmatch(str,"%w+") do
            name=word
        end
        Duel.LoadScript(name..".lua")
        return true
    end
end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,1,2,nil,nil,99)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.thcost)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ov=e:GetHandler():GetOverlayGroup():FilterCount(Card.IsAbleToRemove,nil)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil) and ov>0
	end
	local ct=Duel.DiscardHand(tp,Card.IsAbleToGraveAsCost,1,ov,REASON_COST)
	e:SetLabel(ct)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler():GetOverlayGroup(),ct,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local og=c:GetOverlayGroup()
	local ct=e:GetLabel()
	if c:IsRelateToEffect(e) and #og==ct then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=og:FilterSelect(tp,Card.IsAbleToRemove,ct,ct,nil)
		local rct=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		local xg=Duel.GetMatchingGroup(aux.NecroValleyFilter(function(c)return c:IsCode(53799083) and c:IsAbleToHand()end),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
		if rct>0 and #xg>=rct and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=xg:Select(tp,rct,rct,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			SNNM.SetPublicGroup(c,sg,RESET_EVENT+RESETS_STANDARD,0)
			for tc in aux.Next(sg) do
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetRange(LOCATION_HAND)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetCode(EFFECT_CANNOT_ACTIVATE)
				e1:SetTargetRange(1,0)
				e1:SetValue(function(e,re,tp)return not re:GetHandler():IsCode(53799083)end)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e2:SetRange(LOCATION_HAND)
				e2:SetCode(EVENT_ADJUST)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				e2:SetOperation(cm.rstop)
				e2:SetLabelObject(e1)
				tc:RegisterEffect(e2,true)
			end
		end
	end
end
function cm.rstop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsPublic() then
		e:GetLabelObject():Reset()
		e:Reset()
	end
end
