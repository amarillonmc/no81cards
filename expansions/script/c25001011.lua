--飞在天上的大铁块
if not pcall(function() require("expansions/script/c25010000") end) then require("script/c25010000") end
local m,cm=rscf.DefineCard(25001011)
function cm.initial_effect(c)
	local e1=rscf.SetSummonCondition(c,false)
	local e2=rsef.I(c,{m,0},{1,m},"sp",nil,LOCATION_GRAVE,nil,nil,rsop.target(cm.spfilter,"sp"),cm.spop)
	local e3=rsef.QO(c,nil,{m,1},nil,nil,nil,LOCATION_HAND,rscon.turno,cm.rmcost,nil,cm.op)
	local e4,e5=rsef.SV_UPDATE(c,"atk,def",cm.val)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetCode(EFFECT_REVERSE_DAMAGE)
	e6:SetTargetRange(1,0)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(cm.valcon)
	c:RegisterEffect(e6)
	local e7=rsef.QO(c,nil,{m,2},{1,m+100},"tg",nil,LOCATION_MZONE,nil,rscost.lpcost(1000),rsop.target(cm.tgfilter,"tg",0,LOCATION_ONFIELD),cm.tgop)
end
function cm.spfilter(c,e,tp)
	return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,true,true,POS_FACEUP)
end
function cm.tgfilter(c,e,tp)
	return Duel.IsPlayerCanSendtoGrave(1-tp,c)
end
function cm.tgop(e,tp)
	if rsop.SelectToGrave(1-tp,cm.tgfilter,1-tp,LOCATION_ONFIELD,0,1,1,nil,{ REASON_RULE },e,tp)>0 then
		Duel.BreakEffect()
		Duel.SetLP(1-tp,math.max(Duel.GetLP(1-tp)-1000),0)
	end
end
function cm.valcon(e,re,r,rp,rc)
	return r & REASON_BATTLE + REASON_EFFECT ~=0
end
function cm.val(e,c)
	return Duel.GetLP(e:GetHandlerPlayer())
end
function cm.spop(e,tp)
	local c=rscf.GetSelf(e)
	if c then
		 rssf.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP,nil,{"cp"})
	end
end
function cm.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	if Duel.Remove(c,POS_FACEUP,REASON_COST+REASON_TEMPORARY)~=0 then
		c:RegisterFlagEffect(m,rsreset.est_pend,0,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetCondition(cm.retcon)
		e1:SetOperation(cm.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.retcon(e,tp)
	local c=e:GetLabelObject()
	return c:GetFlagEffect(m)>0
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetLabelObject(),REASON_EFFECT+REASON_RETURN)
end
function cm.op(e,tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end