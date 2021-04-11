--波动场·二象
local m=11451457
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local deck=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local op=2
	if deck>1 and Duel.GetDecktopGroup(tp,2):FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==2 then
		op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1),aux.Stringid(m,2))
	elseif deck>0 and Duel.GetDecktopGroup(tp,1):FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==1 then
		op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))+1
	end
	if op~=2 then
		local num=0
		if op==0 then
			local d1,d2=Duel.TossDice(tp,2)
			num=d1+d2
		else num=Duel.TossDice(tp,1) end
		if Duel.GetDecktopGroup(tp,num):FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==num then 
			local g=Duel.GetDecktopGroup(tp,num)
			Duel.DisableShuffleCheck()
			e:SetLabel(Duel.Remove(g,POS_FACEDOWN,REASON_COST))
		end
	end
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetLabel()>0 then Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_DECK) end
end
function cm.filter(c,num)
	return c:IsRace(RACE_PSYCHO) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsLevel(num)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp,chk)
	if e:GetHandler():IsRelateToEffect(e) and e:GetLabel()>0 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,e:GetLabel()) and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
		if sg:GetCount()>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function cm.filter2(c,e,tp,rc)
	if not (c:IsType(TYPE_SYNCHRO) and (rc%c:GetLevel()==0) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)) then return false end
	local eset={c:IsHasEffect(EFFECT_SPSUMMON_CONDITION)}
	for _,te in pairs(eset) do
		if te:GetValue()==0 then return true end
	end
	return false
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	if chk==0 then return rc>0 and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,rc) and Duel.GetLocationCountFromEx(tp)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local rc=Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	local g=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,rc)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end