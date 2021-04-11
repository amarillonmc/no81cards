local m=90700056
local cm=_G["c"..m]
cm.name="掠影之龙战士"
function cm.initial_effect(c)
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
	e_speed_adv_su:SetCode(EVENT_MOVE)
	e_speed_adv_su:SetOperation(cm.speed_adv_su_op)
	c:RegisterEffect(e_speed_adv_su)
	local e_conti_adv_su_mz=Effect.CreateEffect(c)
	e_conti_adv_su_mz:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e_conti_adv_su_mz:SetCode(EVENT_LEAVE_FIELD)
	e_conti_adv_su_mz:SetRange(LOCATION_MZONE)
	e_conti_adv_su_mz:SetOperation(cm.e_conti_adv_su_op)
	e_conti_adv_su_mz:SetLabel(0)
	c:RegisterEffect(e_conti_adv_su_mz)
	local e_conti_adv_su_gr=Effect.Clone(e_conti_adv_su_mz)
	e_conti_adv_su_gr:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e_conti_adv_su_gr)
	local e_conti_adv_su_mz_assis=Effect.CreateEffect(c)
	e_conti_adv_su_mz_assis:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e_conti_adv_su_mz_assis:SetCode(EVENT_LEAVE_FIELD_P)
	e_conti_adv_su_mz_assis:SetRange(LOCATION_MZONE)
	e_conti_adv_su_mz_assis:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e_conti_adv_su_mz_assis:SetOperation(cm.e_conti_adv_su_assis_op)
	e_conti_adv_su_mz_assis:SetLabelObject(e_conti_adv_su_mz)
	c:RegisterEffect(e_conti_adv_su_mz_assis)
	local e_conti_adv_su_gr_assis=Effect.Clone(e_conti_adv_su_mz_assis)
	e_conti_adv_su_gr_assis:SetRange(LOCATION_GRAVE)
	e_conti_adv_su_gr_assis:SetLabelObject(e_conti_adv_su_gr)
	c:RegisterEffect(e_conti_adv_su_gr_assis)
	local e_cannot_su_mz=Effect.CreateEffect(c)
	e_cannot_su_mz:SetType(EFFECT_TYPE_FIELD)
	e_cannot_su_mz:SetCode(EFFECT_CANNOT_SUMMON)
	e_cannot_su_mz:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e_cannot_su_mz:SetRange(LOCATION_MZONE)
	e_cannot_su_mz:SetTarget(cm.limit_tg)
	e_cannot_su_mz:SetTargetRange(0,1)
	c:RegisterEffect(e_cannot_su_mz)
	local e_cannot_sp_mz=Effect.Clone(e_cannot_su_mz)
	e_cannot_sp_mz:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	c:RegisterEffect(e_cannot_sp_mz)
	local e_cannot_fl_mz=Effect.Clone(e_cannot_su_mz)
	e_cannot_fl_mz:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e_cannot_fl_mz)
	local e_cannot_su_gr=Effect.Clone(e_cannot_su_mz)
	e_cannot_su_gr:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e_cannot_su_gr)
	local e_cannot_sp_gr=Effect.Clone(e_cannot_sp_mz)
	e_cannot_sp_gr:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e_cannot_sp_gr)
	local e_cannot_fl_gr=Effect.Clone(e_cannot_fl_mz)
	e_cannot_fl_gr:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e_cannot_fl_gr)
	local e_to_gr_mz=Effect.CreateEffect(c)
	e_to_gr_mz:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e_to_gr_mz:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e_to_gr_mz:SetCode(EVENT_ADJUST)
	e_to_gr_mz:SetRange(LOCATION_MZONE)
	e_to_gr_mz:SetOperation(cm.e_to_gr_op)
	c:RegisterEffect(e_to_gr_mz)
	local e_to_gr_gr=Effect.Clone(e_to_gr_mz)
	e_to_gr_gr:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e_to_gr_gr)
end
function cm.adv_su_proc_con(e,c,minc)
	if c==nil then return true end
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(Card.IsPosition,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,POS_FACEUP)
end
function cm.adv_su_proc_op(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
	local tc=g:GetFirst()
	while tc do
		if tc:IsPosition(POS_FACEUP) then
			tc:AddCounter(0x131f,1)
		end
		tc=g:GetNext()
	end
end
function cm.adv_su_outchain_filter(c)
	if not c:IsCode(90700056) then return false end
	return c:IsSummonable(true,nil) and (cm.adv_su_proc_con(e,c,0) or Duel.CheckTribute(c,2,2))
end
function cm.adv_su_outchain(c,loc,tp)
	if loc==1 and (not Duel.IsExistingMatchingCard(cm.adv_su_outchain_filter,tp,LOCATION_DECK,0,1,nil)) then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(m,1)) then return end
	local adv_su_tg
	if loc==0 then
		adv_su_tg=c
	end
	if loc==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		adv_su_tg=Duel.SelectMatchingCard(tp,cm.adv_su_outchain_filter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	end
	if adv_su_tg then
		local con_tri_adv=Duel.CheckTribute(adv_su_tg,2,2)
		local con_sp_adv=cm.adv_su_proc_con(e,adv_su_tg,0)
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
			local sg=Duel.SelectTribute(tp,adv_su_tg,2,2)
			adv_su_tg:SetMaterial(sg)
			Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
		elseif op==1 then
			cm.adv_su_proc_op(e,tp,eg,ep,ev,re,r,rp,c)
		end
		Duel.MoveToField(adv_su_tg,tp,tp,LOCATION_MZONE,POS_FACEUP_ATTACK,true)
		Duel.RaiseEvent(adv_su_tg,EVENT_SUMMON_SUCCESS,nil,nil,nil,nil,nil)
		Duel.RaiseSingleEvent(adv_su_tg,EVENT_SUMMON_SUCCESS,nil,nil,nil,nil,nil,adv_su_tg)
	end
end
function cm.speed_adv_su_op(e,tp,eg,ep,ev,re,r,rp)
	if not eg:IsExists(Card.IsLocation,1,nil,LOCATION_MZONE) then return end
	cm.adv_su_outchain(e:GetHandler(),0,tp)
end
function cm.e_conti_adv_su_leave_filter(c)
	return c:IsLocation(LOCATION_MZONE) and c:GetCounter(0x131f)>0
end
function cm.e_conti_adv_su_op(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then return end
	cm.adv_su_outchain(nil,1,tp)
	e:SetLabel(0)
end
function cm.e_conti_adv_su_assis_op(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(cm.e_conti_adv_su_leave_filter,1,nil) then
		e:GetLabelObject():SetLabel(1)
	end
end
function cm.limit_tg_counter_filter(c)
	return c:IsFaceup() and c:GetCounter(0x131f)>0
end
function cm.limit_tg_filter(c,tc)
	return c:GetAttribute()==tc:GetAttribute() and c:GetRace()==tc:GetRace()
end
function cm.limit_tg(e,c)
	local g=Duel.GetMatchingGroup(cm.limit_tg_counter_filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if not g:GetCount()==0 then return false end
	return not g:IsExists(cm.limit_tg_filter,1,nil,c)
end
function cm.e_to_gr_filter(c)
	return c:GetCounter(0x131f)==0 and c:IsFaceup() and cm.limit_tg(nil,c)
end
function cm.e_to_gr_op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.e_to_gr_filter,tp,0,LOCATION_MZONE,nil)
	Duel.SendtoGrave(g,REASON_RULE)

