--空牙团的追猎 亚瑟
function c19198195.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c19198195.mfilter,2,2,c19198195.lcheck)
	c:EnableReviveLimit() 
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(19198195,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,19198195) 
	e1:SetCost(c19198195.sgcost)
	e1:SetTarget(c19198195.sgtg)
	e1:SetOperation(c19198195.sgop)
	c:RegisterEffect(e1) 
	--to hand 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(19198195,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCountLimit(1,29198195) 
	e2:SetCondition(c19198195.thcon)
	e2:SetTarget(c19198195.thtg) 
	e2:SetOperation(c19198195.thop) 
	c:RegisterEffect(e2)
end 
function c19198195.mfilter(c) 
	return c:IsLinkSetCard(0x114)   
end 
function c19198195.lcheck(g,lc)
	return g:GetClassCount(Card.GetLinkRace)==g:GetCount()
end
function c19198195.sgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c19198195.tgfil(c)
	return c:IsAbleToGrave() and c:IsSetCard(0x114) 
end
function c19198195.sgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c19198195.tgfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c19198195.sgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c19198195.tgfil,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c19198195.cfilter(c,lg,tp)
	return c:IsSetCard(0x114) and lg:IsContains(c) and Duel.IsExistingMatchingCard(c19198195.thfil,tp,LOCATION_DECK,0,1,nil,c)
end 
function c19198195.thfil(c,sc) 
	return c:IsSetCard(0x114) and c:IsType(TYPE_MONSTER) and not c:IsRace(sc:GetRace()) and c:IsAbleToHand() 
end 
function c19198195.thcon(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	return eg:IsExists(c19198195.cfilter,1,nil,lg,tp)
end
function c19198195.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end 
function c19198195.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local lg=e:GetHandler():GetLinkedGroup()
	local g=Group.CreateGroup() 
	local cg=eg:Filter(c19198195.cfilter,nil,lg,tp) 
	if cg:GetCount()<=0 then return end 
	local tc=cg:GetFirst() 
	while tc do 
	local xg=Duel.GetMatchingGroup(c19198195.thfil,tp,LOCATION_DECK,0,nil,tc) 
	g:Merge(xg) 
	tc=cg:GetNext() 
	end 
	if g:GetCount()>0 then 
	local sg=g:Select(tp,1,1,nil)   
	Duel.SendtoHand(sg,tp,REASON_EFFECT) 
	Duel.ConfirmCards(1-tp,sg) 
	end 
end 



