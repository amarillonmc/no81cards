--絮雨·青宵案收藏-月丛云花风
local cm,m,o=GetID()
function cm.initial_effect(c)
	--pendulum summon
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c)
	--add code
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ADD_CODE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(79029350)
	c:RegisterEffect(e2)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(cm.splimit1)
	c:RegisterEffect(e2)  
	--ex p
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.pencost)
	e1:SetOperation(cm.penop)
	c:RegisterEffect(e1)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m+20000000)
	e1:SetTarget(cm.settg)
	e1:SetOperation(cm.setop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e2:SetCountLimit(1,m+30000000)
	--e2:SetCost(cm.zdiscost)
	e2:SetTarget(cm.zdistg)
	e2:SetOperation(cm.zdisop)
	c:RegisterEffect(e2)
end
function cm.splimit1(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0xa900) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function cm.cfil(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost()
end
function cm.pencost(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,c,e,tp) end
	local g=Duel.SelectMatchingCard(tp,cm.cfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,c,e,tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end 
function cm.penop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_PENDULUM_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetCountLimit(1,m+10000000)
	e1:SetValue(aux.TRUE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp) 
end
function cm.setfilter1(c,tp)
	return c:IsSetCard(0x1901) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
		and Duel.IsExistingMatchingCard(cm.setfilter2,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function cm.setfilter2(c,code)
	return c:IsSetCard(0x1901) and not c:IsCode(code) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) and Duel.CheckLocation(tp,LOCATION_PZONE,1)
		and Duel.IsExistingMatchingCard(cm.setfilter1,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) or not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g1=Duel.SelectMatchingCard(tp,cm.setfilter1,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc1=g1:GetFirst()
	if not tc1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g2=Duel.SelectMatchingCard(tp,cm.setfilter2,tp,LOCATION_DECK,0,1,1,nil,tc1:GetCode())
	local tc2=g2:GetFirst()
	if Duel.MoveToField(tc1,tp,tp,LOCATION_PZONE,POS_FACEUP,false) then
		if Duel.MoveToField(tc2,tp,tp,LOCATION_PZONE,POS_FACEUP,false) then
			Duel.Recover(tp,1000,REASON_EFFECT)
			tc2:SetStatus(STATUS_EFFECT_ENABLED,true)
		end
		tc1:SetStatus(STATUS_EFFECT_ENABLED,true)
	end
end
function cm.filterz(c)
	return c:IsAbleToDeck()
end
function cm.zdistg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filterz,tp,0,LOCATION_GRAVE+LOCATION_REMOVED,1,nil) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
	--Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	--local g=Duel.SelectMatchingCard(tp,cm.filterz,tp,0,LOCATION_GRAVE+LOCATION_REMOVED,1,1,nil)
	--Duel.SetTargetCard(g)
	--Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,1-tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function cm.zdisop(e,tp,eg,ep,ev,re,r,rp)
	--local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tc=Duel.SelectMatchingCard(tp,cm.filterz,tp,0,LOCATION_GRAVE+LOCATION_REMOVED,1,1,nil):GetFirst()
	if Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_DECK) then
	Debug.Message("睡吧。愿所有人都能在雨声里做个好梦。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029350,2))
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e1:SetTarget(cm.distgx)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_EVENT+RESET_CHAIN)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetCondition(cm.disconx)
		e2:SetOperation(cm.disopx)
		e2:SetLabelObject(tc)
		e2:SetReset(RESET_EVENT+RESET_CHAIN)
		Duel.RegisterEffect(e2,tp)
		if Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_PZONE,POS_FACEUP,false) then
			e:GetHandler():SetStatus(STATUS_EFFECT_ENABLED,true)
		end
	end
end
function cm.distgx(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function cm.disconx(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function cm.disopx(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end