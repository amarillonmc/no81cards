--重力统御者
function c9910433.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),3)
	c:EnableReviveLimit()
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9910433)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCondition(c9910433.rmcon)
	e1:SetTarget(c9910433.rmtg)
	e1:SetOperation(c9910433.rmop)
	c:RegisterEffect(e1)
	if not c9910433.global_check then
		c9910433.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(c9910433.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c9910433.checkop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		tc:RegisterFlagEffect(9910433,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9910433,0))
	end
end
function c9910433.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c9910433.filter(c,id)
	return c:GetTurnID()==id and not c:IsReason(REASON_RETURN) and c:IsAbleToRemove()
end
function c9910433.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local id=Duel.GetTurnCount()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c9910433.filter(chkc,id) end
	if chk==0 then return Duel.IsExistingTarget(c9910433.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,id) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c9910433.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,99,nil,id)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c9910433.ogfilter(c)
	return c:IsLocation(LOCATION_REMOVED) and not c:IsReason(REASON_REDIRECT)
end
function c9910433.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
	end
	local ct=Duel.GetOperatedGroup():FilterCount(c9910433.ogfilter,nil)
	if ct<3 then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e1:SetValue(aux.imval1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetValue(1)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e2)
	if ct<5 then return end
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e3:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e3:SetValue(LOCATION_REMOVED)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9910433,1))
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e4:SetTargetRange(1,1)
	e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,tp)
	if ct~=7 then return end
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAIN_SOLVING)
	e5:SetReset(RESET_PHASE+PHASE_END)
	e5:SetCondition(c9910433.discon)
	e5:SetOperation(c9910433.disop)
	Duel.RegisterEffect(e5,tp)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(9910433,2))
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e6:SetTargetRange(0,1)
	e6:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e6,tp)
	e5:SetLabelObject(e6)
end
function c9910433.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,9910433)==0 and ep~=tp
end
function c9910433.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,9910433)
	Duel.RegisterFlagEffect(tp,9910433,RESET_PHASE+PHASE_END,0,1)
	Duel.NegateEffect(ev,true)
	e:GetLabelObject():Reset()
	e:Reset()
end
