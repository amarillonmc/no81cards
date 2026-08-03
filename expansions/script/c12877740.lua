-- 极彩色的时间囚徒
local s,id,o=GetID()
local KOISHI_CHECK=false
if Card.SetEntityCode then KOISHI_CHECK=true end
function s.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCost(s.hdcost)
	c:RegisterEffect(e0)
	--forbidden
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.con)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.cfilter(c,tp)
	return c:IsSetCard(0x5a73) and c:IsFaceupEx() and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function s.hdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)==0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp)
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function s.rmfilter(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)~=0 then return end
	local c=e:GetHandler()
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	c:SetHint(CHINT_CARD,ac)
	--forbidden
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_FORBIDDEN)
	e1:SetTargetRange(0xff,0xff)
	e1:SetTarget(s.bantg)
	e1:SetLabel(ac)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local g=Duel.GetMatchingGroup(s.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c,ac)
	if #g>0 then
		Duel.BreakEffect()
		Duel.HintSelection(g)
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
end
function s.bantg(e,c)
	local fcode=e:GetLabel()
	return c:IsOriginalCodeRule(fcode)
end