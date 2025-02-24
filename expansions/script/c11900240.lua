--黄沙锐爪－姆忒
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,11900061)
	c:EnableReviveLimit()
	--to grave 
	local e1=Effect.CreateEffect(c) 
    e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_HAND)  
	e1:SetCountLimit(1,id)
	e1:SetCost(s.htgcost)
	e1:SetTarget(s.htgtg) 
	e1:SetOperation(s.htgop) 
	c:RegisterEffect(e1)
    --to grave  
	local e2=Effect.CreateEffect(c)  
    e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_TO_GRAVE) 
	e2:SetProperty(EFFECT_FLAG_DELAY)  
	e2:SetCountLimit(1,id+10000)
	e2:SetCondition(function(e) 
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND+LOCATION_ONFIELD) end)
	e2:SetTarget(s.tgtg) 
	e2:SetOperation(s.tgop) 
	c:RegisterEffect(e2)
end
function s.htgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function s.htgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_HAND,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
end 
function s.htgop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_HAND,0,nil)  
	if g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil) 
		Duel.SendtoGrave(sg,REASON_EFFECT)  
	end 
end
function s.thfil(c) 
	return c:IsAbleToHand() and aux.IsCodeListed(c,11900061) and c:IsType(TYPE_MONSTER)
end 
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfil,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end  
	if e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) then 
		e:SetLabel(1) 
	else 
		e:SetLabel(0) 
	end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end  
function s.desfilter1(c)
	return c:GetSequence()<5
end
function s.desfilter2(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsControler(1-tp)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(s.thfil,tp,LOCATION_GRAVE,0,e:GetHandler())
    local g2=Duel.GetMatchingGroup(s.desfilter1,tp,0,LOCATION_SZONE,nil)
	if g1:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=g1:Select(tp,1,1,nil) 
		Duel.SendtoHand(tg,tp,REASON_EFFECT)
		if e:GetLabel()==1 and g2:GetCount()>0 then  
            local dg=Group.CreateGroup()
            local tc=g2:GetFirst()
            while tc do 
                local sg=tc:GetColumnGroup():Filter(s.desfilter2,nil,tp)
                if sg:GetCount()==0 then
                    dg:AddCard(tc)
           		end 
           		tc=g2:GetNext()
          	end
            if dg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
                Duel.BreakEffect()
                Duel.Destroy(dg,REASON_EFFECT)
            end
		end 
	end
end