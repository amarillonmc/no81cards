local m=53799222
local cm=_G["c"..m]
cm.name="业余魔法少女 SNNN"
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,5,3)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2 end)
	e1:SetCost(cm.cost)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
function cm.cfilter(c)
	return c:GetType()==TYPE_SPELL and not c:IsPublic()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,1,nil) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local sg=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	SNNM.SetPublicGroup(e:GetHandler(),sg,RESET_EVENT+RESETS_STANDARD,0)
	sg:GetFirst():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
	sg:GetFirst():CreateEffectRelation(e)
	e:SetLabelObject(sg:GetFirst())
end
function cm.op(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetLabelObject()
	if not tc or not tc:IsRelateToEffect(e) or not tc:IsPublic() or tc:GetFlagEffect(m)==0 then return end
	if Duel.GetTurnPlayer()==tp then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_ACTIVATE_COST)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetLabelObject(tc)
		e1:SetTarget(function(e,te,tp)return te:GetHandler()==e:GetLabelObject() and te:IsHasType(EFFECT_TYPE_ACTIVATE) and e:GetLabelObject():GetFlagEffect(m)>0 end)
		e1:SetCost(function(e,te_or_c,tp)return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)end)
		e1:SetOperation(cm.costop1)
		Duel.RegisterEffect(e1,tp)
	else
		if tc:GetActivateEffect() then
			local ce=tc:GetActivateEffect():Clone()
			ce:SetDescription(aux.Stringid(m,1))
			ce:SetType(EFFECT_TYPE_QUICK_O)
			ce:SetRange(LOCATION_MZONE)
			ce:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
			ce:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
			e:GetHandler():RegisterEffect(ce)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetCode(EFFECT_ACTIVATE_COST)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e2:SetRange(LOCATION_MZONE)
			e2:SetTargetRange(1,0)
			e2:SetLabelObject(tc)
			e2:SetTarget(function(e,te,tp)return te==ce and te:GetHandler()==e:GetHandler()end)
			e2:SetCost(cm.costchk)
			e2:SetOperation(cm.costop2)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
			e:GetHandler():RegisterEffect(e2)
		end
	end
end
function cm.costop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SendtoGrave(sg,REASON_COST)
end
function cm.costchk(e,te_or_c,tp)
	local tc=e:GetLabelObject()
	return tc and tc:IsControler(tp) and tc:IsPublic() and tc:IsLocation(LOCATION_HAND) and tc:GetFlagEffect(m)>0
end
function cm.costop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetLabelObject(),REASON_COST)
end
