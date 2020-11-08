--白色的物体
if not pcall(function() require("expansions/script/c25010000") end) then require("script/c25010000") end
local m,cm=rscf.DefineCard(25000082)
function cm.initial_effect(c)
	--cannot material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e1:SetValue(cm.fuslimit)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e4)

	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_UNRELEASABLE_SUM)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e6)

	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	c:RegisterEffect(e7)

	local e8=rsef.FC(c,EVENT_ADJUST)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e8:SetOperation(cm.damop)

	local e9=rsef.FC(c,EVENT_RECOVER)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e9:SetOperation(cm.rmop)

	local e10=rsef.SC(c,EVENT_LEAVE_FIELD)
	e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e10:SetOperation(cm.spop)
	e10:SetLabel(e9)

	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_SET_BATTLE_ATTACK)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e11:SetCondition(cm.acon)
	e11:SetValue(cm.aval)
	e11:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e11)
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e12:SetCode(EFFECT_SET_BATTLE_DEFENSE)
	e12:SetRange(LOCATION_MZONE)
	e12:SetCondition(cm.acon)
	e12:SetValue(cm.dval)
	c:RegisterEffect(e12)

	local e13=rsef.SV_IMMUNE_EFFECT(c,rsval.imoe,cm.ctcon(2))

	local e14=rsef.QO(c,nil,{m,0},1,"tg","cd",LOCATION_MZONE,cm.ctcon(3),nil,rsop.target(cm.tgfilter,"tg",0,LOCATION_ONFIELD,true),cm.tgop)

	local e15=Effect.CreateEffect(c)
	e15:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e15:SetCode(EVENT_CHAINING)
	e15:SetRange(LOCATION_MZONE)
	e15:SetCondition(cm.chcon1)
	e15:SetOperation(cm.chop1)
	c:RegisterEffect(e15)
	local e16=Effect.CreateEffect(c)
	e16:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e16:SetCode(EVENT_CHAIN_SOLVING)
	e16:SetRange(LOCATION_MZONE)
	e16:SetCondition(cm.chcon2)
	e16:SetOperation(cm.chop2)
	c:RegisterEffect(e16)

	local e19=rsef.SV_LIMIT(c,"atk",nil,cm.atklimitcon,nil,"cd")

	local e20=rsef.SV_IMMUNE_EFFECT(c,cm.imval2)
end
function cm.imval2(e,re)
	return not rsval.imoe(e,re) and rsval.imes(e,re)
end
function cm.atklimitcon(e)
	return not e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL+11)
end
function cm.ctcon(ct)
	return function(e)
		return Duel.GetFlagEffect(e:GetHandlerPlayer(),m)>=ct
	end
end
function cm.chcon1(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and cm.ctcon(2)(e,tp)
end
function cm.chop1(e,tp,eg,ep,ev,re,r,rp)
	re:GetHandler():RegisterFlagEffect(m+900,RESET_CHAIN,0,1)
end
function cm.chcon2(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():GetFlagEffect(m+900)>0
end
function cm.chop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,cm.rep_op)
end
function cm.rep_op(e,tp,eg,ep,ev,re,r,rp)
	local c=rscf.GetSelf(e)
	if c then 
		Duel.Hint(HINT_CARD,0,m)
		Duel.Destroy(c,REASON_EFFECT)
	end
end
function cm.tgfilter(c,e,tp)
	return Duel.IsPlayerCanSendtoGrave(tp,c)
end
function cm.tgop(e,tp)
	local tg=Duel.GetMatchingGroup(cm.tgfilter,tp,0,LOCATION_ONFIELD,nil,e,tp)
	Duel.SendtoGrave(tg,REASON_RULE)
end
function cm.acon(e)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	local bc=c:GetBattleTarget()
	return bc and bc:IsControler(1-tp) and Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL and Duel.GetFlagEffect(e:GetHandlerPlayer(),m)>=1
end
function cm.aval(e,c)
	return e:GetHandler():GetBattleTarget():GetAttack()*2
end
function cm.dval(e,c)
	return e:GetHandler():GetBattleTarget():GetDefense()*2
end

function cm.spop(e,tp)
	local c=e:GetHandler()
	local re=c:GetReasonEffect()
	if re and re==e:GetLabel() then return end
	rshint.Card(m)  
	Duel.ConfirmCards(1-tp,c)
	if rscf.spfilter2()(c,e,tp) and Duel.SpecialSummon(c,11,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.RegisterFlagEffect(tp,m,0,0,1)
	end
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep==tp and rp~=tp and r & REASON_EFFECT ~=0 and c:IsAbleToRemove() then
		rshint.Card(m)
		Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
	end
end

function cm.fuslimit(e,c,sumtype)
	return sumtype & SUMMON_TYPE_FUSION ~=0
end
function cm.damop(e,tp)
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,m+100)<=0 then
		Duel.Hint(HINT_CARD,0,m)
		Duel.RegisterFlagEffect(tp,m+100,rsreset.pend,0,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_REFLECT_DAMAGE)
		e1:SetTargetRange(1,0)
		e1:SetValue(aux.TRUE)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
