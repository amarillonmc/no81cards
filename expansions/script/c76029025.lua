--辉翼天骑 终末逐魇
local m=76029025
local cm=_G["c"..m]
function cm.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.condition)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.postg)
	e1:SetOperation(cm.posop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,m)
	e3:SetCost(aux.bfgcost)
	e3:SetCondition(cm.descon)
	e3:SetTarget(cm.postg2)
	e3:SetOperation(cm.posop2)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
c76029025.named_with_Kazimierz=true 
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp 
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) then
		Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
	end
end
function cm.filter(c,tp)
	return c:IsFaceup() and c.named_with_Kazimierz and c:IsCanTurnSet() and Duel.GetMatchingGroupCount(Card.IsAbleToGrave,tp,LOCATION_MZONE,0,c)==Duel.GetMatchingGroupCount(nil,tp,LOCATION_MZONE,0,c)
end
function cm.filter2(c,e,tp)
	return c.named_with_Kazimierz and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function cm.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() then
	Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE) 
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,tc)
	Duel.SendtoGrave(g,REASON_EFFECT)
	local g1=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if g1:GetCount()<=0 or ft<=0 then return end 
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g1:Select(tp,ft,ft,nil)
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
	Duel.BreakEffect()
	local xg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)  
	Duel.ShuffleSetCard(xg)
	local xc=xg:Select(1-tp,1,1,nil):GetFirst()
	Duel.ConfirmCards(0,xc)
	if xc~=tc then 
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
	Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end 
	else 
	Duel.SendtoGrave(xg,REASON_EFFECT)
	end
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetTargetRange(1,0)
	e2:SetTarget(cm.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function cm.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_DARK)
end
function cm.cfilter4(c,tp)
	return c:IsFaceup() and c.named_with_Kazimierz and c:IsControler(tp)
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter4,1,nil,tp)
end
function cm.filter5(c)
	return c:IsFaceup() and c:IsCanChangePosition()
end
function cm.postg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter5,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,0)
end
function cm.posop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local tc=Duel.SelectTarget(tp,cm.filter5,tp,0,LOCATION_ONFIELD,1,1,nil):GetFirst()
	Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE) 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e2)
end



