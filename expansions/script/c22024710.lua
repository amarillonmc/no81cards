--人王 盖提亚
function c22024710.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c22024710.hspcon)
	e1:SetTarget(c22024710.hsptg)
	e1:SetOperation(c22024710.hspop)
	c:RegisterEffect(e1)
	--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetOperation(c22024710.sumsuc)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SET_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c22024710.atkcon)
	e3:SetValue(0)
	c:RegisterEffect(e3)
	--def
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SET_DEFENSE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c22024710.atkcon)
	e4:SetValue(0)
	c:RegisterEffect(e4)
end
function c22024710.hspfilter(c,tp)
	return c:IsCode(22024690) and c:IsAbleToRemoveAsCost()
end
function c22024710.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c22024710.hspfilter,tp,LOCATION_GRAVE,0,1,nil,tp)
end
function c22024710.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c22024710.hspfilter,tp,LOCATION_GRAVE,0,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function c22024710.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Remove(g,POS_FACEUP,REASON_SPSUMMON)
end
function c22024710.sumsuc(e,tp,eg,ep,ev,re,r,rp)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_PHASE+PHASE_END)
		e3:SetCountLimit(1)
		e3:SetReset(RESET_PHASE+PHASE_END)
		e3:SetOperation(c22024710.tgop)
		Duel.RegisterEffect(e3,tp)
end
function c22024710.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(tp,0)
end

function c22024710.atkfilter(c)
	return c:IsFaceup() and c:IsCode(22020000)
end
function c22024710.atkcon(e)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(c22024710.atkfilter,c:GetControler(),0,LOCATION_ONFIELD,1,nil)
end
