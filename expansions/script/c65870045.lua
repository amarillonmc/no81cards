--Protoss·灵能风暴
function c65870045.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65870045+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c65870045.condition)
	e1:SetTarget(c65870045.target)
	e1:SetOperation(c65870045.activate)
	c:RegisterEffect(e1)
end

function c65870045.hcfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3a37) and c:IsLinkAbove(3)
end
function c65870045.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c65870045.hcfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c65870045.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.GetMatchingGroupCount(aux.TRUE,tp,0,LOCATION_MZONE,1,nil)>0
	local b2=Duel.GetMatchingGroupCount(Card.IsType,tp,0,LOCATION_ONFIELD,c,TYPE_SPELL+TYPE_TRAP)>0
	if chk==0 then return b1 or b2 end
	local s=0
	if b1 and not b2 then
		s=Duel.SelectOption(tp,aux.Stringid(65870045,0))
	end
	if not b1 and b2 then
		s=Duel.SelectOption(tp,aux.Stringid(65870045,1))+1
	end
	if b1 and b2 then
		s=Duel.SelectOption(tp,aux.Stringid(65870045,0),aux.Stringid(65870045,1))
	end
	e:SetLabel(s)
	local g=nil
	if s==0 then
		g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,1,nil)
	end
	if s==1 then
		g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,c,TYPE_SPELL+TYPE_TRAP)
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c65870045.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=nil
	if e:GetLabel()==0 then
		g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,1,nil)
	end
	if e:GetLabel()==1 then
		g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,aux.ExceptThisCard(e),TYPE_SPELL+TYPE_TRAP)
	end
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
