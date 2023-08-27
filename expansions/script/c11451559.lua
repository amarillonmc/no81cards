--诡雷战队X -撕裂者-
--21.04.24
local cm,m=GetID()
function cm.initial_effect(c)
	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,cm.ffilter,2,true)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(cm.adjustop)
	c:RegisterEffect(e1)
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.con)
	e2:SetTarget(cm.tdtg)
	e2:SetOperation(cm.tdop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(cm.con2)
	c:RegisterEffect(e3)
	--atk up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(cm.atkval)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(cm.exval)
	c:RegisterEffect(e5)
end
function cm.ffilter(c,fc,sub,mg,sg)
	return c:IsOnField() and (not sg or sg:FilterCount(aux.TRUE,c)==0 or (sg:IsExists(Card.IsFusionAttribute,1,c,c:GetFusionAttribute()) and sg:IsExists(Card.IsRace,1,c,c:GetRace())))
end
function cm.eqfilter(c)
	return c:GetFlagEffect(m)~=0
end
function cm.eqlimit(e,c)
	return e:GetOwner()==c
end
function cm.equipfd(c,tp,tc)
	if tc:IsPosition(POS_FACEUP) then return Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEDOWN,false) end
	if not Duel.Equip(tp,tc,c,false) then return false end
	--Add Equip limit
	tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(cm.eqlimit)
	tc:RegisterEffect(e1)
	return true
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	local c=e:GetHandler()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL or c:IsStatus(STATUS_BATTLE_DESTROYED) or not Duel.IsPlayerCanSSet(tp) then return end
	if not c:GetEquipGroup():IsExists(cm.eqfilter,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.GetMatchingGroupCount(nil,tp,0,LOCATION_EXTRA,nil)>0 then
		Duel.Hint(HINT_CARD,0,m)
		local tc=Duel.GetMatchingGroup(nil,tp,0,LOCATION_EXTRA,nil):GetMaxGroup(Card.GetSequence):GetFirst()
		Duel.DisableShuffleCheck()
		if tc:IsForbidden() then
			Duel.DiscardDeck(tp,1,REASON_RULE)
			Duel.Readjust()
		elseif cm.equipfd(c,tp,tc) then
			Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
			Duel.Readjust()
		end
	end
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,11451556)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,11451556)
end
function cm.filter(c)
	return c:IsSetCard(0x97e) and c:IsAbleToDeck()
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,1,0,0)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then Duel.SendtoDeck(tc,nil,0,REASON_EFFECT) end
end
function cm.fdfilter(c)
	return c:GetEquipTarget() and c:IsFacedown()
end
function cm.atkval(e,c)
	return Duel.GetMatchingGroupCount(cm.fdfilter,c:GetControler(),LOCATION_ONFIELD,0,nil)*400
end
function cm.exval(e,c)
	return Duel.GetMatchingGroupCount(cm.fdfilter,c:GetControler(),LOCATION_ONFIELD,0,nil)-1
end