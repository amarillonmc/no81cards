--术结天缘 魔封炼之齐亚丽
function c67200430.initial_effect(c)	
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--spsummon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(67200430,0))
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCountLimit(1,67200430)
	e0:SetCost(c67200430.excost)
	e0:SetTarget(c67200430.sptg)
	e0:SetOperation(c67200430.spop)
	c:RegisterEffect(e0)   
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,67200431+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c67200430.hspcon)
	e1:SetOperation(c67200430.hspop)
	c:RegisterEffect(e1)  
end
--
function c67200430.excostfilter(c)
	return c:IsSetCard(0x5671) and c:IsAbleToHandAsCost() and c:IsType(TYPE_MONSTER)
end
function c67200430.mfilter(c,tp)
	--local tp=c:GetControler()
	return c:GetSequence()<5 and c:IsLocation(LOCATION_MZONE) 
end
function c67200430.excost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c67200430.excostfilter,tp,LOCATION_ONFIELD,0,1,c) end
	local rg=Duel.GetMatchingGroup(c67200430.excostfilter,tp,LOCATION_ONFIELD,0,c,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=nil
	if ft>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		g=rg:Select(tp,1,1,nil)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		g=rg:FilterSelect(tp,c67200430.mfilter,1,1,nil,tp)
		local g2=rg:Select(tp,1,1,g:GetFirst())
		g:Merge(g2)
	end
	Duel.SendtoHand(g,nil,REASON_COST)
	e:SetLabel(g:GetFirst():GetBaseAttack())
end
function c67200430.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c67200430.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then   
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
--
function c67200430.spcfilter(c)
	return c:IsCode(67200432) and c:IsAbleToGraveAsCost() 
end
function c67200430.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c67200430.spcfilter,tp,LOCATION_DECK,0,1,nil)
end
function c67200430.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c67200430.spcfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
