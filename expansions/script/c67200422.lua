--术结天缘骑 煌磷结骑
function c67200422.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	c:EnableCounterPermit(0x671,LOCATION_PZONE+LOCATION_MZONE)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200422,3))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c67200422.rmcost)
	e1:SetTarget(c67200422.rmtg)
	e1:SetOperation(c67200422.rmop)
	c:RegisterEffect(e1)  
	--add counter
	local e2=Effect.CreateEffect(c)
	--e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCondition(c67200422.ctcon)
	--e2:SetTarget(c67200422.cttg)
	e2:SetOperation(c67200422.ctop)
	c:RegisterEffect(e2) 
	--pendulum scale up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_UPDATE_LSCALE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetValue(c67200422.scaledown)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_RSCALE)
	c:RegisterEffect(e4)   
end
--
function c67200422.ctfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp)
		and c:IsType(TYPE_PENDULUM) and c:IsPreviousSetCard(0x5671)
end
function c67200422.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c67200422.ctfilter,1,nil,tp)
end
function c67200422.thfilter(c)
	return c:GetCounter(0x671)>0 and c:IsAbleToHand()
end
function c67200422.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	e:GetHandler():AddCounter(0x671,2)
	local rt=Duel.GetFieldGroupCount(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	local rtt=Duel.GetFieldGroupCount(c67200422.thfilter,tp,LOCATION_ONFIELD,0,nil)
	if rt>0 and c:GetCounter(0x671)>5 and rtt>0 and Duel.SelectYesNo(tp,aux.Stringid(67200422,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectMatchingCard(tp,c67200422.thfilter,tp,LOCATION_ONFIELD,0,1,rt,nil)
		if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local gg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,g:GetCount(),g:GetCount(),nil)
			Duel.Remove(gg,POS_FACEUP,REASON_EFFECT)
		end
	end
end
--
function c67200422.scaledown(e,c)
	local count=c:GetCounter(0x671)
	local a=0
	if count>6 then
		a=6
	else
		a=count
	end
	return -a
end
--

function c67200422.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x671,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x671,2,REASON_COST)
end
function c67200422.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c67200422.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
