local s,id,o=GetID()
function s.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_SELF_TOGRAVE)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(s.sprcon)
	e2:SetTarget(s.sprtg)
	e2:SetOperation(s.sprop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(2000)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_SELF_TOGRAVE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(s.tgcon)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,0))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetHintTiming(0,TIMING_DRAW_PHASE+TIMING_STANDBY_PHASE+TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+TIMING_BATTLE_PHASE+TIMING_END_PHASE)
	e5:SetTarget(s.destg)
	e5:SetOperation(s.desop)
	c:RegisterEffect(e5)
	s.self_destroy_effect=e5
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.GlobalEffect()
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_DESTROYED)
		ge2:SetOperation(s.count)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.GlobalEffect()
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_CHAIN_SOLVED)
		ge3:SetOperation(s.checkop2)
		Duel.RegisterEffect(ge3,0)
		s.Destroy=Duel.Destroy
		Duel.Destroy=function(g,rs,...)
			if rs&0x60~=0 then Group.__add(g,g):ForEach(Card.RegisterFlagEffect,id,RESET_EVENT+0x1fc0000,0,1) end
			return s.Destroy(g,rs,...)
		end
	end
end
s[0]=nil
s[1]=nil
s[2]=0
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if (Duel.GetCurrentPhase()~=PHASE_DAMAGE and Duel.GetCurrentPhase()~=PHASE_DAMAGE_CAL) or Duel.GetFlagEffect(0,id)>0 then return end
	s[0]=Duel.GetAttacker()
	s[1]=Duel.GetAttackTarget()
	if not s[0] or not s[1] then return end
	local at,bt=s[0],s[1]
	if Duel.IsDamageCalculated() then
		Duel.RegisterFlagEffect(0,id,RESET_PHASE+PHASE_DAMAGE,0,1)
		if s[2]==3 then return end
		if s[2]~=0 then at:RegisterFlagEffect(id,RESET_EVENT+0x1fc0000,0,1) end
		if s[2]~=1 then bt:RegisterFlagEffect(id,RESET_EVENT+0x1fc0000,0,1) end
	else
		local atk=at:GetAttack()
		local le={at:IsHasEffect(EFFECT_DEFENSE_ATTACK)}
		local val=0
		for _,v in pairs(le) do
			val=v:GetValue()
			if aux.GetValueType(val)=="function" then val=val(e) end
		end
		if val==1 then atk=at:GetDefense() end
		if bt:IsAttackPos() then
			if atk>bt:GetAttack() then s[2]=0 elseif bt:GetAttack()>atk then s[2]=1 else s[2]=2 end
		elseif atk>bt:GetDefense() then s[2]=0 else s[2]=3 end
	end
end
function s.count(e,tp,eg,ep,ev,re,r,rp)
	local des=eg:GetFirst()
	if des:IsReason(REASON_BATTLE) then
		des:GetReasonCard():RegisterFlagEffect(id+33,RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_DRAW,0,1)
	elseif re then
		local rc=re:GetHandler()
		if eg:IsExists(Card.IsReason,1,nil,REASON_EFFECT) and rc then rc:RegisterFlagEffect(id+33,RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_DRAW,0,1) end
	end
end
function s.checkop2(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if not rc:IsRelateToEffect(re) or not re:IsActiveType(TYPE_MONSTER) then return end
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if loc==LOCATION_MZONE then rc:RegisterFlagEffect(id+66,RESET_EVENT+0x1fc0000,0,1) end
end
function s.filter(c)
	return c:GetOriginalType()&TYPE_MONSTER~=0 and c:IsFaceup() and c:GetFlagEffect(id)>0 and c:GetBaseAttack()==0 and c:IsAbleToHandAsCost()
end
function s.fselect(g,tp,sc)
	return Duel.GetLocationCountFromEx(tp,tp,g,sc,0x60)>0
end
function s.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_ONFIELD,0,nil)
	return mg:CheckSubGroup(s.fselect,1,#mg,tp,c)
end
function s.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local mg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_ONFIELD,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local tg=mg:SelectSubGroup(tp,s.fselect,true,1,#mg,tp,c)
	if tg then
		tg:KeepAlive()
		e:SetLabelObject(tg)
		return true
	else return false end
end
function s.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoHand(g,nil,REASON_COST)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MUST_USE_MZONE)
	e1:SetValue(0x60)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	g:DeleteGroup()
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_END and e:GetHandler():GetFlagEffect(id+33)==0
end
function s.desfilter(c)
	return c:GetFlagEffect(id+66)>0
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.desfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(s.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,s.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
	if Group.__band(g,e:GetHandler():GetLinkedGroup()):GetCount()>0 then
		e:SetLabel(1)
		e:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0xff)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,Group.__add(e:GetHandler(),g),2,0,0)
	else
		e:SetLabel(0)
		e:SetCategory(CATEGORY_DESTROY)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	end
end
function s.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCode(id-7)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g=Group.__add(Duel.GetFieldGroup(tp,0xff,0),Duel.GetOverlayGroup(tp,1,0)):Filter(s.spfilter,nil,e,tp)
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and e:GetLabel()==1 and #g>0 then
		Duel.BreakEffect()
		local sg=g:Select(tp,1,1,nil)
		if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)~=0 and e:GetHandler():IsRelateToEffect(e) then Duel.Destroy(e:GetHandler(),REASON_EFFECT) end
	end
end
