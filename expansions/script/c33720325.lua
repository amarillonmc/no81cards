--[[
梦镜面的彼端
Behind Glass in Dream
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
Duel.LoadScript("glitchylib_lprecover.lua")
function s.initial_effect(c)
	--Counter Permit workaround for placing counters at activation (do NOT assign the EFFECT_FLAG_SINGLE_RANGE property)
	local ct=Effect.CreateEffect(c)
	ct:SetType(EFFECT_TYPE_SINGLE)
	ct:SetRange(LOCATION_SZONE)
	ct:SetCode(EFFECT_COUNTER_PERMIT|COUNTER_BEHIND_GLASS_IN_DREAM)
	c:RegisterEffect(ct)
	--Activation
	c:Activation()
	--[[You cannot Special Summon monsters, except by the effect of "Behind Glass in Dream".]]
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	c:RegisterEffect(e1)
	--[[Once per Chain: You can Special Summon 1 monster from your hand or GY, and if you do, take damage equal to its Level/Rank/Link Rating x 1200, then place 1 counter on this card for each 100 
	damage you took this way.]]
	local e2=Effect.CreateEffect(c)
	e2:Desc(0,id)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON|CATEGORY_DAMAGE|CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetFunctions(nil,nil,s.sptg,s.spop)
	c:RegisterEffect(e2)
	--[[If you would gain LP, except by the effects of "Behind Glass in Dream", place 1 counter for each 100 LP you would gain on this card instead.]]
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_RECOVER)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(1,0)
	e3:SetValue(s.recval)
	c:RegisterEffect(e3)
	xgl.RegisterChangeBattleRecoverHandler()
	--[[During your Standby Phase: Remove all counters from this card, and if you do, gain LP equal to the amount of counters removed x 50.]]
	local e4=Effect.CreateEffect(c)
	e4:Desc(1,id)
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE|PHASE_STANDBY)
	e4:SetRange(LOCATION_SZONE)
	e4:OPT()
	e4:SetFunctions(aux.TurnPlayerCond(0),nil,s.rctg,s.rcop)
	c:RegisterEffect(e4)
end
--E1
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return se and not se:GetHandler():IsCode(id)
end

--E2
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return not c:HasFlagEffect(id)
			and Duel.GetMZoneCount(tp)>0 and Duel.IsExists(false,Card.IsCanBeSpecialSummoned,tp,LOCATION_HAND|LOCATION_GRAVE,0,1,nil,e,0,tp,false,false)
			and c:IsCanAddCounter(COUNTER_BEHIND_GLASS_IN_DREAM,1,false,LOCATION_SZONE)
	end
	c:RegisterFlagEffect(id,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND|LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,1200)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,c,1,1,COUNTER_BEHIND_GLASS_IN_DREAM)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	local tc=Duel.Select(HINTMSG_SPSUMMON,false,tp,aux.Necro(Card.IsCanBeSpecialSummoned),tp,LOCATION_HAND|LOCATION_GRAVE,0,1,1,nil,e,0,tp,false,false):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 and tc:IsFaceup() then
		local ct=tc:GetRatingAuto()
		if ct>0 then
			local c=e:GetHandler()
			local dam=math.floor(Duel.Damage(tp,ct*1200,REASON_EFFECT)/100)
			if dam>0 and c:IsRelateToChain() and c:IsCanAddCounter(COUNTER_BEHIND_GLASS_IN_DREAM,dam,true) then
				c:AddCounter(COUNTER_BEHIND_GLASS_IN_DREAM,dam,true)
			end
		end
	end
end

--E3
function s.recval(e,r,val,re,chk)
	local c=e:GetHandler()
	local ct=math.floor(val/100)
	if chk==0 then
		if r&REASON_EFFECT>0 then
			if aux.GetValueType(re)=="Effect" then
				local ch=Duel.GetCurrentChain()
				if ch>0 and re:IsActivated() then
					local code,code2=Duel.GetChainInfo(ch,CHAININFO_TRIGGERING_CODE,CHAININFO_TRIGGERING_CODE2)
					if code==id or code2==id then
						return false
					end
				else
					if re:GetHandler():IsCode(id) then
						return false
					end
				end
			end
		end
		return c:IsCanAddCounter(COUNTER_BEHIND_GLASS_IN_DREAM,ct)
	end
	if ct>0 and c:IsCanAddCounter(COUNTER_BEHIND_GLASS_IN_DREAM,ct) then
		c:AddCounter(COUNTER_BEHIND_GLASS_IN_DREAM,ct)
	end
	return 0
end

--E4
function s.rctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	local val=e:GetHandler():GetCounter(COUNTER_BEHIND_GLASS_IN_DREAM)*50
	Duel.SetConditionalOperationInfo(val>0,0,CATEGORY_RECOVER,nil,0,tp,val)
end
function s.rcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and c:IsCanRemoveCounter(tp,COUNTER_BEHIND_GLASS_IN_DREAM,1,REASON_EFFECT) then
		local a=c:GetCounter(COUNTER_BEHIND_GLASS_IN_DREAM)
		if not c:RemoveCounter(tp,COUNTER_BEHIND_GLASS_IN_DREAM,a,REASON_EFFECT) then return end
		local diff=a-c:GetCounter(COUNTER_BEHIND_GLASS_IN_DREAM)
		if diff>0 then
			Duel.Recover(tp,diff*50,REASON_EFFECT)
		end
	end
end