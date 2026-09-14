--幻想乡的黄泉归
local s,id,o=GetID()
function s.initial_effect(c)
	--发动
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(2,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
end
function s.thfilter(c)
	return c:IsSetCard(0x67b0) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler())
    	and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
    local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.bhfilter(c)
	return c:IsSetCard(0x67b0) and not c:IsCode(id) and c:IsAbleToHand()
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler()):GetFirst()
	if not tc then return end
    Duel.HintSelection(Group.FromCards(tc))
    if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
    	local oc=Duel.GetOperatedGroup():GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local hc=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
		if hc and Duel.SendtoHand(hc,nil,REASON_EFFECT)~=0 and hc:IsLocation(LOCATION_HAND) then
			Duel.ConfirmCards(1-tp,hc)
            if Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.bhfilter),tp,LOCATION_GRAVE,0,1,nil) 
            	and oc:IsSetCard(0x67b0) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
            	Duel.BreakEffect()
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.bhfilter),tp,LOCATION_GRAVE,0,1,1,nil)
				if g:GetCount()>0 then
                	Duel.SendtoHand(g,nil,REASON_EFFECT)
                    Duel.ConfirmCards(1-tp,g)
                end
            end
        end    
	end
end