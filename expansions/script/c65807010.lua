--星光指引者 诺瓦尼亚
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,65807000)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,s.matfilter,1,1)
	--copy effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.copycon)
	e1:SetTarget(s.copytg)
	e1:SetOperation(s.copyop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SSET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetCost(s.cost)
	e2:SetTarget(s.target)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,id+1+EFFECT_COUNT_CODE_DUEL)
	e4:SetCondition(s.tscon)
	e4:SetCost(s.spcost)
	e4:SetTarget(s.tstg)
	e4:SetOperation(s.tsop)
	c:RegisterEffect(e4)
	local e3=e4:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,s.counterfilter)
end

function s.matfilter(c)
	return c:IsLinkCode(65807000) and c:GetEquipCount()>0
end

function s.counterfilter(c)
	return c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_LIGHT)
end

function s.copycon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function s.copyfilter(c,tp)
	return c:IsCode(65807000) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function s.copytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(s.copyfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,tp) end
end
function s.copyop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) or not Duel.IsExistingMatchingCard(s.copyfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local ec=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.copyfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,tp):GetFirst()
	if ec then
		Duel.Equip(tp,ec,c)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(s.eqlimit)
		e1:SetLabelObject(c)
		ec:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(500)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		ec:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_UPDATE_DEFENSE)
		ec:RegisterEffect(e3)
	end
end
function s.eqlimit(e,c)
	return c==e:GetLabelObject()
end


function s.costfilter(c)
	return c:IsFaceup() and (c:IsAbleToExtraAsCost() or c:IsAbleToHandAsCost()) and aux.IsCodeListed(c,65807000)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if chk==0 then
		if ft<0 then return false end
		if ft==0 then
			return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_SZONE,0,1,nil)
		else
			return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_ONFIELD,0,1,nil)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	if ft==0 then
		local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_SZONE,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_COST)
	else
		local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_COST)
	end
end
function s.filter(c)
	return aux.IsCodeListed(c,65807000) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	local c=e:GetHandler()
	if tc and Duel.SSet(tp,tc)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,0))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(id,0))
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
		e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3)
	end
end


function s.tscon(e,tp,eg,ep,ev,re,r,rp)
	if not re then return false end
	local rc=re:GetHandler()
	return rp==tp and r&REASON_COST>0 and aux.IsCodeListed(rc,65807000)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToExtraAsCost() and Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	Duel.RegisterEffect(e1,tp)
	Duel.SendtoDeck(c,nil,SEQ_DECKTOP,REASON_COST)
end
function s.splimit(e,c)
	return not (c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_LIGHT))
end
function s.filter2(c,e,tp)
	return aux.IsCodeListed(c,65807000) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.tstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function s.filter1(c,tp)
	return c:CheckUniqueOnField(tp) and not c:IsForbidden() and aux.IsCodeListed(c,65807000) and c:IsType(TYPE_MONSTER)
end
function s.tsop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and not tc:IsFacedown() and tc:IsRelateToEffect(e) and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.filter1),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,tp) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local ec=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter1),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,tp):GetFirst()
		if ec then
			Duel.Equip(tp,ec,c)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(s.eqlimit)
			e1:SetLabelObject(c)
			ec:RegisterEffect(e1)
		end
	end
end