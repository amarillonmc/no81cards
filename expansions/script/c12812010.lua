--恋爱头脑战-子安燕
local m=12812010
local cm=_G["c"..m]
function c12812010.initial_effect(c)
	aux.EnablePendulumAttribute(c)
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.psplimit)
	c:RegisterEffect(e1)
	--special summon
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TODECK)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,12812110)
	e2:SetTarget(cm.sctg)
	e2:SetOperation(cm.scop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_HAND+LOCATION_EXTRA)
	e2:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e3:SetCondition(cm.spcon)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
	--todeck and special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,m)
	e4:SetTarget(cm.tntg)
	e4:SetOperation(cm.tnop)
	c:RegisterEffect(e4)
end
function cm.psplimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0xa73) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
--效果1
function cm.copyfilter(c)
	return c:IsType(TYPE_PENDULUM) and not c:IsType(TYPE_TOKEN) and c:IsFaceup() and c:IsSetCard(0xa73)
end
function cm.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chkc then return chkc:IsLocation(LOCATION_REMOVED) and cm.copyfilter(chkc) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(cm.copyfilter,tp,LOCATION_REMOVED,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cm.copyfilter,tp,LOCATION_REMOVED,0,1,1,c)
end
function cm.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc  and c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) 
    and tc:IsFaceup()  and Duel.SendtoDeck(tc,tp,2,REASON_EFFECT)>0 then
        local code=tc:GetOriginalCodeRule()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LSCALE)
		e1:SetValue(tc:GetLeftScale())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_RSCALE)
		e2:SetValue(tc:GetRightScale())
		c:RegisterEffect(e2)
        local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetCode(EFFECT_CHANGE_CODE)
		e3:SetValue(code)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e3)
        c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD,1)
	end
end
--效果2
--灵摆效果
function cm.spcostfilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0xa73) and c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end
function cm.spcostfilter1(c)
	return c:IsAbleToRemoveAsCost() and c:IsCode(12812005)
end
function cm.spcostfilter2(g)
	return g:IsExists(Card.IsCode,1,nil,12812005)
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetMZoneCount(tp)<=0 then return false end
	local g=Duel.GetMatchingGroup(cm.spcostfilter,tp,LOCATION_EXTRA,0,e:GetHandler())
	return  g:IsExists(Card.IsCode,1,nil,12812005)
end

function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(cm.spcostfilter,tp,LOCATION_EXTRA,0,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroup(tp,cm.spcostfilter2,false,3,3,g)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
--效果3
function cm.tnfilter(c)
	return c:IsFaceup() and not c:IsType(TYPE_TUNER) and c:IsSetCard(0xa73)
end
function cm.tntg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.tnfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.tnfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cm.tnfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.tnop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(TYPE_TUNER)
		tc:RegisterEffect(e1)
	end
end