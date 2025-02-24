--吉兆之猫－贝斯特
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,11900061)
	c:EnableReviveLimit()
    --search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.tgcost)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--token to grave 
	local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_TO_GRAVE) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.tktg) 
	e2:SetOperation(s.tkop) 
	c:RegisterEffect(e2) 
end
function s.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,0x02,0,1,c)
        and c:IsAbleToGraveAsCost() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,0x02,0,1,1,c)
	g:AddCard(c)
	Duel.SendtoGrave(g,REASON_COST)
end
function s.thfi1ter(c)
	return aux.IsCodeListed(c,11900061) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.thfi2ter(c)
	return c:IsCode(11900061) and c:IsAbleToHand()
end
function s.fselect(g)
	return g:FilterCount(s.thfi1ter,nil)==1
		and g:FilterCount(s.thfi2ter,nil)==1
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.thfi1ter,tp,0x01,0,1,nil)
        and Duel.IsExistingMatchingCard(s.thfi2ter,tp,0x01,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,0x01)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0x01,0,nil)
	Duel.Hint(3,tp,506)
	local sg=g:SelectSubGroup(tp,s.fselect,false,2,2)
	if sg:GetCount()==2 then
		Duel.SendtoHand(sg,nil,0x40)
        Duel.ConfirmCards(1-tp,sg)
	end
end
function s.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,11900072,nil,TYPES_TOKEN_MONSTER,400,2800,1,RACE_BEAST,ATTRIBUTE_WATER) end
	if e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) then 
		e:SetLabel(1) 
	else 
		e:SetLabel(0) 
	end 
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function s.tkop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,11900072,nil,TYPES_TOKEN_MONSTER,400,2800,1,RACE_BEAST,ATTRIBUTE_WATER) then return end
	local token=Duel.CreateToken(tp,11900072)
	local zone=0 
	if e:GetLabel()==1 then zone=LOCATION_ONFIELD end
	if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,zone,1,nil) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local dg=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,zone,1,1,nil) 
		Duel.SendtoGrave(dg,REASON_EFFECT)  
	end 
end