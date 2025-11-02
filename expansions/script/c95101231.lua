--暗黑能乐面具 希望之枭面
function c95101231.initial_effect(c)
	--union
	aux.EnableUnionAttribute(c,c95101231.unfilter)
	--CoMETIK search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,95101231)
	e1:SetCost(c95101231.thcost)
	e1:SetTarget(c95101231.thtg)
	e1:SetOperation(c95101231.thop)
	c:RegisterEffect(e1)
	--reequip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(95101231,2))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,95101231+1)
	e2:SetCost(c95101231.recost)
	e2:SetTarget(c95101231.retg)
	e2:SetOperation(c95101231.reop)
	c:RegisterEffect(e2)
end
function c95101231.unfilter(c)
	return c:IsSetCard(0xbbb0) or c:IsCode(95101209)
end
function c95101231.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c95101231.thfilter(c)
	return c:IsSetCard(0x3bb0) and c:IsAbleToHand()
end
function c95101231.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c95101231.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c95101231.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c95101231.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c95101231.recost(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetHandler():GetEquipTarget()
	e:SetLabelObject(tc)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c95101231.refilter(c,tc,tp,exclude_modern_count)
	return aux.CheckUnionEquip(c,tc,exclude_modern_count) and c:CheckUnionTarget(tc) and c:IsSetCard(0xbbb0) and not c:IsCode(95101231) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function c95101231.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		local exct=aux.IsUnionState(e) and 1 or 0
		return c:GetEquipTarget()
			and Duel.IsExistingMatchingCard(c95101231.refilter,tp,LOCATION_DECK,0,1,nil,c:GetEquipTarget(),tp,exct)
	end
	local tc=e:GetLabelObject()
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,tc,1,0,0)
end
function c95101231.reop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c95101231.refilter,tp,LOCATION_DECK,0,1,1,nil,tc,tp,nil)
		local ec=g:GetFirst()
		if ec and Duel.Equip(tp,ec,tc) then
			aux.SetUnionState(ec)
		end
	end
end
