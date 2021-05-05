--伏魔忍龙 魔军天武
function c40006907.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_LINK),3)  
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40006907,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,40006907)
	e2:SetCost(c40006907.setcost)
	e2:SetTarget(c40006907.settg)
	e2:SetOperation(c40006907.setop)
	c:RegisterEffect(e2)
	--disable fiel
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE_FIELD)
	e3:SetProperty(EFFECT_FLAG_REPEAT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(c40006907.disop)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_SZONE,0)
	e4:SetTarget(c40006907.eftg2)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
end
function c40006907.cfilter(c)
	return c:IsSetCard(0x61) and c:IsAbleToGraveAsCost()
end
function c40006907.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40006907.cfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c40006907.cfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c40006907.chlimit(e,ep,tp)
	return tp==ep
end
function c40006907.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetChainLimit(c40006907.chlimit)
end
function c40006907.setop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,1)
	e1:SetValue(c40006907.aclimit)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c40006907.aclimit(e,re,tp)
	return not (re:GetHandler():IsSetCard(0x61) or re:GetHandler():IsSetCard(0x2b)) and not re:GetHandler():IsImmuneToEffect(e)
end
function c40006907.eftg2(e,c)
	return c:IsFaceup() and c:IsSetCard(0x61) and not c:IsType(TYPE_MONSTER)
end
function c40006907.disop(e,tp)
	local c=e:GetHandler()
	return c:GetColumnZone(LOCATION_SZONE)
end