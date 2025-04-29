--日常系PSI///堀裕子
local s,id,o=GetID()
function s.initial_effect(c)
	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.prop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.con2)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.prop2)
	c:RegisterEffect(e2)
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and chkc:IsAbleToRemove() end
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function s.prop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>0  then
		Duel.BreakEffect()
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(id,3))
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e2:SetCountLimit(1)
		e2:SetLabel(Duel.GetTurnCount())
		e2:SetCondition(s.spcon)
		e2:SetOperation(s.spop)
		if Duel.GetCurrentPhase()<=PHASE_STANDBY then
			e2:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
		else
			e2:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
		end
		Duel.RegisterEffect(e2,tp)

	end
end
function s.spfilter(c)
	return c:IsSetCard(0x605) and not c:IsForbidden()
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.GetTurnCount()~=e:GetLabel() and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local result = Duel.SelectYesNo(tp,aux.Stringid(id,2))
	if not result then return end
	Duel.Hint(HINT_CARD,0,id)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		local tc = g:GetFirst()
		if Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			tc:RegisterEffect(e1)
		end
	end
end

function s.cfilter(c,tp,rp)
	local bc=c:GetBattleTarget()
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousSetCard(0x605) and ((c:IsReason(REASON_BATTLE)) or (rp==1-tp and c:IsReason(REASON_EFFECT))) and c:IsPreviousControler(tp)
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp,rp) and not eg:IsContains(e:GetHandler())
end
function s.filter4(c)
	return c:IsFaceup()
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.prop2(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP_ATTACK) then
		Duel.SpecialSummonComplete()
		if Duel.IsExistingMatchingCard(s.filter4,tp,LOCATION_MZONE,0,1,c) and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local tc = Duel.SelectMatchingCard(tp,s.filter4,tp,LOCATION_MZONE,0,1,1,c):GetFirst()
			if not Duel.Equip(tp,c,tc) then return end
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetLabelObject(tc)
			e1:SetValue(s.eqlimit)
			c:RegisterEffect(e1)
			--atk up
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_EQUIP)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetValue(1000)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e2)
		end
	end
	
end
function s.eqlimit(e,c)
	return c==e:GetLabelObject()
end