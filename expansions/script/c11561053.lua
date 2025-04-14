--亡灵炼狱 忍 
local m=11561053
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableCounterPermit(0x1)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c11561053.lcheck)
	c:EnableReviveLimit()
	--count
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c11561053.ctcon)
	e1:SetTarget(c11561053.cttg)
	e1:SetOperation(c11561053.ctop)
	c:RegisterEffect(e1)
	--tokn
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11561053,0))
	e2:SetCategory(CATEGORY_COUNTER+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,11561053)
	e2:SetCost(c11561053.tkcost)
	e2:SetTarget(c11561053.tktg)
	e2:SetOperation(c11561053.tkop)
	c:RegisterEffect(e2)
	--sp
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11561053,1))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,11561053)
	e3:SetCost(c11561053.tkcost)
	e3:SetTarget(c11561053.dsptg)
	e3:SetOperation(c11561053.dspop)
	c:RegisterEffect(e3)
	
end
function c11561053.desfilter(c,tp)
	return c:IsFaceup() and Duel.GetMZoneCount(tp,c)>0
end
function c11561053.spfilter(c,e,tp)
	return c:IsRace(RACE_ZOMBIE+RACE_FIEND) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11561053.dsptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(c11561053.desfilter,tp,LOCATION_ONFIELD,0,1,nil,tp)
		and Duel.IsExistingTarget(c11561053.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c11561053.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectTarget(tp,c11561053.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g2,1,0,0)
	e:SetLabelObject(g1:GetFirst())
end
function c11561053.dspop(e,tp,eg,ep,ev,re,r,rp)
	local tc1,tc2=Duel.GetFirstTarget()
	if tc1~=e:GetLabelObject() then tc1,tc2=tc2,tc1 end
	if tc1:IsControler(tp) and tc1:IsRelateToEffect(e) and Duel.Destroy(tc1,REASON_EFFECT)>0 and tc2:IsRelateToEffect(e) then

	if tc2 and Duel.SpecialSummonStep(tc2,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc2:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc2:RegisterEffect(e2,true)
	end
	Duel.SpecialSummonComplete()

	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c11561053.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

function c11561053.tkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x1,1,REASON_COST)
end
function c11561053.rtgfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_ZOMBIE+RACE_FIEND) and c:IsType(TYPE_MONSTER)
end
function c11561053.tktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c11561053.rtgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c11561053.rtgfilter,tp,LOCATION_REMOVED,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,11561054,0,TYPES_TOKEN_MONSTER,0,0,3,RACE_ZOMBIE,ATTRIBUTE_LIGHT) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c11561053.rtgfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c11561053.tkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,11561054,0,TYPES_TOKEN_MONSTER,0,0,3,RACE_ZOMBIE,ATTRIBUTE_LIGHT) then
		local token=Duel.CreateToken(tp,11561054)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
end
function c11561053.splimit(e,c)
	return not c:IsRace(RACE_ZOMBIE+RACE_FIEND)
end
function c11561053.lcheck(g,lc)
	return g:IsExists(Card.IsLinkRace,1,nil,RACE_ZOMBIE+RACE_FIEND)
end
function c11561053.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetHandler():GetMaterialCount()>0
end
function c11561053.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,e:GetHandler():GetMaterialCount(),0,0x1)
end
function c11561053.ctop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x1,e:GetHandler():GetMaterialCount())
	end
end
