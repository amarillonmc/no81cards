--核成指挥官
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+o*10000)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function s.costfilter(c,e,tp)
	return c:IsFaceupEx() and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,c,e,tp) and c:IsSetCard(0x1d) and c:IsType(TYPE_MONSTER)
		and Duel.GetMZoneCount(tp,c)>0
end
function s.spfilter(c,tc,e,tp)
	return not c:IsAttribute(tc:GetAttribute())
		and c:IsSetCard(0x1d) and c:IsLevelBelow(4)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,e,tp)
	end
	e:SetLabel(0)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,tc,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.thfilter(c,e)
	return c:IsSetCard(0x1d) and c:IsCanBeEffectTarget(e) and c:IsAbleToHand()
end
function s.gcheck(g,tp)
	return aux.dncheck(g) and Duel.IsExistingMatchingCard(aux.AND(Card.IsFaceup,Card.IsSetCard),tp,LOCATION_MZONE,0,g:GetCount(),nil,0x1d)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_REMOVED,0,nil,e)
	if chkc then return false end
	if chk==0 then return g:CheckSubGroup(s.gcheck,1,99,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=g:SelectSubGroup(tp,s.gcheck,false,1,99,tp)
	Duel.SetTargetCard(g1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,g1:GetCount(),0,0)
	local sg=Duel.GetMatchingGroup(aux.AND(Card.IsFaceup,Card.IsSetCard),tp,LOCATION_MZONE,0,nil,0x1d)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,g1:GetCount(),0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		local ct=Duel.SendtoHand(g,nil,REASON_EFFECT)
		if ct~=0 and Duel.IsExistingMatchingCard(aux.AND(Card.IsFaceup,Card.IsSetCard),tp,LOCATION_MZONE,0,ct,nil,0x1d) then
			local dg=Duel.SelectMatchingCard(tp,aux.AND(Card.IsFaceup,Card.IsSetCard),tp,LOCATION_MZONE,0,ct,ct,nil,0x1d)
			Duel.BreakEffect()
			Duel.Destroy(dg,REASON_EFFECT)
		end
	end
end