--未觉诡灾的平凡
local s,id,o=GetID()
function s.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--选择效果发动
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
end
s.has_text_type=TYPE_DUAL
function s.thfilter1(c)
	return c:IsType(TYPE_DUAL) and c:IsAbleToHand()
end
function s.thfilter2(c)
	return aux.IsTypeInText(c,TYPE_DUAL) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(s.thfilter1,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(s.thfilter2,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return (b1 or b2) end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(id,1),1},
		{b2,aux.Stringid(id,2),2})
	e:SetLabel(op)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    local op=e:GetLabel()
    local res=false
    if op==1 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local hc1=Duel.SelectMatchingCard(tp,s.thfilter1,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
		if hc1 and Duel.SendtoHand(hc1,nil,REASON_EFFECT)~=0 and hc1:IsLocation(LOCATION_HAND) then
			Duel.ConfirmCards(1-tp,hc1)
            res=true
		end   
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local hc2=Duel.SelectMatchingCard(tp,s.thfilter2,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
		if hc2 and Duel.SendtoHand(hc2,nil,REASON_EFFECT)~=0 and hc2:IsLocation(LOCATION_HAND) then
			Duel.ConfirmCards(1-tp,hc2)
            res=true
		end
	end
    if res and c:IsRelateToEffect(e) then
    	Duel.BreakEffect()
        Duel.Destroy(c,REASON_EFFECT)
    end
end