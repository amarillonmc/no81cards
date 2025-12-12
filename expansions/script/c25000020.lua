--飞电龙-程式升煌
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddXyzProcedureLevelFree(c,s.mfilter,s.xyzcheck,3,3)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.sdcon)
	e1:SetTarget(s.sdtg)
	e1:SetOperation(s.sdop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CUSTOM+id)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+o*10000)
	e2:SetCost(s.mtcost)
	e2:SetTarget(s.mttg)
	e2:SetOperation(s.mtop)
	c:RegisterEffect(e2)
	if not aux.Remove_Remove_Overlay_check then
		aux.Remove_Remove_Overlay_check=true
		Remove_Overlay=Duel.Overlay
		function Duel.Overlay(card,group)
			Remove_Overlay(card,group)
			Duel.RaiseEvent(card,EVENT_CUSTOM+id,e,0,0,0,group:GetCount())
		end
	end
end
function s.mfilter(c,xyzc)
	return c:IsLevelAbove(1) and c:IsAttribute(ATTRIBUTE_WIND)
end
function s.xyzcheck(g)
	return g:GetClassCount(Card.GetLevel)==1
end
function s.sdcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetCurrentChain()>0
end
function s.sdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>Duel.GetCurrentChain() end
end
function s.sdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local at=Duel.GetCurrentChain()
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
	if at<=ct then
		Duel.ConfirmDecktop(1-tp,at)
		local g=Duel.GetDecktopGroup(1-tp,at)
		if not c:IsRelateToEffect(e) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		Duel.PreserveSelectDeckSequence(true)
		local sg=g:FilterSelect(tp,Card.IsCanOverlay,1,1,nil,tp)
		Duel.PreserveSelectDeckSequence(false)
		if #sg>0 then
			Duel.DisableShuffleCheck(true)
			Duel.Overlay(c,sg)
		end
	end
end
function s.mtcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	local ol=e:GetHandler():RemoveOverlayCard(tp,1,ev,REASON_COST)
	e:SetLabel(ol)
end
function s.mtfilter(c,e)
	return c:IsCanOverlay() and not (e and c:IsImmuneToEffect(e))
end
function s.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(s.mtfilter,tp,0,LOCATION_ONFIELD,1,nil) end
end
function s.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ol=e:GetLabel()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,s.mtfilter,tp,0,LOCATION_ONFIELD,ol,ol,nil,e)
	if g:GetCount()>0 then
		local mg=g:GetFirst():GetOverlayGroup()
		if mg:GetCount()>0 then
			Duel.SendtoGrave(mg,REASON_RULE)
		end
		Duel.Overlay(c,g)
	end
end