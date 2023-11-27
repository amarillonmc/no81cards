if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local s,id,o=GetID()
function s.initial_effect(c)
	SNNM.Excavated_Check(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetCondition(function(e)return e:GetHandler():GetFlagEffect(53766099)>0 end)
	c:RegisterEffect(e1)
	--local e2,e3,e4,e5=SNNM.ActivatedAsSpellorTrap(c,0x4,0xa,true)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_F)
	e2:SetCode(EVENT_CUSTOM+id)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_SET_AVAILABLE)
	e2:SetHintTiming(TIMING_DRAW_PHASE+TIMING_STANDBY_PHASE+TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+TIMING_BATTLE_PHASE+TIMING_END_PHASE)
	e2:SetRange(0xa)
	e2:SetCondition(s.descon)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
	--[[local e2_1=Effect.CreateEffect(c)
	e2_1:SetType(EFFECT_TYPE_SINGLE)
	e2_1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2_1:SetCode(id)
	e2_1:SetRange(0xff)
	e2_1:SetLabelObject(e2)
	c:RegisterEffect(e2_1)--]]
	if not Dimpthox_Imitation then Dimpthox_Imitation={} end
	--Debug.Message(SNNM.IsInTable(e2,Dimpthox_Imitation))
	if not SNNM.IsInTable(e2,Dimpthox_Imitation) then table.insert(Dimpthox_Imitation,e2) end
	--SNNM.Global_in_Initial_Reset(c,{e4})
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetHintTiming(TIMING_DRAW_PHASE+TIMING_STANDBY_PHASE+TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+TIMING_BATTLE_PHASE+TIMING_END_PHASE)
	e3:SetCost(aux.bfgcost)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EFFECT_DESTROY_REPLACE)
		ge1:SetTarget(s.reptg)
		ge1:SetValue(s.repval)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		Duel.RegisterEffect(ge2,1)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_ADJUST)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
		--e3:SetLabelObject(e2)
		e3:SetOperation(SNNM.AASTadjustop(0x4,Dimpthox_Imitation))
		Duel.RegisterEffect(e3,0)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetCode(EFFECT_ACTIVATE_COST)
		e4:SetLabel(0xa)
		e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
		e4:SetTargetRange(1,1)
		--e4:SetLabelObject(e2)
		e4:SetTarget(s.actarget)
		e4:SetOperation(SNNM.AdvancedActOp(0x4))
		Duel.RegisterEffect(e4,0)
		local ge5=Effect.GlobalEffect()
		ge5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge5:SetCode(EVENT_ADJUST)
		ge5:SetOperation(s.checkop)
		Duel.RegisterEffect(ge5,0)
		s.CRegisterEffect=Card.RegisterEffect
		Card.RegisterEffect=function(rc,re,...)
			if re and re:GetCode()==EVENT_CUSTOM+id and re:GetOwner() and re:GetOwner()==rc then table.insert(Dimpthox_Imitation,re) end
			return s.CRegisterEffect(rc,re,...)
		end
		s.Destroy=Duel.Destroy
		Duel.Destroy=function(g,rs,...)
			if rs&0x60~=0 then Group.__add(g,g):ForEach(Card.RegisterFlagEffect,id+66,RESET_EVENT+0x1fc0000,0,1) end
			return s.Destroy(g,rs,...)
		end
	end
	SNNM.ActivatedAsSpellorTrapCheck(c)
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
		if s[2]~=0 then at:RegisterFlagEffect(id+66,RESET_EVENT+0x1fc0000,0,1) end
		if s[2]~=1 then bt:RegisterFlagEffect(id+66,RESET_EVENT+0x1fc0000,0,1) end
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
function s.actarget(e,te,tp)
	e:SetLabelObject(te)
	return SNNM.IsInTable(te,Dimpthox_Imitation)
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetHandler():GetFlagEffect(id)
	e:GetHandler():ResetFlagEffect(id)
	return ct>0
end
function s.desfilter(c)
	return c:GetOriginalType()&TYPE_MONSTER~=0 and c:IsSetCard(0x5534) and c:IsFaceup()
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and s.desfilter(chkc) and not eg:IsContains(chkc) end
	if chk==0 then
		if e:GetHandler():GetFlagEffect(53766099)>0 then e:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE) else e:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_SET_AVAILABLE) end
		return Duel.IsExistingTarget(s.desfilter,tp,LOCATION_ONFIELD,0,1,eg)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	Duel.SelectTarget(tp,s.desfilter,tp,LOCATION_ONFIELD,0,1,1,eg)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	--[[if tc and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)==0 and tc:IsAbleToHand() and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
		local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,tc)
		local thg=Group.FromCards(tc)
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,5)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local sg=g:Select(tp,1,1,tc)
			Duel.HintSelection(sg)
			thg:Merge(sg)
		end
		if Duel.SendtoHand(thg,nil,REASON_EFFECT)~=0 and thg:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) then Duel.SkipPhase(Duel.GetTurnPlayer(),Duel.GetCurrentPhase(),RESET_PHASE+Duel.GetCurrentPhase(),1,1) end
	end--]]
	if tc and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)==0 and tc:IsOnField() and (tc:IsAbleToHand() or tc:IsAbleToDeck()) and Duel.SelectYesNo(tp,aux.Stringid(id,6)) then
		local g=Duel.GetMatchingGroup(function(c)return c:IsAbleToDeck() or c:IsAbleToHand()end,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		if #g>1 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,7))
			local sg=g:SelectSubGroup(tp,function(g,c)return g:IsContains(c)end,false,1,2,tc)
			for sc in aux.Next(sg) do
				Duel.HintSelection(Group.FromCards(sc))
				local op=aux.SelectFromOptions(tp,{sc:IsAbleToHand(),1104},{sc:IsAbleToHand(),1105})
				if op==1 then Duel.SendtoHand(sc,nil,REASON_EFFECT) elseif op==2 then Duel.SendtoDeck(sc,nil,2,REASON_EFFECT) end
			end
		end
	end
end
function s.acfilter(c,tp,g)
	if c:GetFlagEffect(id+33)>0 then return false end
	local le={c:GetActivateEffect()}
	local le2=(Atori_GetActivateEffect and {Atori_GetActivateEffect(c)}) or {}
	for k,v in pairs(le2) do if not SNNM.IsInTable(v,le) then table.insert(le,le2[k]) end end
	local t={}
	for _,v in pairs(le) do
		--Debug.Message(v:GetOperation()==s.desop)
		--if v:GetOperation()==s.desop then Debug.Message(#le) Debug.Message(v:GetRange()) end
		if v:GetOperation()==s.desop and (c:IsLocation(v:GetRange()&(~LOCATION_HAND)) or (c:IsLocation(LOCATION_HAND) and c:IsHasEffect(EFFECT_TRAP_ACT_IN_HAND,tp))) and (not c:IsLocation(LOCATION_SZONE) or (not c:IsStatus(STATUS_SET_TURN) or c:IsHasEffect(EFFECT_TRAP_ACT_IN_SET_TURN,tp))) and Duel.IsExistingTarget(s.desfilter,tp,LOCATION_ONFIELD,0,1,g) and not c:IsStatus(STATUS_LEAVE_CONFIRMED) then
			--Debug.Message(999)
			--[[local e1=Effect.CreateEffect(c)
			e1:SetCategory(CATEGORY_TOHAND)
			e1:SetType(EFFECT_TYPE_ACTIVATE)
			e1:SetCode(EVENT_FREE_CHAIN)
			e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
			e1:SetRange(v:GetRange())
			--e1:SetCondition(s.thcon)
			c:RegisterEffect(e1,true)--]]
			v:SetCode(EVENT_FREE_CHAIN)
			v:SetCondition(aux.TRUE)
			--Debug.Message(v:IsActivatable(tp))
			if v:IsActivatable(tp) then table.insert(t,v) end
			v:SetCode(EVENT_CUSTOM+id)
			v:SetCondition(s.descon)
			--e1:Reset()
		end
	end
	--if #t==0 then return false end
	return #t>0 and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function s.repfilter(c,tp)
	return c:IsFaceup() and c:GetOriginalType()&TYPE_MONSTER~=0 and c:IsControler(tp) and c:IsOnField() and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=eg:Filter(s.repfilter,nil,tp)
	local ag=Duel.GetMatchingGroup(s.acfilter,tp,0xff,0xff,nil,tp,rg)
	if chk==0 then return #ag>0 and #rg>0 end
	if Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		local tc=SNNM.Select_1(ag,tp,aux.Stringid(id,3))
		--Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,3))
		--local tc=ag:Select(tp,1,1,nil):GetFirst()
		Duel.ConfirmCards(1-tp,tc)
		Duel.Hint(HINT_CARD,0,id)
		tc:RegisterFlagEffect(id,RESET_CHAIN,0,1)
		Duel.RaiseEvent(rg,EVENT_CUSTOM+id,re,r,rp,ep,ev)
		tc:RegisterFlagEffect(id+33,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
		return true
	else return false end
end
function s.repval(e,c)
	return s.repfilter(c,e:GetHandlerPlayer())
end
function s.spfilter(c,e,tp)
	return c:IsAttack(0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if #g>0 then Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) end
	end
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_DISEFFECT)
	e3:SetValue(s.efilter)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_DISABLE)
	e4:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e4:SetTarget(s.indtg)
	e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,tp)
end
function s.efilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	local tc=te:GetHandler()
	return tc:GetOriginalType()&TYPE_MONSTER~=0 and tc:GetFlagEffect(id+66)>0
end
function s.indtg(e,c)
	return c:GetOriginalType()&TYPE_MONSTER~=0 and c:GetFlagEffect(id+66)>0
end
