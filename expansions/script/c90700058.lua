local m=90700058
local cm=_G["c"..m]
cm.name="苍海之龙战士"
function cm.initial_effect(c)
	local e_ini=Effect.CreateEffect(c)
	e_ini:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e_ini:SetCode(EVENT_ADJUST)
	e_ini:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e_ini:SetRange(LOCATION_DECK)
	e_ini:SetOperation(cm.e_ini_op)
	e_ini:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
	c:RegisterEffect(e_ini)
	local e_cannot_sp_su=Effect.CreateEffect(c)
	e_cannot_sp_su:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_cannot_sp_su:SetType(EFFECT_TYPE_SINGLE)
	e_cannot_sp_su:SetCode(EFFECT_SPSUMMON_CONDITION)
	e_cannot_sp_su:SetValue(aux.FALSE)
	c:RegisterEffect(e_cannot_sp_su)
	local e_adv_su_proc=Effect.CreateEffect(c)
	e_adv_su_proc:SetDescription(aux.Stringid(m,0))
	e_adv_su_proc:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_adv_su_proc:SetType(EFFECT_TYPE_SINGLE)
	e_adv_su_proc:SetCode(EFFECT_SUMMON_PROC)
	e_adv_su_proc:SetCondition(cm.adv_su_proc_con)
	e_adv_su_proc:SetOperation(cm.adv_su_proc_op)
	e_adv_su_proc:SetValue(SUMMON_TYPE_ADVANCE+SUMMON_VALUE_SELF)
	c:RegisterEffect(e_adv_su_proc)
	local e_speed_adv_su=Effect.CreateEffect(c)
	e_speed_adv_su:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e_speed_adv_su:SetRange(LOCATION_HAND)
	e_speed_adv_su:SetCode(EVENT_CHAIN_SOLVING)
	e_speed_adv_su:SetOperation(cm.speed_adv_su_op)
	c:RegisterEffect(e_speed_adv_su)
	local e_adv_su_succ=Effect.CreateEffect(c)
	e_adv_su_succ:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e_adv_su_succ:SetProperty(EFFECT_FLAG_DELAY)
	e_adv_su_succ:SetCode(EVENT_SUMMON_SUCCESS)
	e_adv_su_succ:SetCondition(cm.adv_su_succ_con)
	e_adv_su_succ:SetTarget(cm.adv_su_succ_tg)
	e_adv_su_succ:SetOperation(cm.adv_su_succ_op)
	c:RegisterEffect(e_adv_su_succ)
	local e_adv_su_succ_assis=Effect.CreateEffect(c)
	e_adv_su_succ_assis:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e_adv_su_succ_assis:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e_adv_su_succ_assis:SetCode(EVENT_SUMMON_SUCCESS)
	e_adv_su_succ_assis:SetOperation(cm.adv_su_succ_assis_op)
	e_ini:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
	c:RegisterEffect(e_adv_su_succ_assis)
end
function cm.aclimit(e,tp,eg,ep,ev,re,r,rp)
	if not (re:IsActiveType(TYPE_SPELL) or re:IsActiveType(TYPE_TRAP)) then return end
	local p=re:GetHandlerPlayer()
	Duel.RegisterFlagEffect(p,m-3,RESET_PHASE+PHASE_END,0,1)
	if Duel.IsExistingMatchingCard(cm.aclimitfilter,p,LOCATION_SZONE,LOCATION_SZONE,1,nil) then
		Duel.RegisterFlagEffect(p,m,RESET_PHASE+PHASE_END,0,1)
	end
end
function cm.aclimitfilter(c)
	return c:IsPosition(POS_FACEDOWN) and c:GetFlagEffect(m)~=0
end
function cm.aclimitcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),m)~=0 and Duel.IsExistingMatchingCard(cm.aclimitfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil)
end
function cm.elimit_st(e,re,tp)
	return re:IsHasType(TYPE_SPELL+TYPE_TRAP)
end
function cm.e_ini_op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=c:GetControler()

	local e_assis_limit=Effect.CreateEffect(c)
	e_assis_limit:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e_assis_limit:SetCode(EVENT_CHAINING)
	e_assis_limit:SetOperation(cm.aclimit)
	Duel.RegisterEffect(e_assis_limit,tp)

	local e_assis_inact_A=Effect.CreateEffect(c)
	e_assis_inact_A:SetType(EFFECT_TYPE_FIELD)
	e_assis_inact_A:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e_assis_inact_A:SetCode(EFFECT_CANNOT_ACTIVATE)
	e_assis_inact_A:SetTargetRange(1,0)
	e_assis_inact_A:SetCondition(cm.aclimitcon)
	e_assis_inact_A:SetValue(cm.elimit_st)
	Duel.RegisterEffect(e_assis_inact_A,0)
	local e_assis_inact_B=Effect.Clone(e_assis_inact_A)
	Duel.RegisterEffect(e_assis_inact_B,1)

	local e_disable_m_A=Effect.CreateEffect(e:GetHandler())
	e_disable_m_A:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e_disable_m_A:SetCode(EVENT_CHAIN_SOLVING)
	e_disable_m_A:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e_disable_m_A:SetOperation(cm.e_disable_m_op)
	Duel.RegisterEffect(e_disable_m_A,p)
	local e_disable_m_B=Effect.Clone(e_disable_m_A)
	Duel.RegisterEffect(e_disable_m_B,1-p)

	local e_disable_m_cont_A=Effect.CreateEffect(c)
	e_disable_m_cont_A:SetType(EFFECT_TYPE_FIELD)
	e_disable_m_cont_A:SetTargetRange(0xff,0)
	e_disable_m_cont_A:SetTarget(cm.disable_m_cont)
	e_disable_m_cont_A:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e_disable_m_cont_A:SetCondition(cm.aclimitcon_m)
	e_disable_m_cont_A:SetCode(EFFECT_DISABLE_EFFECT)
	Duel.RegisterEffect(e_disable_m_cont_A,p)
	local e_disable_m_cont_B=Effect.Clone(e_disable_m_cont_A)
	Duel.RegisterEffect(e_disable_m_cont_B,1-p)

	local e_reset_flag=Effect.CreateEffect(c)
	e_reset_flag:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e_reset_flag:SetCode(EVENT_ADJUST)
	e_reset_flag:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_PLAYER_TARGET)
	e_reset_flag:SetOperation(cm.e_reset_flag_op)
	Duel.RegisterEffect(e_reset_flag,p)
end
function cm.e_reset_flag_op(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(cm.aclimitfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) then
		Duel.ResetFlagEffect(0,m)
		Duel.ResetFlagEffect(1,m)
	end
end
function cm.aclimitcon_m(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,m-1)~=0 and Duel.GetFlagEffect(tp,m-3)==0
end
function cm.disable_m_cont(e,c)
	return c:IsType(TYPE_MONSTER)
end
function cm.e_disable_m_op(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsActiveType(TYPE_MONSTER) then return end
	local tp=re:GetHandlerPlayer()
	if Duel.GetFlagEffect(tp,m-1)~=0 and Duel.GetFlagEffect(tp,m-3)==0 then
		Duel.ChangeChainOperation(ev,cm.tabula_rasa_op)
	end
end
function cm.tabula_rasa_op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,m)
	Duel.Hint(HINT_CARD,1-tp,m)
end
function cm.adv_su_proc_con(e,c,minc)
	if c==nil then return true end
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.adv_su_proc_op(e,tp,eg,ep,ev,re,r,rp,c)
	if Duel.GetFlagEffect(1-tp,m-2)==0 then
		local e_delay_st=Effect.CreateEffect(e:GetHandler())
		e_delay_st:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e_delay_st:SetCode(EVENT_CHAIN_SOLVING)
		e_delay_st:SetReset(RESET_PHASE+PHASE_END)  
		e_delay_st:SetOperation(cm.e_delay_st_op)
		Duel.RegisterEffect(e_delay_st,1-tp)
		local e_delay_dis=Effect.CreateEffect(c)
		e_delay_dis:SetType(EFFECT_TYPE_FIELD)
		e_delay_dis:SetTargetRange(0xff,0)
		e_delay_dis:SetTarget(cm.delay_disable_conti)
		e_delay_dis:SetReset(RESET_PHASE+PHASE_END) 
		e_delay_dis:SetCode(EFFECT_DISABLE_EFFECT)
		Duel.RegisterEffect(e_delay_dis,1-tp)
		Duel.RegisterFlagEffect(1-tp,m-2,RESET_PHASE+PHASE_END,0,1)
		if re and re:GetHandlerPlayer()~=c:GetControler() then
			cm.e_delay_st_op(e,1-tp,eg,ep,ev,re,r,rp)
		end
	end
end
function cm.delay_disable_conti(e,c)
	return c:IsType(TYPE_TRAP+TYPE_SPELL)
end
function cm.e_delay_st_op(e,tp,eg,ep,ev,re,r,rp)
	if not (re:IsActiveType(TYPE_SPELL) or re:IsActiveType(TYPE_TRAP)) then return end
	if re:GetHandlerPlayer()~=tp then return end
	local e=Effect.CreateEffect(re:GetHandler())
	e:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e:SetReset(RESET_PHASE+PHASE_STANDBY)
	e:SetCountLimit(1)
	if re:GetCondition() then
		e:SetCondition(re:GetCondition())
	end
	if re:GetTarget() then
		e:SetTarget(re:GetTarget())
	end
	if re:GetOperation() then
		e:SetOperation(re:GetOperation())
	end
	Duel.RegisterEffect(e,tp)
	Duel.ChangeChainOperation(ev,cm.tabula_rasa_op)
end
function cm.speed_adv_su_op(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsActiveType(TYPE_SPELL+TYPE_TRAP) then return end
	if not e:GetHandler():IsSummonable(true,nil) then return end
	local con_tri_adv=Duel.CheckTribute(e:GetHandler(),2,2)
	local con_sp_adv=cm.adv_su_proc_con(e,e:GetHandler(),0)
	if (con_sp_adv or con_tri_adv) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		local op
		if con_tri_adv then
			if con_sp_adv then
				op=Duel.SelectOption(tp,1,aux.Stringid(m,0))
			else
				op=0
			end
		else
			op=1
		end
		if op==0 then
			local sg=Duel.SelectTribute(tp,e:GetHandler(),2,2)
			e:GetHandler():SetMaterial(sg)
			Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
		elseif op==1 then
			cm.adv_su_proc_op(e,tp,eg,ep,ev,re,r,rp,e:GetHandler())
		end
		Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_MZONE,POS_FACEUP_ATTACK,true)
		e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
		Duel.RaiseEvent(e:GetHandler(),EVENT_SUMMON_SUCCESS,nil,nil,nil,nil,nil)
		Duel.RaiseSingleEvent(e:GetHandler(),EVENT_SUMMON_SUCCESS,nil,nil,nil,nil,nil,e:GetHandler())
	end
end
function cm.adv_su_succ_con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE) or e:GetHandler():GetFlagEffect(m)>0
end
function cm.filter(c)
	return c:IsSSetable() and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsType(TYPE_FIELD)
end
function cm.adv_su_succ_tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 or Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 end
	if e:GetHandler():GetFlagEffect(m)>0 then
		e:GetHandler():ResetFlagEffect(m)
	end
end
function cm.econ(e)
	return e:GetHandler():IsPosition(POS_FACEDOWN)
end
function cm.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function cm.adv_su_succ_op(e,tp,eg,ep,ev,re,r,rp)
	local tpsz=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local tptg=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil)
	local opsz=Duel.GetLocationCount(1-tp,LOCATION_SZONE)
	local optg=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_DECK,nil)
	if (tpsz<=0 or tptg:GetCount()==0) and (opsz<=0 or optg:GetCount()==0) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tpg=tptg:Select(tp,tpsz,tpsz,nil)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SET)
	local opg=optg:Select(1-tp,opsz,opsz,nil)
	Duel.SSet(tp,tpg,tp,true)
	Duel.SSet(1-tp,opg,1-tp,true)
	tpg:Merge(opg)
	local tc=tpg:GetFirst()
	while tc do
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
		e1:SetRange(LOCATION_SZONE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCondition(cm.econ)
		e1:SetValue(cm.efilter)
		tc:RegisterEffect(e1,true)
		tc=tpg:GetNext()
	end
end
function cm.adv_su_succ_assis_op(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(1-tp,m-1,0,0,1)
end