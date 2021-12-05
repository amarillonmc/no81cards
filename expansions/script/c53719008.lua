local m=53719008
local cm=_G["c"..m]
cm.name="吞天铠 辉华双翅"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,m+50)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(cm.tgcost)
	e2:SetTarget(cm.tgtg)
	e2:SetOperation(cm.tgop)
	c:RegisterEffect(e2)
end
function cm.chfilter(c)
	return c:IsRace(RACE_INSECT) and c:IsFaceup() and c:IsLevelAbove(1) and not (c:IsLevel(2) and c:IsType(TYPE_TUNER))
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.chfilter(chkc) end
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(cm.chfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.chfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_TUNER)
		tc:RegisterEffect(e2)
	end
end
function cm.splimit(e,c)
	return not c:IsRace(RACE_INSECT) and c:IsLocation(LOCATION_EXTRA)
end
function cm.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function cm.cfilter(c)
	return c:IsRace(RACE_INSECT) and c:IsAbleToRemoveAsCost()
end
function cm.filter(c)
	return c:IsLevelBelow(2) and c:IsRace(RACE_INSECT) and c:IsAbleToGrave()
end
function cm.fselect(g,e)
	return g:IsContains(e:GetHandler())
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return c:IsAbleToRemoveAsCost()
			and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_GRAVE,0,1,nil)
			and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil)
	end
	local ct=math.min(2,Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil):GetClassCount(Card.GetCode))
	local g=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=g:SelectSubGroup(tp,cm.fselect,false,1,ct,e)
	local rc=Duel.Remove(rg,POS_FACEUP,REASON_COST)
	e:SetLabel(rc)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,rc,tp,LOCATION_DECK)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil)
	local ct=e:GetLabel()
	if dg:GetClassCount(Card.GetCode)<ct then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=dg:SelectSubGroup(tp,aux.dncheck,false,ct,ct)
	Duel.SendtoGrave(g,REASON_EFFECT)
end
