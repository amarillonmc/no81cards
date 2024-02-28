--诡雷战队 指挥官
--21.04.22
local cm,m=GetID()
function cm.initial_effect(c)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(function() return not pnfl_adjusting end)
	e1:SetOperation(cm.adjustop)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.con)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(cm.con2)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetCondition(cm.poscon)
	e4:SetTarget(cm.postg)
	e4:SetOperation(cm.posop)
	c:RegisterEffect(e4)
end
function cm.eqfilter(c)
	return c:GetFlagEffect(m)~=0
end
function cm.eqlimit(e,c)
	return e:GetOwner()==c
end
function cm.equipfd(c,tp,tc)
	if tc:IsPosition(POS_FACEUP) then return Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEDOWN,false) end
	if not Duel.Equip(tp,tc,c,false) then return false end
	--Add Equip limit
	tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(cm.eqlimit)
	tc:RegisterEffect(e1)
	return true
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	if pnfl_adjusting then return end
	local phase=Duel.GetCurrentPhase()
	local c=e:GetHandler()
	if not ((phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL or c:IsStatus(STATUS_BATTLE_DESTROYED)) and Duel.IsPlayerCanSSet(tp) and c:IsLocation(LOCATION_MZONE) and not c:GetEquipGroup():IsExists(cm.eqfilter,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.GetMatchingGroupCount(nil,tp,0,LOCATION_DECK,nil)>0 then
		Duel.Hint(HINT_CARD,0,m)
		local tc=Duel.GetMatchingGroup(nil,tp,0,LOCATION_DECK,nil):GetMaxGroup(Card.GetSequence):GetFirst()
		Duel.DisableShuffleCheck()
		pnfl_adjusting=true
		if tc:IsForbidden() then
			Duel.DiscardDeck(1-tp,1,REASON_RULE)
			pnfl_adjusting=false
			cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
		elseif cm.equipfd(c,tp,tc) then
			Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
			pnfl_adjusting=false
			Duel.Readjust()
		end
		pnfl_adjusting=false
	end
	pnfl_adjusting=false
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,11451556)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,11451556)
end
function cm.filter(c)
	return c:IsSetCard(0x97e) and (c:IsSynchroSummonable(nil) or c:IsLinkSummonable(nil) or c:IsSummonable(true,nil))
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=5 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_EXTRA,0,1,nil) end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
	if ct+ct2<5 then return end
	if ct>5 then ct=5 end
	local t={}
	for ac=ct,0,-1 do
		if ct2>=5-ac then table.insert(t,ac) end
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
	ac=Duel.AnnounceNumber(tp,table.unpack(t))
	if ac>0 then Duel.SortDecktop(tp,tp,ac) end
	if ac<5 then Duel.SortDecktop(tp,1-tp,5-ac) end
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_EXTRA,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if not tc then return end
	if tc:IsSynchroSummonable(nil,mg) then
		Duel.SynchroSummon(tp,tc,nil)
	elseif tc:IsLinkSummonable(nil) then
		Duel.LinkSummon(tp,tc,nil)
	else
		Duel.Summon(tp,tc,true,nil)
	end
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x97e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function cm.poscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function cm.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
end
function cm.posop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end