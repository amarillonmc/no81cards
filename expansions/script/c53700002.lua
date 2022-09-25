--苏我屠自古
function c53700002.initial_effect(c)
	aux.AddCodeList(c,53700001)
	c:EnableReviveLimit()
	--token
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(53700002,6))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c53700002.tkcost)
	e1:SetTarget(c53700002.tktg)
	e1:SetOperation(c53700002.tkop)
	c:RegisterEffect(e1)
	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c53700002.regcon)
	e2:SetOperation(c53700002.regop)
	c:RegisterEffect(e2)
	--cannot special summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetValue(aux.ritlimit)
	c:RegisterEffect(e3)
end
function c53700002.mat_filter(c)
	return c:IsCode(53700001)
end
function c53700002.tkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c53700002.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>2
		and Duel.IsPlayerCanSpecialSummonMonster(tp,53700001,0,TYPES_TOKEN_MONSTER,0,0,2,RACE_ZOMBIE,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,3,0,0)
end
function c53700002.tkop(e,tp,eg,ep,ev,re,r,rp)
	local ft=math.min((Duel.GetLocationCount(tp,LOCATION_MZONE)),3)
	if ft>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,53700001,0,TYPES_TOKEN_MONSTER,0,0,2,RACE_ZOMBIE,ATTRIBUTE_LIGHT) then
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		local ct=1
		if ft>1 then
			local num={}
			local i=1
			while i<=ft do
				num[i]=i
				i=i+1
			end
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(53700002,7))
			ct=Duel.AnnounceNumber(tp,table.unpack(num))
		end
		repeat
			local token=Duel.CreateToken(tp,53700001)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
			ct=ct-1
		until ct==0
		Duel.SpecialSummonComplete()
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(function(e,c)return not (c:IsCode(53700001) or aux.IsCodeListed(c,53700001))end)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e2,tp)
end
function c53700002.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c53700002.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetMaterialCount()<=3 then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(53700002,0))
		e1:SetCategory(CATEGORY_REMOVE)
		e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e1:SetType(EFFECT_TYPE_IGNITION)
		e1:SetCountLimit(1)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCondition(c53700002.con)
		e1:SetTarget(c53700002.rmtg)
		e1:SetOperation(c53700002.rmop)
		c:RegisterEffect(e1)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(53700002,3))
		local e2=e1:Clone()
		e2:SetType(EFFECT_TYPE_QUICK_O)
		e2:SetCode(EVENT_FREE_CHAIN)
		e2:SetHintTiming(0,TIMING_END_PHASE+TIMING_TOGRAVE)
		e2:SetCondition(c53700002.con2)
		e2:SetCost(c53700002.cost)
		c:RegisterEffect(e2)
	end
	if c:GetMaterialCount()<=2 then
		local e3=Effect.CreateEffect(c)
		e3:SetCategory(CATEGORY_DESTROY)
		e3:SetDescription(aux.Stringid(53700002,1))
		e3:SetType(EFFECT_TYPE_IGNITION)
		e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e3:SetCountLimit(1)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCondition(c53700002.con)
		e3:SetTarget(c53700002.target)
		e3:SetOperation(c53700002.operation)
		c:RegisterEffect(e3)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(53700002,4))
		local e4=e3:Clone()
		e4:SetType(EFFECT_TYPE_QUICK_O)
		e4:SetCode(EVENT_FREE_CHAIN)
		e4:SetHintTiming(0,TIMING_END_PHASE+TIMING_MSET+TIMING_SUMMON+TIMING_SPSUMMON)
		e4:SetCondition(c53700002.con2)
		e4:SetCost(c53700002.cost)
		c:RegisterEffect(e4)
	end
	if c:GetMaterialCount()==1 then
		c:RegisterFlagEffect(53700002,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(53700002,5))
	end
end
function c53700002.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(53700002)==0 or Duel.GetTurnPlayer()==tp
end
function c53700002.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(53700002)>0 and Duel.GetTurnPlayer()==1-tp
end
function c53700002.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c53700002.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_GRAVE and chkc:GetControler()~=tp and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,1-tp,LOCATION_GRAVE)
end
function c53700002.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c53700002.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c53700002.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsControler(1-tp) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
