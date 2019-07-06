--残星倩影 地破格明
if not pcall(function() require("expansions/script/c33700990") end) then require("script/c33700990") end
local m=33700997
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsss.TargetFunction(c)
	rsss.NoTributeFunction(c,cm.con,cm.op)
	if not cm.check then
		cm.check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DAMAGE)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	if r&REASON_EFFECT ~=0 then
		local lab=Duel.GetFlagEffectLabel(tp,m)
		if not lab then lab=0 end
		Duel.RegisterFlagEffect(ep,m,rsreset.pend,0,1,ev+lab)
	end
end
function cm.con(e,tp)
	return Duel.GetFlagEffect(tp,m)>0
end
function cm.op(c)
	local e1=rsef.FTO(c,EVENT_PHASE+PHASE_END,{m,0},1,"dr","ptg",LOCATION_MZONE,cm.dcon,nil,cm.dtg,cm.dop)
	return e1
end
function cm.dcon(e,tp)
	return Duel.GetTurnPlayer()==tp
end
function cm.dtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFlagEffect(tp,m)
	if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function cm.dop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFlagEffect(tp,m)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,ct,REASON_EFFECT)
end
