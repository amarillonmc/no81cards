function c82228529.initial_effect(c)  
	--link summon  
	aux.AddLinkProcedure(c,nil,2,2,c82228529.lcheck)  
	c:EnableReviveLimit()
	--tohand
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(82228529,0))  
	e1:SetCategory(CATEGORY_TOHAND)  
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,82228529)  
	e1:SetCondition(c82228529.thcon)
	e1:SetTarget(c82228529.thtg)  
	e1:SetOperation(c82228529.thop)  
	c:RegisterEffect(e1) 
	--summon  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(82228529,1))  
	e2:SetCategory(CATEGORY_SUMMON)  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCountLimit(1,82218529)
	e2:SetCost(c82228529.sumcost)  
	e2:SetTarget(c82228529.sumtg)  
	e2:SetOperation(c82228529.sumop)  
	c:RegisterEffect(e2)  
	if not c82228529.global_check then  
		c82228529.global_check=true  
		local ge1=Effect.CreateEffect(c)  
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)  
		ge1:SetLabel(82228529) 
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
		ge1:SetOperation(aux.sumreg)  
		Duel.RegisterEffect(ge1,0)   
	end  
end   
 
function c82228529.lcheck(g,lc)  
	return g:IsExists(Card.IsLinkAttribute,1,nil,ATTRIBUTE_EARTH)  
end  
function c82228529.thcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetHandler():GetFlagEffect(82228529)>0  
end  
function c82228529.thfilter(c)  
	return c:GetAttack()==1350 and c:IsAbleToHand()  
end  
function c82228529.tgfilter(c)  
	return c:GetMutualLinkedGroupCount()>0 
end  
function c82228529.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c82228529.tgfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c82228529.thfilter,tp,LOCATION_GRAVE,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,nil,tp,LOCATION_GRAVE)  
end  
function c82228529.thop(e,tp,eg,ep,ev,re,r,rp) 
	local ct=Duel.GetMatchingGroupCount(c82228529.tgfilter,tp,LOCATION_MZONE,0,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,c82228529.thfilter,tp,LOCATION_GRAVE,0,1,ct,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
end  
function c82228529.sumfilter(c)  
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsSummonable(true,nil)  
end  
function c82228529.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.CheckLPCost(tp,500) end  
	Duel.PayLPCost(tp,500)  
end  
function c82228529.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c82228529.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)  
end  
function c82228529.sumop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)  
	local g=Duel.SelectMatchingCard(tp,c82228529.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)  
	local tc=g:GetFirst()  
	if tc then  
		Duel.Summon(tp,tc,true,nil)  
	end   
end  