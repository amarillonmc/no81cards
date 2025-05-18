--超时空战斗机-除蜂战机
local m=13257378
local cm=_G["c"..m]
xpcall(function() require("expansions/script/tama") end,function() require("script/tama") end)
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(cm.atkval)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.econ)
	e3:SetValue(cm.efilter)
	c:RegisterEffect(e3)
	--Power Capsule
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCondition(cm.pccon)
	e4:SetTarget(cm.pctg)
	e4:SetOperation(cm.pcop)
	c:RegisterEffect(e4)
	eflist={{"power_capsule",e4}}
	cm[c]=eflist
	
end
function cm.filter(c,m)
	return c:IsFaceup() and c:IsCode(m)
end
function cm.atkval(e,c)
	local g=Duel.GetMatchingGroup(cm.filter,c:GetControler(),LOCATION_MZONE,0,c,c:GetCode())
	return g:GetCount()*1200
end
function cm.econ(e)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(cm.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,2,c,c:GetCode())
end
function cm.efilter(e,te)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and not(g~=nil and g:IsContains(c))
end
function cm.pcfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function cm.pccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.pcfilter,1,nil,1-tp)
end
function cm.spfilter(c,e,tp)
	return c:IsCode(m) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local t1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)
	local t2=true
	if chk==0 then return t1 or t2 end
	local op=0
	if t1 or t2 then
		local m1={}
		local n1={}
		local ct=1
		if t1 then m1[ct]=aux.Stringid(m,1) n1[ct]=1 ct=ct+1 end
		if t2 then m1[ct]=aux.Stringid(m,2) n1[ct]=2 ct=ct+1 end
		local sp=Duel.SelectOption(tp,table.unpack(m1))
		op=n1[sp+1]
	end
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	elseif op==2 then
	end
end
function cm.pcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==1 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	elseif e:GetLabel()==2 then
		if c:IsRelateToEffect(e) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			c:RegisterEffect(e2)
		end
		if Duel.GetFlagEffect(tp,m)<=0 then
			Duel.RegisterFlagEffect(tp,m,0,0,0,0)
		end
		local ct=Duel.GetFlagEffectLabel(tp,m)
		if ct<2 then
			Duel.SetFlagEffectLabel(tp,m,ct+1)
		else
			Duel.SetFlagEffectLabel(tp,m,0)
			local ph=Duel.GetCurrentPhase()
			local tct=Duel.GetTurnCount()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_SKIP_M1)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(0,1)
			if Duel.GetTurnPlayer()==1-tp and ph>=PHASE_MAIN1 then
				e1:SetLabel(tct)
				e1:SetCondition(cm.bpcon)
				e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
			else
				e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
			end
			Duel.RegisterEffect(e1,tp)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_SKIP_BP)
			if Duel.GetTurnPlayer()==1-tp and ph>PHASE_MAIN1 and ph<PHASE_MAIN2 then
				e2:SetLabel(tct)
				e2:SetCondition(cm.bpcon)
				e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
			else
				e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
			end
			Duel.RegisterEffect(e2,tp)
			local e3=e1:Clone()
			e3:SetCode(EFFECT_SKIP_M2)
			if Duel.GetTurnPlayer()==1-tp and ph>=PHASE_MAIN2 then
				e3:SetLabel(tct)
				e3:SetCondition(cm.bpcon)
				e3:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
			else
				e3:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
			end
			Duel.RegisterEffect(e3,tp)
			
			local e4=Effect.CreateEffect(e:GetHandler())
			e4:SetType(EFFECT_TYPE_FIELD)
			e4:SetCode(EFFECT_SKIP_M1)
			e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e4:SetTargetRange(1,0)
			if Duel.GetTurnPlayer()==tp and ph>=PHASE_MAIN1 then
				e4:SetLabel(tct)
				e4:SetCondition(cm.bpcon)
				e4:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
			else
				e4:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
			end
			Duel.RegisterEffect(e4,tp)
			local e5=e4:Clone()
			e5:SetCode(EFFECT_SKIP_BP)
			if Duel.GetTurnPlayer()==tp and ph>PHASE_MAIN1 and ph<PHASE_MAIN2 then
				e5:SetLabel(tct)
				e5:SetCondition(cm.bpcon)
				e5:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
			else
				e5:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
			end
			Duel.RegisterEffect(e5,tp)
			local e6=e4:Clone()
			e6:SetCode(EFFECT_SKIP_M2)
			if Duel.GetTurnPlayer()==tp and ph>=PHASE_MAIN2 then
				e6:SetLabel(tct)
				e6:SetCondition(cm.bpcon)
				e6:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
			else
				e6:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
			end
			Duel.RegisterEffect(e6,tp)
		end
	end
end
function cm.bpcon(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end
