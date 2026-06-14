--No.53 伪骸神 心地心-绝望诅咒
function c71280029.initial_effect(c)
	aux.AddCodeList(c,97403510)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,3)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71280029,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c71280029.thcost)
	e1:SetTarget(c71280029.thtg)
	e1:SetOperation(c71280029.thop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71280029,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_BECOME_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCondition(c71280029.eqcon)
	e2:SetTarget(c71280029.eqtg)
	e2:SetOperation(c71280029.eqop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	c:RegisterEffect(e3)
end
aux.xyz_number[71280029]=53
function c71280029.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	local ct=0
	local g=Duel.GetMatchingGroup(c71280029.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)==0 then return false end
	if g:GetClassCount(Card.GetCode)>=2 then
		ct=e:GetHandler():RemoveOverlayCard(tp,1,2,REASON_COST)
	else
		ct=e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	end
	e:SetLabel(ct)
end
function c71280029.thfilter(c)
	return aux.IsCodeListed(c,97403510) and c:IsAbleToHand()
end
function c71280029.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71280029.thfilter,tp,LOCATION_DECK,0,1,nil) end
	local ct=e:GetLabel()
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,ct,tp,LOCATION_DECK)
end
function c71280029.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c71280029.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then
		local ct=e:GetLabel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:SelectSubGroup(tp,aux.dncheck,false,ct,ct)
		if sg then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function c71280029.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler())
end
function c71280029.eqfilter(c,tp)
	return c:IsFaceupEx() and c:IsType(TYPE_MONSTER) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function c71280029.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
		return ft>0 and Duel.IsExistingMatchingCard(c71280029.eqfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,e:GetHandler()) end
end
function c71280029.eqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	if not (c:IsRelateToEffect(e) and c:IsFaceup()) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local ec=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c71280029.eqfilter),tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,1,c,tp):GetFirst()
	if ec and Duel.Equip(tp,ec,c)then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetLabelObject(c)
		e1:SetValue(c71280029.eqlimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		ec:RegisterEffect(e1)
		--
		local e2=Effect.CreateEffect(ec)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(ec:GetAttack())
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		ec:RegisterEffect(e2,true)
		--substitute
		local e3=Effect.CreateEffect(ec)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_EQUIP)
		e3:SetCode(EFFECT_DESTROY_REPLACE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		e3:SetTarget(c71280029.reptg)
		e3:SetOperation(c71280029.repop)
		ec:RegisterEffect(e3,true)
		--
		local e4=Effect.CreateEffect(ec)
		e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_LEAVE_FIELD_P)
		e4:SetLabelObject(ec)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		e4:SetOperation(c71280029.damop)
		ec:RegisterEffect(e4,true)
	end
end
function c71280029.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c71280029.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
		and not c:GetEquipTarget():IsReason(REASON_REPLACE) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c71280029.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end
function c71280029.damop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local cp=tc:GetControler()
	Duel.Hint(HINT_CARD,0,71280029)
	if Duel.Damage(1-cp,tc:GetAttack()/2,REASON_EFFECT)~=0 then
		Duel.Recover(cp,tc:GetAttack()/2,REASON_EFFECT)
	end
end