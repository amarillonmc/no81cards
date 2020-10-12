function c82228526.initial_effect(c)  
	--link summon  
	aux.AddLinkProcedure(c,nil,2,2,c82228526.lcheck)  
	c:EnableReviveLimit()
	--search  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(82228526,0))  
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,82228526)  
	e1:SetCondition(c82228526.thcon)
	e1:SetTarget(c82228526.thtg)  
	e1:SetOperation(c82228526.thop)  
	c:RegisterEffect(e1) 
	--summon  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(82228526,1))  
	e2:SetCategory(CATEGORY_SUMMON)  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCountLimit(1,82218526)
	e2:SetCost(c82228526.sumcost)  
	e2:SetTarget(c82228526.sumtg)  
	e2:SetOperation(c82228526.sumop)  
	c:RegisterEffect(e2)  
	if not c82228526.global_check then  
		c82228526.global_check=true  
		local ge1=Effect.CreateEffect(c)  
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)  
		ge1:SetLabel(82228526) 
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
		ge1:SetOperation(aux.sumreg)  
		Duel.RegisterEffect(ge1,0)   
	end  
end   
 
function c82228526.lcheck(g,lc)  
	return g:IsExists(Card.IsLinkAttribute,1,nil,ATTRIBUTE_WIND)  
end  
function c82228526.thcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetHandler():GetFlagEffect(82228526)>0  
end  
function c82228526.thfilter(c)  
	return c:GetAttack()==1350 and c:IsAbleToHand()  
end  
function c82228526.tgfilter(c)  
	return c:GetMutualLinkedGroupCount()>0 
end  
function c82228526.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c82228526.tgfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c82228526.thfilter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,nil,tp,LOCATION_DECK)  
end  
function c82228526.thop(e,tp,eg,ep,ev,re,r,rp) 
	local ct=Duel.GetMatchingGroupCount(c82228526.tgfilter,tp,LOCATION_MZONE,0,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,c82228526.thfilter,tp,LOCATION_DECK,0,1,ct,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
end  
function c82228526.sumfilter(c)  
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsSummonable(true,nil)  
end  
function c82228526.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.CheckLPCost(tp,500) end  
	Duel.PayLPCost(tp,500)  
end  
function c82228526.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c82228526.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)  
end  
function c82228526.sumop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)  
	local g=Duel.SelectMatchingCard(tp,c82228526.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)  
	local tc=g:GetFirst()  
	if tc then  
		Duel.Summon(tp,tc,true,nil)  
	end   
end  