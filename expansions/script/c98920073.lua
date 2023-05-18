--遗式崩溃
function c98920073.initial_effect(c)
	 --Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(c98920073.cost)
	e1:SetTarget(c98920073.target)
	e1:SetOperation(c98920073.operation)
	c:RegisterEffect(e1)
end
function c98920073.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c98920073.cfilter(c,tp)
	return c:GetOriginalLevel()>0
		and c:IsType(TYPE_RITUAL)
end
function c98920073.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.CheckReleaseGroup(tp,c98920073.cfilter,1,nil,tp) and #g>0
	end
	local g=Duel.SelectReleaseGroup(tp,c98920073.cfilter,1,1,nil,tp)
	e:SetLabelObject(g:GetFirst())
	Duel.Release(g,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c98920073.rmfilter(c)
	return c:GetLevel()>0 and c:IsAbleToRemove()
end
function c98920073.gselect(g,num)
	return g:GetSum(c98920073.lv_or_rk)<=num
end
function c98920073.lv_or_rk(c)
	if c:IsType(TYPE_XYZ) then return c:GetRank()
	else return c:GetLevel() end
end
function c98920073.desfilter2(c,num)
	return c:IsFaceup() and (c:IsLevelBelow(num) or c:IsRankBelow(num))
end
function c98920073.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local num=tc:GetLevel()
	local g=Duel.GetMatchingGroup(c98920073.desfilter2,tp,0,LOCATION_MZONE,nil,num)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=g:SelectSubGroup(tp,c98920073.gselect,false,1,#g,num)
	Duel.Destroy(dg,REASON_EFFECT)
	local g2=Duel.GetMatchingGroup(c98920073.thfilter,tp,LOCATION_DECK,0,nil)
	if tc:IsSetCard(0x3a) and #g2>0 and Duel.SelectYesNo(tp,aux.Stringid(98920073,1)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg2=g2:Select(tp,1,1,nil)
				Duel.BreakEffect()
				Duel.SendtoHand(sg2,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg2)
			end
end
function c98920073.thfilter(c,specify)
	return ((c:IsSetCard(0x3a) and c:IsLevelBelow(4)) or c:IsSetCard(0x18e)) and c:IsAbleToHand()
end