--企鹅物流·行动-分头行动
function c79029057.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,79029057+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c79029057.cost)
	e1:SetTarget(c79029057.target)
	c:RegisterEffect(e1) 
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetDescription(aux.Stringid(73594093,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c79029057.settg)
	e2:SetOperation(c79029057.setop)
	c:RegisterEffect(e2)   
end
function c79029057.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c79029057.desfilter(c,tc,ec)
	return c:IsFaceup()
end
function c79029057.costfilter(c,ec,tp)
	local lk=c:GetLink()
	if not c:IsType(TYPE_LINK) or not c:IsSetCard(0xa900) then return false end
	return Duel.IsExistingTarget(c79029057.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,lk,c,c,ec)
end
function c79029057.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc~=c end
	if chk==0 then
		if e:GetLabel()==1 then
			e:SetLabel(0)
			return Duel.CheckReleaseGroup(tp,c79029057.costfilter,1,c,c,tp)
		else return false end
	end
	e:SetLabel(0)
	local sg=Duel.SelectMatchingCard(tp,c79029057.costfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local lk=sg:GetFirst():GetLink()
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
	local x=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_EXTRA,nil)
	local g=x:RandomSelect(tp,lk)
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
end
function c79029057.setfilter(c)
	return c:IsSetCard(0xc90f) and c:IsSSetable()
end
function c79029057.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029057.setfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c79029057.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c79029057.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
		Duel.ConfirmCards(1-tp,g)
	end
end