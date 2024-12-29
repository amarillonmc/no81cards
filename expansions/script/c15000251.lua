local m=15000251
local cm=_G["c"..m]
cm.name="永寂的访客：刻勒尔"
function cm.initial_effect(c)
	--search  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)  
	e1:SetCode(EVENT_SUMMON_SUCCESS)  
	e1:SetCountLimit(1,15000251)  
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(cm.thtg)  
	e1:SetOperation(cm.thop)  
	c:RegisterEffect(e1)  
	local e2=e1:Clone()  
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)  
	c:RegisterEffect(e2)
	--link summon  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,1))  
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e3:SetType(EFFECT_TYPE_IGNITION)  
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_HAND+LOCATION_MZONE)  
	e3:SetCountLimit(1,15000256)
	e3:SetCost(cm.cost)   
	e3:SetTarget(cm.target)  
	e3:SetOperation(cm.operation)  
	c:RegisterEffect(e3)
end
function cm.thfilter(c)  
	return c:IsSetCard(0xaf37) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(m)  
end  
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end  
function cm.thop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end  
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)  
end
function cm.targetfilter(c,e)
	return c:IsFaceup() and c:IsCanBeEffectTarget(e)
end
function cm.fselect(g,tp)
	return Duel.IsExistingMatchingCard(cm.lkfilter,tp,LOCATION_EXTRA,0,1,nil,g) and g:IsExists(Card.IsControler,1,nil,tp) and g:IsExists(Card.IsControler,1,nil,1-tp)
end
function cm.lkfilter(c,g)
	return c:IsSetCard(0xaf37) and c:IsLinkSummonable(g,nil,g:GetCount(),g:GetCount())
end
function cm.chkfilter(c,tp)
	return c:IsType(TYPE_LINK) and c:IsSetCard(0xaf37) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then
		local cg=Duel.GetMatchingGroup(cm.chkfilter,tp,LOCATION_EXTRA,0,nil,tp)
		if #cg==0 then return false end
		local g=Duel.GetMatchingGroup(cm.targetfilter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler(),e)
		return g:CheckSubGroup(cm.fselect,2,2,tp)
	end
	local g=Duel.GetMatchingGroup(cm.targetfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sg=g:SelectSubGroup(tp,cm.fselect,false,2,2,tp)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local og=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local tg=Duel.GetMatchingGroup(cm.lkfilter,tp,LOCATION_EXTRA,0,nil,og)
	if og:GetCount()>0 and tg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local rg=tg:Select(tp,1,1,nil)
		Duel.LinkSummon(tp,rg:GetFirst(),og,nil,#og,#og)
	end
end