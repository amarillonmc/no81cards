--残星倩影 不知本心
if not pcall(function() require("expansions/script/c33700990") end) then require("script/c33700990") end
local m=33700991
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsss.TargetFunction(c)
	rsss.SpecialSummonRule(c,cm.con)
	rsss.MatFunction(c,cm.fun)
	local e3=rsef.STF(c,EVENT_SPSUMMON_SUCCESS,{m,4},nil,"dam","ptg",cm.damcon,nil,cm.damtg,cm.damop)
	if not cm.check then
		cm.check=true
		cm.dam={[0]=0,[1]=0}
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DAMAGE)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(cm.resetcount)
		Duel.RegisterEffect(ge2,0)
	end
end
function cm.resetcount(e)
	cm.dam={[0]=0,[1]=0}
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	if r&REASON_EFFECT ~=0 then
		cm.dam[ep]=cm.dam[ep]+ev
	end
end
function cm.con(e,tp)
	return cm.dam[tp]>0
end
function cm.fun(rc)
	local e1=rsef.I({rc,true},{m,0},1,"dam",nil,LOCATION_MZONE,nil,cm.cost,cm.tg,cm.op)
	return e1
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLP(tp)>=1000 end
	Duel.Damage(tp,1000,REASON_COST)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function cm.damcon(e,tp,eg)
	local st=e:GetHandler():GetSummonType()
	return st==SUMMON_TYPE_SPECIAL+1 and cm.dam[tp]>0
end
function cm.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local dam=Duel.GetFlagEffectLabel(tp,m)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	local dam=cm.dam[tp]
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,dam,REASON_EFFECT)
end
