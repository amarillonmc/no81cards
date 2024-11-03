--注定一抽
m=91000000
cm=c91000000
function c91000000.initial_effect(c)
	c:EnableReviveLimit()
	--无 效 对 方 效 果
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,7))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(cm.con1)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	--设 置 局 面
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,14))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetTarget(cm.target2)
	e2:SetOperation(cm.activate)
	c:RegisterEffect(e2)
	local e12=e2:Clone()
	e12:SetType(EFFECT_TYPE_QUICK_O)
	e12:SetCode(EVENT_FREE_CHAIN)
	e12:SetHintTiming(0,TIMING_END)
	e12:SetCondition(cm.con12)
	c:RegisterEffect(e12)
	--印 卡
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_EXTRA) 
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.operation3)
	c:RegisterEffect(e3)
	local e13=e3:Clone()
	e13:SetType(EFFECT_TYPE_QUICK_O)
	e13:SetCode(EVENT_FREE_CHAIN)
	e13:SetHintTiming(0,TIMING_END)
	e13:SetCondition(cm.con12)
	c:RegisterEffect(e13)
	--二 速 设 置 局 面
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,9))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_EXTRA) 
	e4:SetOperation(cm.op4)
	c:RegisterEffect(e4) 
	--回 合 跳 过
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,4))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_EXTRA)   
	e5:SetTarget(cm.target2)
	e5:SetOperation(cm.op5)
	c:RegisterEffect(e5)
	local e11=e5:Clone()
	e11:SetType(EFFECT_TYPE_QUICK_O)
	e11:SetCode(EVENT_FREE_CHAIN)
	e11:SetHintTiming(0,TIMING_STANDBY_PHASE)
	e11:SetCondition(cm.con12)
	c:RegisterEffect(e11)
	--设 置 自 肃 
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,15))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_EXTRA)
	e6:SetTarget(cm.target2)
	e6:SetOperation(cm.op6)
   
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if tgp~=tp and (te:IsActiveType(TYPE_MONSTER) or te:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(i) then
			return true
		end
	end
	return false
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return true end
	local ng=Group.CreateGroup()
	local dg=Group.CreateGroup()
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if tgp~=tp and (te:IsActiveType(TYPE_MONSTER) or te:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(i) then
			local tc=te:GetHandler()
			ng:AddCard(tc)
			if tc:IsOnField() and tc:IsRelateToEffect(te) and tc:IsAbleToDeck() then
				dg:AddCard(tc)
			end
		end
	end
	Duel.SetTargetCard(dg)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,ng,ng:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,dg,dg:GetCount(),0,0)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp)
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
	Duel.SetChainLimit(aux.FALSE)
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end  
	Duel.SetChainLimit(aux.FALSE)
end

function cm.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
 local dg=Group.CreateGroup()
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if tgp~=tp and (te:IsActiveType(TYPE_MONSTER) or te:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.NegateActivation(i) then
			local tc=te:GetHandler()
			if tc:IsRelateToEffect(e) and tc:IsRelateToEffect(te) and tc:IsAbleToDeck() then
				tc:CancelToGrave()
				dg:AddCard(tc)
			end
		end
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp) 
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,nil) 
	local op=Duel.SelectOption(tp,aux.Stringid(m,6),aux.Stringid(m,11),aux.Stringid(m,10),aux.Stringid(m,13),aux.Stringid(m,14),aux.Stringid(m,12))
	if op==0 then
	local sg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND,1,20,nil)
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	elseif op==1 then 
	local sg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD+LOCATION_HAND,LOCATION_ONFIELD+LOCATION_HAND,1,20,nil)
	Duel.Destroy(sg,REASON_EFFECT)
	elseif op==2 then 
	local sg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,20,nil)
	local tc=sg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		tc=sg:GetNext()
	end  
	elseif op==3 then
	local sg=g:Select(tp,1,40,nil)
	Duel.Exile(sg,REASON_EFFECT)
	elseif op==0 then
	local sg=g:Select(tp,1,40,nil)
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	elseif op==5 then
	local sg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local tc=sg:GetFirst()
	local t={}
	local i=1
	local p=1
	for i=1,10 do t[i]=i end
	local a=Duel.AnnounceNumber(tp,table.unpack(t))
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	e1:SetValue(a*1000)
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	tc:RegisterEffect(e2)
	elseif op==4 then
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_HAND+LOCATION_SZONE+LOCATION_DECK+LOCATION_EXTRA)
	Duel.ConfirmCards(tp,g2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:Select(tp,0,40,nil)
	Duel.SendtoDeck(sg,nil,3,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg1=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_DECK,0,0,60,nil)
	Duel.SendtoHand(sg1,tp,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg2=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA,0,0,60,nil)
	local sgn=sg2:Filter(Card.IsType,nil,TYPE_MONSTER)
	if sgn:GetCount()>0 then
	local sgn1=sgn:GetFirst()
		while sgn1 do 
		sgn1:CompleteProcedure()
		sgn1=sgn:GetNext()
		end
	end
	Duel.SendtoGrave(sg2,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg3=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA+LOCATION_GRAVE,0,0,6,nil,TYPE_MONSTER)
	local xyz=sg3:GetFirst()
		while xyz do 
			if xyz:IsType(TYPE_XYZ) then  
			Duel.SpecialSummon(sg3,SUMMON_TYPE_XYZ,tp,tp,true,true,POS_FACEUP)  
			local g1=Duel.SelectMatchingCard(tp,nil,tp,1,0,1,99,nil)
			Duel.Overlay(xyz,g1)
			elseif xyz:IsType(TYPE_SYNCHRO) then
			Duel.SpecialSummon(sg3,SUMMON_TYPE_SYNCHRO,tp,tp,true,true,POS_FACEUP)		   
			elseif xyz:IsType(TYPE_FUSION) then
			Duel.SpecialSummon(sg3,SUMMON_TYPE_FUSION,tp,tp,true,true,POS_FACEUP)  
			elseif xyz:IsType(TYPE_LINK) then
			Duel.SpecialSummon(sg3,SUMMON_TYPE_LINK,tp,tp,true,true,POS_FACEUP)   
			else
			Duel.SpecialSummon(sg3,0,tp,tp,true,true,POS_FACEUP)
			end
		xyz=sg3:GetNext()
		end
	if Duel.SelectYesNo(tp,aux.Stringid(m,15)) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg1=Duel.SelectMatchingCard(tp,aux.TRUE,1-tp,LOCATION_DECK,0,0,60,nil)
	Duel.SendtoHand(sg1,1-tp,REASON_EFFECT)
	--Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
   -- local sg2=Duel.SelectMatchingCard(tp,aux.TRUE,1-tp,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA,0,0,60,nil)
   -- local sgn=sg2:Filter(Card.IsType,nil,TYPE_MONSTER)
  --  if sgn:GetCount()>0 then
   -- local sgn1=sgn:GetFirst()
   --   while sgn1 do 
  --	  sgn1:CompleteProcedure()
  --	  sgn1=sgn:GetNext()
  --	  end
   -- end
   -- Duel.SendtoGrave(sg2,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg3=Duel.SelectMatchingCard(tp,Card.IsType,1-tp,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA+LOCATION_GRAVE,0,0,6,nil,TYPE_MONSTER)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	Duel.SpecialSummon(sg3,0,tp,1-tp,true,true,POS_FACEUP)
	end
	end
end
function cm.fitn1(c)
	return c:IsPreviousLocation(LOCATION_EXTRA)
end
function cm.con12(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp or Duel.GetFlagEffect(tp,m)>0
end
function cm.operation3(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)   
	local f=Duel.AnnounceNumber(tp,1,2,3,4,5,6)
	local b=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1),aux.Stringid(m,5),aux.Stringid(m,6),aux.Stringid(m,8),aux.Stringid(m,3))
	if b==1 then
	for i=1,f do
	local g1=Duel.CreateToken(tp,ac)   
	local g2=Group.FromCards(g1)
	Duel.SendtoDeck(g2,tp,2,REASON_EFFECT)
	end
	elseif b==0 then
	if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
	for i=1,f do
	local g1=Duel.CreateToken(tp,ac)   
	local g2=Group.FromCards(g1)
	Duel.SendtoHand(g2,tp,REASON_EFFECT)	
	end
	else
	for i=1,f do
	local g1=Duel.CreateToken(tp,ac)   
	local g2=Group.FromCards(g1)
	Duel.SendtoHand(g2,1-tp,REASON_EFFECT)  
	end
	end
	elseif b==2 then
	for i=1,f do
	local g1=Duel.CreateToken(tp,ac)   
	local g2=Group.FromCards(g1)
	Duel.SendtoGrave(g2,tp,REASON_EFFECT)
	end
	elseif b==3 then
	if Duel.SelectYesNo(tp,aux.Stringid(m,6)) then
		for i=1,f do
		local g1=Duel.CreateToken(tp,ac)   
		local g2=Group.FromCards(g1)
		Duel.Remove(g2,POS_FACEUP,REASON_EFFECT)
		end
		else
		for i=1,f do
		local g1=Duel.CreateToken(tp,ac)   
		local g2=Group.FromCards(g1)
		Duel.Remove(g2,POS_FACEDOWN,REASON_EFFECT)
		end
	end
	elseif b==4 then
	if Duel.SelectYesNo(tp,aux.Stringid(m,8)) then
		for i=1,f do
		local g1=Duel.CreateToken(tp,ac)   
		local g2=Group.FromCards(g1)
		Duel.SSet(tp,g2)
		local tc=g2:GetFirst()
		 local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
		else
		for i=1,f do
		local g1=Duel.CreateToken(tp,ac)   
		local g2=Group.FromCards(g1)
		Duel.SSet(tp,g2,1-tp)
		local tc=g2:GetFirst()
		 local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
	elseif b==5 then
	if Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
		for i=1,f do
		local g1=Duel.CreateToken(tp,ac)   
		local g2=Group.FromCards(g1)
		Duel.SpecialSummon(g2,0,tp,tp,true,true,POS_FACEUP+POS_FACEDOWN_DEFENSE)
		end
	else
		for i=1,f do
		local g1=Duel.CreateToken(tp,ac)   
		local g2=Group.FromCards(g1)
		Duel.SpecialSummon(g2,0,tp,1-tp,true,true,POS_FACEUP+POS_FACEDOWN_DEFENSE)
		end
	end
	end
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
local tp=Duel.GetTurnPlayer()
				if Duel.GetCurrentPhase()==PHASE_DRAW then
					Duel.SkipPhase(tp,PHASE_DRAW,RESET_PHASE+PHASE_END,1)
					Duel.SkipPhase(tp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
					Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
					Duel.SkipPhase(tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1)
					Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
					Duel.SkipPhase(tp,PHASE_END,RESET_PHASE+PHASE_END,1)
				elseif Duel.GetCurrentPhase()==PHASE_STANDBY then
					Duel.SkipPhase(tp,PHASE_STANDBY,RESET_PHASE+PHASE_END,2)
					Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
					Duel.SkipPhase(tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1)
					Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
					Duel.SkipPhase(tp,PHASE_END,RESET_PHASE+PHASE_END,1)
				elseif Duel.GetCurrentPhase()==PHASE_MAIN1 then
					Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
					Duel.SkipPhase(tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1)
					Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
					Duel.SkipPhase(tp,PHASE_END,RESET_PHASE+PHASE_END,1)
				elseif Duel.GetCurrentPhase()==PHASE_BATTLE then
					Duel.SkipPhase(tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1)
					Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
					Duel.SkipPhase(tp,PHASE_END,RESET_PHASE+PHASE_END,1)
				elseif Duel.GetCurrentPhase()==PHASE_MAIN2 then
					Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
					Duel.SkipPhase(tp,PHASE_END,RESET_PHASE+PHASE_END,1)
				elseif Duel.GetCurrentPhase()==PHASE_END then
					Duel.SkipPhase(tp,PHASE_END,RESET_PHASE+PHASE_END,1)
				end 
end 
function cm.NTR_Reform(effect)
				local eff=effect:Clone()
				local con=eff:GetCondition()
				local cost=eff:GetCost()
				local target=eff:GetTarget()
				local operation=eff:GetOperation()
				local pro=eff:GetProperty()
				if not eff:IsHasProperty(EFFECT_FLAG_BOTH_SIDE) and eff:IsHasType(EFFECT_TYPE_TRIGGER_O|EFFECT_TYPE_TRIGGER_F|EFFECT_TYPE_IGNITION|EFFECT_TYPE_QUICK_F|EFFECT_TYPE_QUICK_O|EFFECT_TYPE_FLIP|EFFECT_TYPE_ACTIVATE) then
					eff:SetProperty(pro+EFFECT_FLAG_BOTH_SIDE)
					if con then
						eff:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
							if tp~=e:GetHandler():GetOwner() and not Duel.IsPlayerAffectedByEffect(tp,id) then return false end
							if tp~=e:GetHandler():GetOwner() and Duel.IsPlayerAffectedByEffect(tp,id) then return con(e,1-tp,eg,ep,ev,re,r,rp) end
							return con(e,tp,eg,ep,ev,re,r,rp)
						end)
					else
						eff:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
							if tp~=e:GetHandler():GetOwner() and not Duel.IsPlayerAffectedByEffect(tp,id) then return false end
							return true 
						end)
					end
					if cost then
						eff:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
							if tp~=e:GetHandler():GetOwner() and not Duel.IsPlayerAffectedByEffect(tp,id) then return false end
							if tp~=e:GetHandler():GetOwner() and Duel.IsPlayerAffectedByEffect(tp,id) then 
								if chk==0 then
									return cost(e,1-tp,eg,ep,ev,re,r,rp,0)
								end
								NTR_Effect_Blacklotus=true
								cost(e,1-tp,eg,ep,ev,re,r,rp,chk)
								NTR_Effect_Blacklotus=false
							else
								if chk==0 then
									return cost(e,tp,eg,ep,ev,re,r,rp,0)
								end
								cost(e,tp,eg,ep,ev,re,r,rp,chk)
							end
						end)
					end
					if target then
						eff:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
							if tp~=e:GetHandler():GetOwner() and not Duel.IsPlayerAffectedByEffect(tp,id) then return false end
							if tp~=e:GetHandler():GetOwner() and Duel.IsPlayerAffectedByEffect(tp,id) then 
								if chkc==0 then
									return target(e,1-tp,eg,ep,ev,re,r,rp,chk,0)
								end
								if chk==0 then
									return target(e,1-tp,eg,ep,ev,re,r,rp,0,chkc)
								end
								NTR_Effect_Blacklotus=true
								target(e,1-tp,eg,ep,ev,re,r,rp,chk,chkc)
								NTR_Effect_Blacklotus=false
							else
								if chkc==0 then
									return target(e,tp,eg,ep,ev,re,r,rp,chk,0)
								end
								if chk==0 then
									return target(e,tp,eg,ep,ev,re,r,rp,0,chkc)
								end
								target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
							end
						end)
					end
					if operation then
						eff:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
							if tp~=e:GetHandler():GetOwner() and not Duel.IsPlayerAffectedByEffect(tp,id) then return false end
							if tp~=e:GetHandler():GetOwner() and Duel.IsPlayerAffectedByEffect(tp,id) then 
								NTR_Effect_Blacklotus=true
								operation(e,1-tp,eg,ep,ev,re,r,rp)
								NTR_Effect_Blacklotus=false
							else
								operation(e,tp,eg,ep,ev,re,r,rp)
							end
						end)
					end
				end
	return eff
end
function cm.op6(e,tp,eg,ep,ev,re,r,rp)
local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_LIMIT_SPECIAL_SUMMON_POSITION)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,1)
	e4:SetTarget(aux.TRUE)
	c:RegisterEffect(e4)
end
function cm.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return bit.band(sumpos,POS_FACEUP_DEFENSE)>0
end














