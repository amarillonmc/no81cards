--「」大哥
function c44401009.initial_effect(c)
	--fusion material
	aux.AddFusionProcFunFun(c,c44401009.mfilter,aux.FilterBoolFunction(Card.IsRace,RACE_PSYCHO),2,true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToRemoveAsCost,LOCATION_MZONE,0,Duel.Remove,POS_FACEUP,REASON_COST+REASON_FUSION+REASON_MATERIAL):SetValue(SUMMON_TYPE_FUSION)
	c:EnableReviveLimit()
	--indes
--[[	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetValue(1)
	c:RegisterEffect(e0)--]]
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_REMOVE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c44401009.atkop)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(TIMING_END_PHASE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c44401009.target)
	e2:SetOperation(c44401009.operation)
	c:RegisterEffect(e2)
end
function c44401009.mfilter(c)
	return c:IsRace(RACE_PSYCHO) and c:IsFusionType(TYPE_FUSION)
end
function c44401009.atkop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetValue(200)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
	e:GetHandler():RegisterEffect(e1)
end
function c44401009.cfilter(c,e)
	return c:IsSetCard(0xa4a) and c:IsFaceup() and c:IsCanBeEffectTarget(e) and c:IsAbleToRemove()
end
function c44401009.gcheck(sg)
	return Duel.IsExistingTarget(Card.IsAbleToRemove,0,LOCATION_MZONE,LOCATION_MZONE,#sg,sg)
end
function c44401009.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(c44401009.cfilter,tp,LOCATION_MZONE,0,nil,e)
	if chk==0 then return g:CheckSubGroup(c44401009.gcheck) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sg=g:SelectSubGroup(tp,c44401009.gcheck,false,1,#g)
	Duel.SetTargetCard(sg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,#sg,#sg,sg)
	e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(44401009,0))
end
function c44401009.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	if #g==0 then return end
	Duel.Remove(g,0,REASON_EFFECT+REASON_TEMPORARY)
	local og=Duel.GetOperatedGroup()
	local ct=Duel.GetCurrentPhase()<=PHASE_STANDBY and 2 or 1
	local fid=e:GetHandler():GetFieldID()
	for tc in aux.Next(og) do
		tc:RegisterFlagEffect(44401009,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,EFFECT_FLAG_CLIENT_HINT,ct,fid,aux.Stringid(44401009,2))
	end
	og:KeepAlive()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCountLimit(1)
	e1:SetLabel(fid,Duel.GetTurnCount()+1)
	e1:SetLabelObject(og)
	e1:SetCondition(c44401009.retcon)
	e1:SetOperation(c44401009.retop)
	e1:SetReset(RESET_PHASE+PHASE_STANDBY,ct)
	Duel.RegisterEffect(e1,tp)
end
function c44401009.retfilter(c,fid)
	return c:GetFlagEffectLabel(44401009)==fid
end
function c44401009.retcon(e,tp,eg,ep,ev,re,r,rp)
	local fid,ct=e:GetLabel()
	if Duel.GetTurnCount()<ct then return false end
	local g=e:GetLabelObject()
	if not g:IsExists(c44401009.retfilter,1,nil,fid) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c44401009.retop(e,tp,eg,ep,ev,re,r,rp)
	local fid,ct=e:GetLabel()
	local g=e:GetLabelObject()
	local sg=g:Filter(c44401009.retfilter,nil,fid)
	g:DeleteGroup()
	for tc in aux.Next(sg) do Duel.ReturnToField(tc) end
end
