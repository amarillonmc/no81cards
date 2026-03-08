local m=98500345
local cm=_G["c"..m]
cm.name="神力解放！"
function cm.initial_effect(c)
	aux.AddCodeList(c,10000020,10000010,10000000)
	--
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(cm.handcon1)
	c:RegisterEffect(e0)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_DEFCHANGE+CATEGORY_DISABLE+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetTarget(cm.destg)
	e1:SetOperation(cm.desop)
	c:RegisterEffect(e1)
end
function cm.filter1(c)
	return c:IsFaceup() and c:IsRace(RACE_DIVINE) and c:IsType(TYPE_FUSION)
end
function cm.handcon1(e)
	return Duel.IsExistingMatchingCard(cm.filter1,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function cm.actfilter1(c)
	return c:IsFaceup() and c:IsCode(10000020) or (c:IsRace(RACE_DIVINE) and c:IsType(TYPE_FUSION))
end
function cm.actfilter2(c)
	 return c:IsFaceup() and c:IsCode(10000000) or (c:IsRace(RACE_DIVINE) and c:IsType(TYPE_FUSION))
end
function cm.actfilter3(c)
	 return c:IsType(TYPE_MONSTER) and not (c:IsCode(10000000) or (c:IsRace(RACE_DIVINE) and c:IsType(TYPE_FUSION)))
end
function cm.actfilter4(c)
	return c:IsFaceup() and (c:IsCode(10000010) or (c:IsRace(RACE_DIVINE) and c:IsType(TYPE_FUSION))) and c:GetFlagEffect(m)==0
end
function cm.actfilter5(c)
	return c:IsFaceup() and (c:IsCode(10000020) or (c:IsRace(RACE_DIVINE) and c:IsType(TYPE_FUSION))) and c:GetFlagEffect(m+1)==0
end
function cm.actfilter6(c)
	 return c:IsFaceup() and (aux.IsMaterialListCode(c,10000000) and c:IsType(TYPE_FUSION)) and c:IsAttackAbove(4000)
end
function cm.actfilter7(c)
	return c:IsFaceup() and (c:IsCode(10000010) or (c:IsRace(RACE_DIVINE) and c:IsType(TYPE_FUSION))) 
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(cm.actfilter1,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) and (not e:IsCostChecked() or Duel.GetFlagEffect(tp,m)==0) 
	local b2=Duel.IsExistingMatchingCard(cm.actfilter2,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(aux.NegateEffectMonsterFilter,tp,0,LOCATION_MZONE,1,nil) and (not e:IsCostChecked() or Duel.GetFlagEffect(tp,m+1)==0)
	local b3=Duel.CheckReleaseGroup(tp,cm.actfilter3,2,nil) and Duel.IsExistingMatchingCard(cm.actfilter2,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) and (not e:IsCostChecked() or Duel.GetFlagEffect(tp,m+2)==0)
	local b4=Duel.IsExistingMatchingCard(cm.actfilter4,tp,LOCATION_MZONE,0,1,nil) and (not e:IsCostChecked() or Duel.GetFlagEffect(tp,m+3)==0)
	local b5=Duel.IsExistingMatchingCard(cm.actfilter5,tp,LOCATION_MZONE,0,1,nil) and (not e:IsCostChecked() or Duel.GetFlagEffect(tp,m+4)==0)
	local b6=Duel.IsExistingMatchingCard(cm.actfilter6,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) and (not e:IsCostChecked() or Duel.GetFlagEffect(tp,m+2)==0)
	local b7=Duel.IsExistingMatchingCard(cm.actfilter7, tp, LOCATION_MZONE, 0, 1, nil)
		and Duel.GetLP(tp)>100 and (not e:IsCostChecked() or Duel.GetFlagEffect(tp,m+5)==0)
	if chk==0 then return b1 or b2 or b3 or b4 or b5 or b6 or b7 end
	local op=0
	if b1 or b2 or b3 or b4 or b5 or b6 or b7 then
		op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(m,0),0},
			{b2,aux.Stringid(m,1),1},
			{b3,aux.Stringid(m,2),2},
			{b4,aux.Stringid(m,3),3},
			{b5,aux.Stringid(m,4),4},
			{b6,aux.Stringid(m,8),5},
			{b7,aux.Stringid(m,5),6})
	end
	e:SetLabel(op)
	if op==0 then
	if e:IsCostChecked() then
	e:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	if g:GetCount()~=0 then
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,g:GetCount())   
	end
	elseif op==1 then
	if e:IsCostChecked() then
	e:SetCategory(CATEGORY_DESTROY+CATEGORY_DISABLE)
	Duel.RegisterFlagEffect(tp,m+1,RESET_PHASE+PHASE_END,0,1)
	end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
	elseif op==2 then
	if e:IsCostChecked() then
	e:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	Duel.RegisterFlagEffect(tp,m+2,RESET_PHASE+PHASE_END,0,1)
	end
	local g1=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,g1:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,4000)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(4000)
	elseif op==3 then
	if e:IsCostChecked() then
	Duel.RegisterFlagEffect(tp,m+3,RESET_PHASE+PHASE_END,0,1)
	end
	elseif op==4 then
	if e:IsCostChecked() then
	Duel.RegisterFlagEffect(tp,m+4,RESET_PHASE+PHASE_END,0,1)
	end
	elseif op==5 then
	if e:IsCostChecked() then
	e:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	Duel.RegisterFlagEffect(tp,m+2,RESET_PHASE+PHASE_END,0,1)
	end
	local g1=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,g1:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,4000)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(4000)
	elseif op==6 then
	if e:IsCostChecked() then
	e:SetCategory(CATEGORY_RECOVER)
	local lp = Duel.GetLP(tp)
	local diff = lp - 100
	Duel.SetOperationInfo(0, CATEGORY_LPCHANGE, nil, 0, tp, -diff)
	Duel.SetOperationInfo(0, CATEGORY_ATKCHANGE, nil, 0, 0, diff)
	Duel.SetOperationInfo(0, CATEGORY_DEFCHANGE, nil, 0, 0, diff)
	Duel.RegisterFlagEffect(tp,m+5,RESET_PHASE+PHASE_END,0,1)
	end
	end
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==0 then
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(g,REASON_EFFECT)
	local dc=Duel.GetOperatedGroup():FilterCount(cm.sgfilter,nil,1-tp)
	if dc~=0 and Duel.IsTurnPlayer(tp) and Duel.IsMainPhase() and Duel.IsPlayerCanDraw(tp,dc)
		and Duel.SelectYesNo(tp,aux.Stringid(m,6)) then
		Duel.BreakEffect()
		Duel.Draw(tp,dc,REASON_EFFECT)
		--cannot attack
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetCondition(cm.atkcon)
		e1:SetTarget(cm.atktg)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		--check
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EVENT_ATTACK_ANNOUNCE)
		e2:SetReset(RESET_PHASE+PHASE_END)
		e2:SetOperation(cm.checkop)
		e2:SetLabelObject(e1)
		Duel.RegisterEffect(e2,tp)
   end
   elseif op==1 then
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
   local g=Duel.SelectMatchingCard(tp,aux.NegateEffectMonsterFilter,tp,0,LOCATION_MZONE,1,1,nil)
   if g:GetCount()>0 then
		local tc=g:GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		Duel.AdjustInstantly()
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetCode(EFFECT_DISABLE)
			e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
			e3:SetTarget(cm.distg)
			e3:SetLabelObject(tc)
			e3:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e3,tp)
			local e4=Effect.CreateEffect(e:GetHandler())
			e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e4:SetCode(EVENT_CHAIN_SOLVING)
			e4:SetCondition(cm.discon)
			e4:SetOperation(cm.disop)
			e4:SetLabelObject(tc)
			e4:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e4,tp)
			local sg=Duel.GetMatchingGroup(cm.desfilter,tp,0,LOCATION_ONFIELD,nil)
			if #sg>0 and Duel.GetTurnPlayer()==tp
				and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
				and Duel.SelectYesNo(tp,aux.Stringid(cm,7)) then
				Duel.BreakEffect()
				Duel.Destroy(sg,REASON_EFFECT)
			end
		end
	end
	elseif op==5 then
	local g2=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	if Duel.Destroy(g2,REASON_EFFECT)~=0 then
	   local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Damage(p,d,REASON_EFFECT)
	end
	elseif op==2 then
	local g=Duel.GetMatchingGroup(cm.actfilter2,tp,LOCATION_MZONE,0,nil)
	local rg=Duel.SelectReleaseGroup(tp,Card.IsFaceup,2,2,g)
	if Duel.Release(rg,REASON_RELEASE)~=0 then 
	local g2=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	if Duel.Destroy(g2,REASON_EFFECT)~=0 then
	   local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Damage(p,d,REASON_EFFECT)
	   end
	end
	elseif op==3 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,cm.actfilter4,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.HintSelection(g)
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(cm.efilter1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(tc)
		e2:SetCategory(CATEGORY_ATKCHANGE)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e2:SetCode(EVENT_ATTACK_ANNOUNCE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e2:SetCondition(cm.atkcon1)
		e2:SetCost(cm.atkcost1)
		e2:SetTarget(cm.atktg1)
		e2:SetOperation(cm.atkop1)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(tc)
		e3:SetCategory(CATEGORY_TOGRAVE)
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e3:SetCode(EVENT_BATTLED)
		e3:SetRange(LOCATION_MZONE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e3:SetCondition(cm.tgcon1)
		e3:SetTarget(cm.tgtg1)
		e3:SetOperation(cm.tgop1)
		tc:RegisterEffect(e3)
		if not tc:IsType(TYPE_EFFECT) then
			local e4=Effect.CreateEffect(e:GetHandler())
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_ADD_TYPE)
			e4:SetValue(TYPE_EFFECT)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e4)
		end
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,9))
	end
	elseif op==4 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,cm.actfilter5,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.HintSelection(g)
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(2500)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(tc)
		e3:SetDescription(aux.Stringid(m,1))
		e3:SetCategory(CATEGORY_ATKCHANGE)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e3:SetCode(EVENT_SUMMON_SUCCESS)
		e3:SetRange(LOCATION_MZONE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e3:SetTarget(cm.atktg1)
		e3:SetOperation(cm.atkop1)
		tc:RegisterEffect(e3)
		local e4=e3:Clone()
		e4:SetCode(EVENT_SPSUMMON_SUCCESS)
		tc:RegisterEffect(e4)
		if not tc:IsType(TYPE_EFFECT) then
			local e4=Effect.CreateEffect(e:GetHandler())
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_ADD_TYPE)
			e4:SetValue(TYPE_EFFECT)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e4)
		end
		tc:RegisterFlagEffect(m+1,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,10))
	end
	elseif op==6 then
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_FACEUP)
	local g = Duel.SelectMatchingCard(tp, cm.actfilter7, tp, LOCATION_MZONE, 0, 1, 1, nil)
	if #g == 0 then return end
	local tc = g:GetFirst()
	local lp = Duel.GetLP(tp)
	local diff = lp - 100
	Duel.SetLP(tp, 100)

	-- 上升攻击力
	local e1 = Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(diff)
	e1:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE + EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	tc:RegisterEffect(e1)

	-- 上升守备力
	local e2 = e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	tc:RegisterEffect(e2)

	-- 回合结束回复部分
	local lost_eff = Effect.CreateEffect(e:GetHandler())
	lost_eff:SetLabel(diff)
	local damage_eff = Effect.CreateEffect(e:GetHandler())
	damage_eff:SetLabel(0)
	lost_eff:SetLabelObject(damage_eff)

	-- 伤害记录器
	local e3 = Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_CONTINUOUS + EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_DAMAGE)
	e3:SetOperation(function(e, tp, eg, ep, ev, re, r, rp)
		if (r & REASON_BATTLE) == REASON_BATTLE and ep == 1 - tp then
			local d_eff = e:GetLabelObject()
			local new_damage = d_eff:GetLabel() + ev
			d_eff:SetLabel(new_damage)
		end
	end)
	e3:SetReset(RESET_PHASE + PHASE_END)
	e3:SetLabelObject(damage_eff)
	Duel.RegisterEffect(e3, tp)

	-- 回合结束回复
	local e4 = Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PHASE + PHASE_END)
	e4:SetCountLimit(1)
	e4:SetOperation(function(e, tp)
		local lost_eff = e:GetLabelObject()
		local lost = lost_eff:GetLabel()
		local damage_eff = lost_eff:GetLabelObject()
		local damage = damage_eff:GetLabel()
		local recover = lost + damage
		if recover > 0 then
			Duel.Recover(tp, recover, REASON_EFFECT)
		end
	end)
	e4:SetReset(RESET_PHASE + PHASE_END)
	e4:SetLabelObject(lost_eff)
	Duel.RegisterEffect(e4, tp)
   end
   
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,cm)~=0 then return end
	local fid=eg:GetFirst():GetFieldID()
	Duel.RegisterFlagEffect(tp,cm,RESET_PHASE+PHASE_END,0,1)
	e:GetLabelObject():SetLabel(fid)
end
function cm.atkcon(e)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),cm)~=0
end
function cm.atktg(e,c)
	return c:GetFieldID()~=e:GetLabel()
end
function cm.sgfilter(c,p)
	return c:IsLocation(LOCATION_GRAVE) and c:IsControler(p)
end
function cm.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.distg(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function cm.efilter1(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function cm.atkcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (Duel.GetAttacker()==c or Duel.GetAttackTarget()==c)
end
function cm.atkfilter1(c,tp)
	return c:GetAttackAnnouncedCount()==0 and c:GetTextAttack()>0 and (c:IsControler(tp) or c:IsFaceup())
end
function cm.atkcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100,0)
	local g=Duel.GetReleaseGroup(tp):Filter(cm.atkfilter1,e:GetHandler(),tp)
	if chk==0 then return g:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=g:Select(tp,1,g:GetCount(),nil)
	aux.UseExtraReleaseCount(rg,tp)
	Duel.Release(rg,REASON_COST)
	local atk=rg:GetSum(Card.GetTextAttack)
	e:SetLabel(100,atk)
end
function cm.atktg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local label,atk=e:GetLabel()
	if chk==0 then
		e:SetLabel(0,0)
		if label~=100 then return false end
		return true
	end
	e:SetLabel(0,0)
	Duel.SetTargetParam(atk)
end
function cm.atkop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local atk=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function cm.tgcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()==e:GetHandler()
end
function cm.tgtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function cm.tgop1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function cm.atkfilter1(c,tp)
	return c:IsControler(tp) and c:IsPosition(POS_FACEUP_DEFENSE)
end
function cm.atktg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(cm.atkfilter1,1,e:GetHandler(),1-tp) end
	local g=eg:Filter(cm.atkfilter1,e:GetHandler(),1-tp)
	Duel.SetTargetCard(g)
end
function cm.atkop1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain():Filter(Card.IsFaceup,nil)
	local dg=Group.CreateGroup()
	local c=e:GetHandler()
	local tc=g:GetFirst()
	while tc do
		local predef=tc:GetDefense()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(-2000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		if predef~=0 and tc:IsDefense(0) then dg:AddCard(tc) end
		tc=g:GetNext()
	end
	Duel.Destroy(dg,REASON_EFFECT)
end