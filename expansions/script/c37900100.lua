--Ayano
function c37900100.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c37900100.mat,9,true)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c37900100.spcon)
	e0:SetTarget(c37900100.sptg)
	e0:SetOperation(c37900100.spop)
	e0:SetValue(SUMMON_TYPE_FUSION)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c37900100.tg)
	e1:SetOperation(c37900100.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c37900100.tg2)
	e2:SetOperation(c37900100.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c37900100.con3)
	e3:SetTarget(c37900100.tg3)
	e3:SetOperation(c37900100.op3)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c) 
	e4:SetType(EFFECT_TYPE_FIELD) 
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c37900100.tg4)
	e4:SetValue(c37900100.val4) 
	c:RegisterEffect(e4)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_TOEXTRA+CATEGORY_DECKDES+CATEGORY_TOGRAVE+CATEGORY_GRAVE_ACTION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetTarget(c37900100.tg5)
	e1:SetOperation(c37900100.op5)
	c:RegisterEffect(e1)	
end
function c37900100.mat(c)
	return c:IsRace(RACE_WARRIOR) and c:IsLevel(4)
end
function c37900100.sp(c)
	return c:IsFaceup() and c:IsSetCard(0x382) and c:IsAbleToRemoveAsCost()
end
function c37900100.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c37900100.sp,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.GetCode)>=9
end
function c37900100.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c37900100.sp,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	Duel.Hint(3,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,9,9)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c37900100.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Remove(g,POS_FACEUP,REASON_SPSUMMON)
	g:DeleteGroup()
end
function c37900100.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,PLAYER_ALL,LOCATION_REMOVED)
end
function c37900100.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	if #g>0 then
	local ct=Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	if ct<=0 then return end
	local dg1=Duel.GetFieldGroup(tp,2,0)
	local dg2=Duel.GetFieldGroup(tp,0,2)
	local x1,x2=0,0
	if #dg1<=4 then x1=Duel.Draw(tp,5-#dg1,REASON_EFFECT) end
	if #dg2<=4 then x2=Duel.Draw(1-tp,5-#dg2,REASON_EFFECT) end
		if x1>0 and x2>0 and c:IsRelateToEffect(e) then
		Duel.BreakEffect()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetValue(ct*500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_DEFENSE)
		e2:SetValue(ct*500)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e2)
		end 
	end
end
function c37900100.q(c)
	return c:IsFaceup() and c:IsSetCard(0x382)
end
function c37900100.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c37900100.q,tp,4,0,nil)
	if chk==0 then return #g>0 and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(3,tp,HINTMSG_TARGET)
	local gg=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,#g,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,gg,#gg,0,0)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,c,1,0,#gg*500)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,#gg*500)
end
function c37900100.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 and Duel.Destroy(g,REASON_EFFECT)>0 then
	local op=Duel.GetOperatedGroup()
		if #op>0 and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(#op*500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(#op*500)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
		end
	end
end
function c37900100.con3(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c37900100.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c37900100.op3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
	Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c37900100.tg4(e,c) 
	return c:IsSetCard(0x382) and c:IsFaceup()
end
function c37900100.val4(e,te)
	return te:IsActiveType(TYPE_SPELL+TYPE_TRAP) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c37900100.p(c)
	return c:IsAbleToGrave() and c:IsSetCard(0x382) and c:IsType(1)
end
function c37900100.tg5(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToExtra() and Duel.IsExistingMatchingCard(c37900100.p,tp,1,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,c,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,1)
end
function c37900100.op5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,2,REASON_EFFECT)>0 and c:IsLocation(LOCATION_EXTRA) then
	Duel.Hint(3,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c37900100.p,tp,1,0,1,1,nil)  
		if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end