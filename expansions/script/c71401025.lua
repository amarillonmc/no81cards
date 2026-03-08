--蝶忆-「煌」
local s,id,o=GetID()
function s.initial_effect(c)
	if not (yume and yume.heart_crystals) then
		yume=yume or {}
		yume.import_flag=true
		c:CopyEffect(71401001,0)
		yume.import_flag=false
	end
	--place self
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71401001,3))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.con1)
	e1:SetCountLimit(1,id)
	e1:SetCost(yume.heart_crystals.LimitCost)
	e1:SetTarget(yume.heart_crystals.PlaceTg)
	e1:SetOperation(yume.heart_crystals.TrapOp)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,s.chainfilter)
	--place trap
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCost(yume.heart_crystals.LimitCost)
	e2:SetCondition(s.con2)
	e2:SetTarget(s.tg2)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
end
function s.chainfilter(re,tp,cid)
	return not (re:IsActiveType(TYPE_TRAP) or re:IsActiveType(TYPE_MONSTER) and Duel.GetChainInfo(cid,CHAININFO_TRIGGERING_ATTRIBUTE) & ATTRIBUTE_DARK>0)
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetType()==TYPE_TRAP+TYPE_CONTINUOUS
		and (Duel.GetCustomActivityCount(id,tp,ACTIVITY_CHAIN)>0
		or Duel.GetCustomActivityCount(id,1-tp,ACTIVITY_CHAIN)>0)
end
function s.filter2(c)
	local re=c:GetReasonEffect()
	return c:GetTurnID()==Duel.GetTurnCount() and c:IsReason(REASON_COST) and re and re:IsActivated()
		and c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsFaceup() and not c:IsForbidden()
end
function s.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_REMOVED,0,1,nil) end
end
function s.cspellfilter(c)
	return c:IsFaceup() and c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS
end
function s.fdownfilter(c)
	return c:IsFacedown()
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_REMOVED,0,1,1,nil):GetFirst()
	if tc and Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
		if Duel.IsExistingMatchingCard(s.cspellfilter,tp,LOCATION_ONFIELD,0,1,nil) then
			local g=Duel.GetMatchingGroup(s.fdownfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
			if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
				Duel.BreakEffect()
				Duel.SendtoHand(g,nil,REASON_EFFECT)
			end
		end
	end
end
