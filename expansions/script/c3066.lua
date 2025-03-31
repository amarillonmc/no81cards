--祭礼亚龙骑兵 柯蓝
function c3066.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--remove and check
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(3066,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_DISCARD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c3066.recon)
	e1:SetTarget(c3066.retg)
	e1:SetOperation(c3066.reop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(3066,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c3066.spcost)
	e2:SetTarget(c3066.sptg)
	e2:SetOperation(c3066.spop)
	c:RegisterEffect(e2)
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(3066,2))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(c3066.eqtg)
	e3:SetOperation(c3066.eqop)
	c:RegisterEffect(e3)
	--discard
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(3066,3))
	e4:SetCategory(CATEGORY_HANDES)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c3066.discost)
	e4:SetTarget(c3066.distg)
	e4:SetOperation(c3066.disop)
	c:RegisterEffect(e4)
end 
function c3066.filter(c,tp)
	return c:GetPreviousControler()==tp and c:GetPreviousLocation()==LOCATION_HAND
end
function c3066.recon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c3066.filter,1,nil,tp)
end
function c3066.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
end
function c3066.reop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,1) then return end
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if tc:IsSetCard(0x851) and tc:IsType(TYPE_MONSTER) then
		Duel.DisableShuffleCheck()
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	else
		Duel.MoveSequence(tc,1)
	end
end
function c3066.cfilter(c)
	return c:IsSetCard(0x851) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c3066.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c3066.cfilter,tp,LOCATION_GRAVE,0,2,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c3066.cfilter,tp,LOCATION_GRAVE,0,2,2,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c3066.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c3066.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c3066.eqfilter(c)
	return c:IsSetCard(0x851) and c:IsType(TYPE_MONSTER) and c:IsLevelAbove(4) 
end
function c3066.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c3066.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c3066.eqfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c3066.eqfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c3066.eqop(e,tp,eg,ep,ev,re,r,rp)
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
		e1:SetValue(c3066.eqlimit)
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
function c3066.eqlimit(e,c)
	return e:GetOwner()==c and not c:IsDisabled()
end
function c3066.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetEquipGroup():IsExists(Card.IsDestructable,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=e:GetHandler():GetEquipGroup()
	local sg=e:GetHandler():GetEquipCount()
	e:SetLabel(sg)
	Duel.Destroy(g,REASON_COST)
end
function c3066.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	--[[if chk==0 then
		local h1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
		if e:GetHandler():IsLocation(LOCATION_HAND) then h1=h1-1 end
		local h2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
		return h1>e:GetLabel() and h2>e:GetLabel()
	end]]--
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,PLAYER_ALL,e:GetLabel())
end
function c3066.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.DiscardHand(tp,aux.TRUE,e:GetLabel(),e:GetLabel(),REASON_EFFECT+REASON_DISCARD)
	Duel.DiscardHand(1-tp,aux.TRUE,e:GetLabel(),e:GetLabel(),REASON_EFFECT+REASON_DISCARD)
end