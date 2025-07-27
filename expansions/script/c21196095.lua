--皇庭学院的会长
local m=21196095
local cm=_G["c"..m]
function cm.initial_effect(c)
	if not imperial_court then
		imperial_court=true
		Duel.LoadScript("c21196001.lua")
		in_count.card = c
		local ce1=Effect.CreateEffect(c)
		ce1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ce1:SetCode(EVENT_PHASE+PHASE_END)
		ce1:SetCountLimit(1)
		ce1:SetOperation(function(e)
			for tp = 0,1 do
				if not Duel.IsPlayerAffectedByEffect(tp,21196000) then
					in_count.reset(tp)
				end
			end
		end)
		Duel.RegisterEffect(ce1,0)
	end
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),2)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_GRAVE_ACTION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)	
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.cost2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end
function cm.q(c,tp)
	return c:IsSetCard(0x5919) and c:IsType(TYPE_QUICKPLAY) and c:IsAbleToDeck() and Duel.IsExistingMatchingCard(cm.w,tp,1,0,1,nil,code)
end
function cm.w(c,code)
	return c:IsSetCard(0x5919) and c:IsType(TYPE_QUICKPLAY) and c:IsSSetable() and not c:IsCode(code)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(cm.q,tp,0x10,0,1,nil,tp) end
	Duel.Hint(3,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cm.q,tp,0x10,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,tp,0x10)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)>0 and tc:IsLocation(1) and Duel.IsExistingMatchingCard(cm.w,tp,1,0,1,nil,tc:GetCode()) then
	Duel.BreakEffect()
	Duel.Hint(3,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,cm.w,tp,1,0,1,1,nil,tc:GetCode())
		if #g>0 then
		Duel.SSet(tp,g)
		end
	end
end
function cm.e(c)
	return c:IsSetCard(0x5919) and c:IsType(TYPE_QUICKPLAY) and c:IsAbleToDeckAsCost()
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.e,tp,0x10+12,0,1,nil) end
	Duel.Hint(3,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.e,tp,0x10+12,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
	e:SetLabelObject(g:GetFirst())
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return in_count[tp] < 8 end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	if in_count[tp] >= 8 then return end
	in_count.add(tp,2)
	local tc=e:GetLabelObject()
	if tc:CheckActivateEffect(true,true,false)~=nil and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
	Duel.BreakEffect()
	local te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(true,true,true)
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end