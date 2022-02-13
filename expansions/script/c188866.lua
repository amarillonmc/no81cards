local m=188866
local cm=_G["c"..m]
cm.name="对极的神意-德蒙"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.effcon)
	e1:SetTarget(cm.efftg)
	e1:SetOperation(cm.effop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,3))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.lvtg)
	e2:SetOperation(cm.lvop)
	c:RegisterEffect(e2)
end
function cm.effcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(function(c)return c:IsFaceup() and c:IsSetCard(0xcac)end,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function cm.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local g=Duel.GetMatchingGroup(function(c)return c:IsFaceup() and c:GetLevel()>0 end,tp,LOCATION_MZONE,0,nil)
		if #g==0 then return end
		local lv=g:GetSum(Card.GetLevel)
		local tgg=Duel.GetMatchingGroup(function(c)return c:IsSetCard(0xcac) and c:IsAbleToGrave()end,tp,LOCATION_DECK,0,nil)
		if (lv%2~=0 and Duel.SelectYesNo(tp,aux.Stringid(m,1))) or (lv%2==0 and #tgg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,2))) then
			Duel.BreakEffect()
			if lv%2~=0 then Duel.SetLP(1-tp,Duel.GetLP(1-tp)-500) else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local sg=tgg:Select(tp,1,1,nil)
				Duel.SendtoGrave(sg,REASON_EFFECT)
			end
		end
	end
end
function cm.filter(c)
	return c:IsFaceup() and c:GetLevel()>0
end
function cm.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.lvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:GetLevel()>0 then
		local sel=0
		local lv=1
		if tc:IsLevel(1) then sel=Duel.SelectOption(tp,aux.Stringid(m,4)) else sel=Duel.SelectOption(tp,aux.Stringid(m,4),aux.Stringid(m,5)) end
		if sel==1 then lv=-1 end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
