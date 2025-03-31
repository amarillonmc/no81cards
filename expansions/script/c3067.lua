--祭礼亚龙骑兵 亚莉特
function c3067.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--remove and check
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(3067,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_REMOVE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c3067.recon)
	e1:SetTarget(c3067.retg)
	e1:SetOperation(c3067.reop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(3067,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c3067.spcost)
	e2:SetTarget(c3067.sptg)
	e2:SetOperation(c3067.spop)
	c:RegisterEffect(e2)
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(3067,2))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(c3067.eqtg)
	e3:SetOperation(c3067.eqop)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(3067,3))
	e4:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c3067.thcost)
	e4:SetTarget(c3067.thtg)
	e4:SetOperation(c3067.thop)
	c:RegisterEffect(e4)
end 
function c3067.filter(c,tp)
	return c:GetPreviousControler()==tp 
end
function c3067.recon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c3067.filter,1,nil,tp)
end
function c3067.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
end
function c3067.reop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,1) then return end
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if tc:IsSetCard(0x851) and tc:IsType(TYPE_MONSTER) then
		Duel.DisableShuffleCheck()
		Duel.SendtoGrave(tc,REASON_EFFECT)
	else
		Duel.MoveSequence(tc,1)
	end
end
function c3067.cfilter(c)
	return c:IsSetCard(0x851) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c3067.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c3067.cfilter,tp,LOCATION_GRAVE,0,2,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c3067.cfilter,tp,LOCATION_GRAVE,0,2,2,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c3067.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c3067.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c3067.eqfilter(c)
	return c:IsSetCard(0x851) and c:IsType(TYPE_MONSTER) and c:IsLevelBelow(6) 
end
function c3067.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c3067.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c3067.eqfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c3067.eqfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c3067.eqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsFaceup() and c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local atk=tc:GetTextAttack()/2
		if atk<0 then atk=0 end
		if not Duel.Equip(tp,tc,c,false) then return end
		--Add Equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(c3067.eqlimit)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetValue(atk)
		tc:RegisterEffect(e2)
	else 
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
function c3067.eqlimit(e,c)
	return e:GetOwner()==c and not c:IsDisabled()
end
function c3067.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetEquipGroup():IsExists(Card.IsDestructable,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=e:GetHandler():GetEquipGroup()
	local sg=e:GetHandler():GetEquipCount()
	e:SetLabel(sg)
	Duel.Destroy(g,REASON_COST)
end
function c3067.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) end
	if chk==0 then return true end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
end
function c3067.thop(e,tp,eg,ep,ev,re,r,rp)
	local d1=e:GetLabel()
	if d1>0 then
		local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local ssg=g:Select(tp,d1,d1,nil)
			Duel.HintSelection(ssg)
			Duel.SendtoHand(ssg,nil,REASON_EFFECT)
		end 
	end   
end