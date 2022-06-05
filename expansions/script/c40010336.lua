--凝视深渊的龙皇 卢亚德
local m=40010336
local cm=_G["c"..m]
cm.named_with_DragWizard=1
function cm.Crimsonmoon(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_DragWizard
end
function cm.initial_effect(c)
	--Effect 1
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e11:SetCode(EFFECT_CHANGE_LEVEL)
	e11:SetRange(LOCATION_DECK+LOCATION_GRAVE)
	e11:SetValue(1)
	c:RegisterEffect(e11)
	--Effect 2  
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(cm.val)
	c:RegisterEffect(e2)
	--Effect 3 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
--Effect 1
--Effect 2
function cm.cfilter(c)
	return c:IsLevel(1) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
 end
function cm.val(e,c)
	return Duel.GetMatchingGroupCount(cm.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE+LOCATION_GRAVE,0,nil)*500
end
--Effect 3 
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function cm.filter(c)
	return  c:IsLevel(1) and c:IsAbleToDeckAsCost()
end
function cm.filter1(c,e,tp)
	return c:IsLevel(1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_GRAVE,0,nil)
	local cg=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_DECK,0,nil,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local c=e:GetHandler()
	if chk==0 then
		if e:GetLabel()==1 then
			return rg:GetCount()>0 and cg:GetCount()>0 and ft>0
		else
			return false
		end
	end
	local a=rg:GetCount()
	local b=cg:GetClassCount(Card.GetCode)
	if b>ft then b=ft end 
	if rg:GetCount()>b then a=b end 
	local mg=rg:Select(tp,1,a,nil)
	Duel.SendtoDeck(mg,nil,SEQ_DECKSHUFFLE,REASON_COST)
	e:SetLabel(1,mg:GetCount())
	if mg:GetCount()>=4 then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,1))
		Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(m,1))
		Duel.SetTargetParam(mg:GetCount())
	else
		Duel.SetTargetParam(0)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,mg:GetCount(),tp,LOCATION_DECK)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local label,ct=e:GetLabel()
	local num=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if ft<=0 or ct==0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	if ft>=ct then ft=ct end
	local g=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_DECK,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,ft)
	if sg and #sg>0 then
		if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)~=0 then
			if num>0 then
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_FIELD)
				e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e2:SetCode(EFFECT_CANNOT_ACTIVATE)
				e2:SetTargetRange(0,1)
				e2:SetValue(1)
				e2:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e2,tp)
			end
		end
	end
end