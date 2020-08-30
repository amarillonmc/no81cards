function c82228497.initial_effect(c)  
	--xyz summon  
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x291),8,2)  
	c:EnableReviveLimit()
	--summon proc  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(82228497,1))  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_SUMMON_PROC)  
	e1:SetTargetRange(LOCATION_HAND,0)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetCondition(c82228497.otcon)  
	e1:SetTarget(c82228497.ottg)  
	e1:SetOperation(c82228497.otop)  
	e1:SetValue(SUMMON_TYPE_ADVANCE)  
	c:RegisterEffect(e1)  
	local e4=e1:Clone()  
	e4:SetCode(EFFECT_SET_PROC)  
	c:RegisterEffect(e4)  
	--summon  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(82228497,0))  
	e2:SetCategory(CATEGORY_SUMMON)  
	e2:SetType(EFFECT_TYPE_QUICK_O)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCountLimit(1)
	e2:SetCondition(c82228497.con)
	e2:SetCost(c82228497.cost)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c82228497.sumtg)  
	e2:SetOperation(c82228497.sumop)  
	c:RegisterEffect(e2)   
end  
function c82228497.rfilter(c)  
	return c:IsAbleToDeckOrExtraAsCost() 
end  
function c82228497.otcon(e,c,minc)  
	if c==nil then return true end  
	local tp=c:GetControler()  
	return minc<=2 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and Duel.IsExistingMatchingCard(c82228497.rfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,nil)
end  
function c82228497.ottg(e,c)  
	local mi,ma=c:GetTributeRequirement()  
	return mi<=2 and ma>=2 and c:IsSetCard(0x291)  
end  
function c82228497.otop(e,tp,eg,ep,ev,re,r,rp,c)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)  
	local g=Duel.SelectMatchingCard(tp,c82228497.rfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,2,nil)  
	Duel.SendtoDeck(g,nil,2,REASON_COST) 
end  
function c82228497.sumfilter(c)  
	return c:IsSetCard(0x291) and c:IsSummonable(true,nil)  
end  
function c82228497.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp 
end
function c82228497.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end  
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)  
end  
function c82228497.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c82228497.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)  
end  
function c82228497.sumop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)  
	local g=Duel.SelectMatchingCard(tp,c82228497.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)  
	local tc=g:GetFirst()  
	if tc then  
		Duel.Summon(tp,tc,true,nil)  
	end  
end  
