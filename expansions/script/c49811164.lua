--G－ゲットレディ
local m=49811164
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(49811164,0)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.condition1)
	e1:SetCost(cm.cost1)
	e1:SetCountLimit(1,49811164)
	e1:SetTarget(cm.target1)
	e1:SetOperation(cm.activate1)
	c:RegisterEffect(e1)
	--Grave Damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(49811164,1)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,49811164)
	e2:SetCost(cm.cost2)
	e2:SetTarget(cm.destg)
	e2:SetOperation(cm.desop)
	c:RegisterEffect(e2)
end
function cm.dmcostfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and c:IsLevelBelow(7) and c:IsRace(RACE_INSECT) and c:IsAttribute(ATTRIBUTE_EARTH) and c:GetTextAttack()>0
end
function cm.ffselect(g)
	return g:GetClassCount(Card.GetOriginalCode)==#g
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100) 
	if chk==0 then return true end
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 and e:GetLabel()==100 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(cm.dmcostfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.GetMatchingGroup(cm.dmcostfilter,tp,LOCATION_GRAVE,0,nil)
	local tg=g:SelectSubGroup(tp,cm.ffselect,false,1,g:GetCount())
	local tc=tg:GetFirst()
	local toatk=0
	while tc do
		if tc:GetTextAttack()>0 then toatk=toatk+tc:GetTextAttack() end
		tc=tg:GetNext()
	end
	toatk = toatk/2
	tg:AddCard(e:GetHandler())
	Duel.Remove(tg,POS_FACEUP,REASON_COST)
	e:SetLabel(toatk)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,toatk)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local toatk=e:GetLabel()
	if toatk then
		Duel.Damage(1-tp,toatk,REASON_EFFECT)
	end
end
function cm.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function cm.cfilter1(c)
	return c:IsDiscardable()
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.cfilter1,tp,LOCATION_HAND,0,c)
	if chk==0 then return g:GetCount()>0 end
	Duel.DiscardHand(tp,cm.cfilter1,1,1,REASON_COST+REASON_DISCARD,c)
end
function cm.fselect(g)
	return aux.dncheck(g) and g:GetSum(Card.GetLevel)<=8
end
function cm.filter(c,e,tp)
	return c:IsRace(RACE_INSECT) and c:IsAttribute(ATTRIBUTE_EARTH)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
		and c:IsLevelBelow(8)
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft<=0 or not Duel.IsPlayerCanSpecialSummonCount(tp,1) then return false end
		if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		local mg=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil,e,tp)
		return mg:GetCount()>0
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.activate1(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local mg=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil,e,tp)
	if ft>0 and Duel.IsPlayerCanSpecialSummonCount(tp,1) and mg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local ct=math.min(mg:GetClassCount(Card.GetCode),ft)
		local dg=mg:SelectSubGroup(tp,cm.fselect,false,1,ct)
		local tc=dg:GetFirst()
		local c=e:GetHandler()
		while tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			local fid=e:GetHandler():GetFieldID()
			tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1,fid)
			local e3=Effect.CreateEffect(c)
			e3:SetDescription(49811164,2)
			e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e3:SetCode(EVENT_PHASE+PHASE_END)
			e3:SetCountLimit(1)
			e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e3:SetLabel(fid)
			e3:SetLabelObject(tc)
			e3:SetCondition(cm.thcon)
			e3:SetOperation(cm.thop)
			Duel.RegisterEffect(e3,tp)
			tc=dg:GetNext()
		end
		Duel.SpecialSummonComplete()
	end
	local ee=Effect.CreateEffect(e:GetHandler())
	ee:SetType(EFFECT_TYPE_FIELD)
	ee:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	ee:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	ee:SetTargetRange(1,0)
	ee:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(ee,tp)
end

function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(m)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(e:GetLabelObject(),nil,REASON_EFFECT)
end