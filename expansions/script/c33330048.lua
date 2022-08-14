--天基兵器 达摩克利斯之剑
local cm,m,o=GetID()
Rule_SpaceWeapon = Rule_SpaceWeapon or {}
local RS = Rule_SpaceWeapon
function RS.initial(c,code,op)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(RS.val1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DRAW)
	e2:SetCondition(RS.con2)
	e2:SetOperation(RS.op2(code,op))
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,code)
	e3:SetCost(RS.cos3)
	e3:SetTarget(RS.tg3)
	e3:SetOperation(RS.op3)
	c:RegisterEffect(e3)
	return e2,e3
end
function RS.spell_grave(c)
	local e=Effect.CreateEffect(c)
	e:SetType(EFFECT_TYPE_IGNITION)
	e:SetRange(LOCATION_GRAVE)
	e:SetCost(RS.s_cos2)
	e:SetTarget(RS.s_tg2)
	e:SetOperation(RS.s_op2)
	c:RegisterEffect(e)
	return e
end
--e1
function RS.val1(e,se,sp,st)
	return se:GetHandler():IsSetCard(0x564)
end
--e2
function RS.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_DRAW and e:GetHandler():IsReason(REASON_RULE) and not e:GetHandler():IsPublic()
end
function RS.op2(code,op)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.SelectYesNo(tp,aux.Stringid(code,0)) then
			Duel.Hint(HINT_CARD,1-tp,code)
			if not (Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)>0) then return end
			c:CompleteProcedure()
			if op then op(e,tp,eg,ep,ev,re,r,rp,c) end
		end
	end
end
--e3
function RS.cos3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST+REASON_TEMPORARY)
	e:SetLabelObject(e:GetHandler())
end
function RS.tgf3(c)
	return c:IsSetCard(0x564) and c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function RS.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(RS.tgf3,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function RS.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local c=Duel.SelectMatchingCard(tp,RS.tgf3,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if c and Duel.SendtoHand(c,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,c)
	end
	RS.TempRemove(e:GetHandler(),e:GetLabelObject())
end
function RS.TempRemove(c,tc)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	e1:SetCondition(RS.op3_con)
	e1:SetOperation(RS.op3_op)
	tc:RegisterEffect(e1)
end
function RS.op3_con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function RS.op3_op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c then Duel.SendtoDeck(c,nil,0,REASON_EFFECT) end
end
function RS.s_cos2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.Hint(HINT_CARD,1-tp,e:GetHandler():GetCode())
	Duel.SendtoDeck(e:GetHandler(),nil,1,REASON_COST)
end
function RS.s_tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local n=Duel.GetFieldGroup(tp,32,0):Filter(Card.IsSetCard,nil,0x564):Filter(Card.IsFaceup,nil):Filter(Card.IsType,nil,1):GetClassCount(Card.GetCode)
	if chk==0 then return n>0 end
end
function RS.s_op2(e,tp,eg,ep,ev,re,r,rp)
	local n=Duel.GetFieldGroup(tp,32,0):Filter(Card.IsSetCard,nil,0x564):Filter(Card.IsFaceup,nil):Filter(Card.IsType,nil,1):GetClassCount(Card.GetCode)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DRAW_COUNT)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTargetRange(1,0)
	e1:SetValue(n)
	e1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
	Duel.RegisterEffect(e1,tp)
end
if not cm then return end
---------------------------------------------
function cm.initial_effect(c)
	local e1,e2 = RS.initial(c,m,cm.op)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp,c)
	local g=c:GetColumnGroup()
	--g:AddCard(c)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.BreakEffect()
		if not (Duel.SendtoDeck(g,nil,2,REASON_EFFECT)>0) then return end
		Duel.Damage(1-tp,#g*1500,REASON_EFFECT)
	end
end