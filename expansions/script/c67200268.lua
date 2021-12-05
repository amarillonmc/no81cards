--封缄的雹哭之主 芙露蕾蒂
function c67200268.initial_effect(c)
	c:EnableReviveLimit()
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x674),4,2)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200268,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c67200268.thcost)
	e1:SetTarget(c67200268.thtg)
	e1:SetOperation(c67200268.thop)
	c:RegisterEffect(e1) 
end 
c67200268.pendulum_level=4 
function c67200268.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	local rt=Duel.GetTargetCount(nil,tp,LOCATION_ONFIELD,0,nil)
	local ct=c:RemoveOverlayCard(tp,1,rt,REASON_COST)
	e:SetLabel(ct)
end
function c67200268.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,0,1,nil) end
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local tg=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,0,ct,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tg,ct,0,0)
end
function c67200268.pcfilter(c)
	return c:IsSetCard(0x674) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c67200268.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
	if (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))~=0 and Duel.IsExistingMatchingCard(c67200268.pcfilter,tp,LOCATION_DECK,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local ag=Duel.SelectMatchingCard(tp,c67200268.pcfilter,tp,LOCATION_DECK,0,1,1,nil)
		if ag:GetCount()>0 then
			Duel.MoveToField(ag:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
end
