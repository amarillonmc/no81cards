--熏 烟 狂 躁 的 班 达 斯 奈 奇
local m=22348312
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22348312,1))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,22348312)
	e1:SetCondition(c22348312.descon1)
	e1:SetCost(c22348312.descost)
	e1:SetTarget(c22348312.destg)
	e1:SetOperation(c22348312.desop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22348312,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCondition(c22348312.descon2)
	e2:SetCost(c22348312.descost)
	e2:SetTarget(c22348312.destg)
	e2:SetOperation(c22348312.desop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22348312,11))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c22348312.decon)
	e3:SetCost(c22348312.decost)
	e3:SetTarget(c22348312.detg)
	e3:SetOperation(c22348312.deop)
	c:RegisterEffect(e3)
	--adjust
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e01:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
	e01:SetCode(EVENT_ADJUST)
	e01:SetRange(LOCATION_MZONE)
	e01:SetOperation(c22348312.adjustop)
	c:RegisterEffect(e01)
	
end
function c22348312.decon(e,tp,eg,ep,ev,re,r,rp)
	local aaa=Duel.GetFlagEffect(e:GetHandler(),22349312)
	return not aux.MustMaterialCounterFilter(e:GetHandler(),eg) and aaa==9
end
function c22348312.detg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bbb=Duel.GetFlagEffect(e:GetHandler(),22348312)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD+LOCATION_HAND,nil)
	if chk==0 then return g:GetCount()>=bbb end
	e:SetLabel(bbb)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,0,bbb,0,LOCATION_ONFIELD+LOCATION_HAND)
end
function c22348312.deop(e,tp,eg,ep,ev,re,r,rp)
	local aaa=e:GetLabel()
	local tg=Duel.GetMatchingGroupCount(aux.TRUE,tp,0,LOCATION_ONFIELD+LOCATION_HAND,nil)
	if tg<aaa then return end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(1-tp,aux.TRUE,tp,0,LOCATION_ONFIELD+LOCATION_HAND,aaa,aaa,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		local tc=Duel.Destroy(g,REASON_EFFECT)
		if tc>0 then
		Duel.Damage(1-tp,tc*500,REASON_EFFECT)
		end
	end
end
function c22348312.descon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c22348312.descon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c22348312.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.RegisterFlagEffect(e:GetHandler(),22348312,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(e:GetHandler(),22349312,RESET_EVENT+RESETS_STANDARD,0,1)
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c22348312.decost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.RegisterFlagEffect(e:GetHandler(),22349312,RESET_EVENT+RESETS_STANDARD,0,1)
end
function c22348312.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,LOCATION_ONFIELD)
end
function c22348312.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end

function c22348312.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	local c=e:GetHandler()
	local flaga=Duel.GetFlagEffect(e:GetHandler(),22348312)
	local flagb=Duel.GetFlagEffect(e:GetHandler(),22349312)
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	if flaga and flagb then
	Card.ResetFlagEffect(c,22350312)
	Card.ResetFlagEffect(c,22351312)
	local ex=Effect.CreateEffect(c)
	ex:SetType(EFFECT_TYPE_SINGLE)
	if flagb<9 then
	c:RegisterFlagEffect(22350312,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(22348312,flagb+1))
	else
	c:RegisterFlagEffect(22350312,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(22348312,10))
	end
	if flaga<9 then
	c:RegisterFlagEffect(22351312,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(22348311,flaga+1))
	else
	c:RegisterFlagEffect(22351312,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(22348311,10))
	end
	end
end