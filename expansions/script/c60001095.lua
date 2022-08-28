--机凯伪典 终点天击
local m=60001095
local cm=_G["c"..m]

function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,160001095)
	e2:SetCost(cm.descost)
	e2:SetTarget(cm.destg)
	e2:SetOperation(cm.desop)
	c:RegisterEffect(e2)
end
cm.named_with_ExMachina=true
cm.named_with_WeiDian=true 
function cm.costrfilter(c)
	return c:IsAbleToGraveAsCost() and c.named_with_ExMachina and not c:IsCode(m)
end

function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costrfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.costrfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end

function cm.tgrfilter(c)
	return c:IsAbleToRemove() and c:IsType(TYPE_MONSTER) and c:IsAttackAbove(2000)
end

function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgrfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_MZONE)
end

function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.tgrfilter,tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end 
end

function cm.namedfilter(c)
	return c.named_with_ExMachina
end
function cm.mkfilter(c)
	return c.named_with_ExMachina and c:IsType(TYPE_LINK) and c:IsAttackAbove(2500)
end
function cm.ttkfilter(c)
	return c:IsCode(60000112)
end
function cm.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	Duel.ConfirmCards(1-tp,g)
	if not (Duel.IsExistingMatchingCard(cm.namedfilter,tp,LOCATION_DECK,0,1,nil)) or (Duel.IsExistingMatchingCard(cm.mkfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(cm.ttkfilter,tp,LOCATION_SZONE,0,1,nil)) then 
		e:SetLabel(1)
	end
end

function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetLabel()==1 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	end
end

function cm.opdfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCode(60000106) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end

function cm.opxyzfilter(c)
	return c:IsCanOverlay() and c.named_with_ExMachina
end

function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==1 and Duel.IsExistingMatchingCard(cm.opdfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.opdfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) and c:IsRelateToEffect(e) and
		Duel.IsExistingMatchingCard(cm.opxyzfilter,tp,LOCATION_GRAVE,0,1,nil) and c:IsCanOverlay() then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local gg=Duel.SelectMatchingCard(tp,cm.opxyzfilter,tp,LOCATION_GRAVE,0,1,1,c)
			if gg then 
				Duel.Overlay(tc,gg)
			end
			Duel.Overlay(tc,c)
		end
	end
end