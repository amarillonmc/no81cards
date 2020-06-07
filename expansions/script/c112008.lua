--固执的战士-霜星
function c112008.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(8873112,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_NEGATE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCondition(c112008.spcon2)
	e3:SetTarget(c112008.sptg2)
	e3:SetOperation(c112008.spop)
	c:RegisterEffect(e3)   
end
function c112008.cfilter(c,tp)
	return c:IsOnField() and c:IsControler(tp) and c:IsSetCard(0xa006)
end
function c112008.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	return ex and tg~=nil and tc+tg:FilterCount(c112008.cfilter,nil,tp)-tg:GetCount()>0
end
function c112008.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c112008.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.NegateEffect(ev)
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end

