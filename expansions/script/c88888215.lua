--CAN:D 超瑞拉
function c88888215.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x8908),4,2,nil,nil,99)
	c:EnableReviveLimit()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(88888215,4))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,88888215)
	e1:SetCondition(c88888215.tgcon)
	e1:SetCost(c88888215.tgcost)
	e1:SetTarget(c88888215.tgtg)
	e1:SetOperation(c88888215.tgop)
	c:RegisterEffect(e1)
	--adjust(disablecheck)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(0xff)
	e2:SetLabelObject(e1)
	e2:SetOperation(c88888215.adjustop)
	c:RegisterEffect(e2)
	--negate attack
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,18888215)
	e3:SetTarget(c88888215.target)
	e3:SetOperation(c88888215.operation)
	c:RegisterEffect(e3)
end
function c88888215.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetHandler():GetFlagEffectLabel(88888215)
end
function c88888215.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	local mg=e:GetHandler():GetOverlayGroup()
	e:SetLabel(mg:GetCount())
	local ct=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ct>0 and Duel.IsPlayerAffectedByEffect(tp,88888217) and Duel.SelectYesNo(tp,aux.Stringid(88888217,1)) then
		local sg=mg:Select(tp,1,ct,nil)
		if #sg~=0 then
			for sc in aux.Next(sg) do
				Duel.MoveToField(sc,tp,sc:GetOwner(),LOCATION_SZONE,POS_FACEUP,true) 
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetCode(EFFECT_CHANGE_TYPE)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
				e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
				sc:RegisterEffect(e1)
				mg:Sub(Group.FromCards(sc))
			end
		end
	end
	if #mg>0 then e:GetHandler():RemoveOverlayCard(tp,#mg,#mg,REASON_COST) end
end
function c88888215.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
	Duel.SetOperationInfo(0,HINTMSG_TOGRAVE,g,1,0,0)
end
function c88888215.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:RegisterFlagEffect(88888215,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2,Duel.GetTurnCount()+1)
	end
end
function c88888215.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local e1=e:GetLabelObject()
	local ct=Duel.GetMatchingGroupCount(c88888215.ctfilter,tp,LOCATION_ONFIELD,0,nil)
	if ct>0 then
		e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN)
	else
		e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	end
end
function c88888215.ctfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS)
end
function c88888215.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c88888215.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.NegateAttack()
	end
end