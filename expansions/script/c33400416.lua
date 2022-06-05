--鸢一折纸 绝望
local m=33400416
local cm=_G["c"..m]
function cm.initial_effect(c)
	 --xyz summon
	aux.AddXyzProcedureLevelFree(c,cm.xyzfilter,nil,2,2)
	c:EnableReviveLimit()
 --tograve
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.tgcon)
	e1:SetCost(cm.tgcost)
	e1:SetTarget(cm.tgtg)
	e1:SetOperation(cm.tgop)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MINIATURE_GARDEN_GIRL)
	e2:SetValue(1)
	e2:SetTarget(function(e,c)
		return c:IsSetCard(0x341)
	end)
	c:RegisterEffect(e2)
--ritual material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EXTRA_RITUAL_MATERIAL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function cm.xyzfilter(c)
	return (c:IsLevel(4) and  c:IsSetCard(0x5342)) or (c:IsType(TYPE_RITUAL) and c:IsSetCard(0x341))
end

function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function cm.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=0
	if e:GetHandler():GetFlagEffect(33401301)>0 then ft=1 end
	if chk==0 then return  ((ft==1) or e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST))  end 
	if ft==0 then 
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	end
end
function cm.tgfilter(c)
	return c:IsSetCard(0x5342) and c:IsAbleToGrave()
end
function cm.thfilter(c)
	return c:IsCode(33401200) and c:IsAbleToHand()
end
function cm.dsfilter(c)
	return c:IsDiscardable() and c:IsType(TYPE_RITUAL)
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0  and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(cm.dsfilter,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
	local g1=Duel.SelectMatchingCard(tp,cm.dsfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g1,REASON_DISCARD+REASON_EFFECT)
	local tg=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil) 
	Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g2=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,0,1,1,nil)
		if g2:GetCount()>0 then
			Duel.Destroy(g2,REASON_EFFECT)
		end
	end
end