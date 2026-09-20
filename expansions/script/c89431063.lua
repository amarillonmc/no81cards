--夢吾寄零·霧周途
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,s.fmaterial1,s.fmaterial2,true)
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_SINGLE)
	e01:SetCode(EFFECT_SPSUMMON_CONDITION)
	e01:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e01:SetRange(LOCATION_EXTRA)
	e01:SetValue(aux.fuslimit)
	c:RegisterEffect(e01)
	local e02=Effect.CreateEffect(c)
	e02:SetType(EFFECT_TYPE_FIELD)
	e02:SetCode(EFFECT_SPSUMMON_PROC)
	e02:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e02:SetRange(LOCATION_EXTRA)
	e02:SetCondition(s.condition0)
	e02:SetTarget(s.target0)
	e02:SetOperation(s.operation0)
	c:RegisterEffect(e02)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE+LOCATION_SZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.condition)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.operation1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetCountLimit(1,id+o)
	e2:SetTarget(s.target2)
	e2:SetValue(s.value)
	e2:SetOperation(s.operation2)
	c:RegisterEffect(e2)
end
s.material_type=TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK
function s.fmaterial1(c)
	return c:IsSetCard(0xa709) and bit.band(c:GetOriginalType(),TYPE_FUSION)~=0
end
function s.fmaterial2(c)
	return bit.band(c:GetOriginalType(),TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK)~=0
end
function s.filter01(c,tp,fc)
	return c:IsSetCard(0xa709) and bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0
		and c:IsFaceup() and c:IsAbleToGraveAsCost()
		and c:IsCanBeFusionMaterial(fc,SUMMON_TYPE_SPECIAL) and Duel.GetLocationCountFromEx(tp,tp,c,fc)>0
		and Duel.IsExistingMatchingCard(s.filter02,c:GetControler(),LOCATION_ONFIELD,0,1,c,c:GetControler(),fc)
end
function s.filter02(c,tp,fc)
	return bit.band(c:GetOriginalType(),TYPE_FUSION)~=0
		and c:IsFaceup() and c:IsAbleToGraveAsCost()
		and c:IsCanBeFusionMaterial(fc,SUMMON_TYPE_SPECIAL)
end 
function s.condition0(e,c)
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(s.filter01,c:GetControler(),LOCATION_ONFIELD,0,1,nil,c:GetControler(),c)
end
function s.target0(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g1=Duel.GetMatchingGroup(s.filter01,tp,LOCATION_ONFIELD,0,nil,tp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc1=g1:SelectUnselect(nil,tp,false,true,1,1)
	if tc1 then
		local g2=Duel.GetMatchingGroup(s.filter02,tp,LOCATION_ONFIELD,0,tc1,tp,c)
		local tc2=g2:SelectUnselect(nil,tp,false,true,1,1)
		if tc2 then
			local mg=Group.__add(tc1,tc2)
			mg:KeepAlive()
			e:SetLabelObject(mg)
			return true
		end
		return false
	else return false end
end
function s.operation0(e,tp,eg,ep,ev,re,r,rp,c)
	local sg=e:GetLabelObject()
	c:SetMaterial(sg)
	Duel.SendtoGrave(sg,REASON_SPSUMMON|REASON_MATERIAL)
	sg:DeleteGroup()
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()~=PHASE_DRAW or not r==REASON_RULE)
		and (e:GetHandler():IsOnField() or e:GetHandler():GetType()==TYPE_SPELL+TYPE_CONTINUOUS)
end
function s.filter1(c)
	return c:IsAbleToGraveAsCost() and c:GetSequence()<5
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function s.filter2(c,code)
	return c:IsCode(code) and (c:IsFaceup() or not c:IsOnField())
end
function s.filter3(c,tp)
	return c:IsSetCard(0xa709) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
		and not Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,c:GetCode())
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter3,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,s.filter3,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc and Duel.SSet(tp,tc)~=0 then
		if tc:IsType(TYPE_QUICKPLAY) then
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(id,1))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
		if tc:IsType(TYPE_TRAP) then
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(id,1))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end
function s.filter4(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xa709) and c:IsOnField() and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtra() and eg:IsExists(s.filter4,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function s.value(e,c)
	return s.filter4(c,e:GetHandlerPlayer())
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end