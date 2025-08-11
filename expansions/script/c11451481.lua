--魔人★双子 菈·豪泽尔
local cm,m=GetID()
function cm.initial_effect(c)
	--effect1
	local custom_code=cm.RegisterMergedEvent_ToSingleCard(c,m,EVENT_TO_GRAVE)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(custom_code)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--[[local e1x=e1:Clone()
	e1x:SetCode(EVENT_TO_GRAVE)
	e1x:SetCondition(aux.FALSE)
	c:RegisterEffect(e1x)--]]
	--effect2
	local custom_code2=cm.RegisterMergedEvent_ToSingleCard(c,m,EVENT_TO_HAND)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(custom_code2)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(cm.thcon)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
	--setname
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e5:SetCode(EFFECT_ADD_SETCODE)
	e5:SetRange(0xff)
	e5:SetValue(0x151)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetValue(0x6d)
	c:RegisterEffect(e6)
end
function cm.RegisterMergedEvent_ToSingleCard(c,code,event)
	local g0=Group.CreateGroup()
	g0:KeepAlive()
	local g1=Group.CreateGroup()
	g1:KeepAlive()
	local mt=getmetatable(c)
	local seed=event
	while(mt[seed]==true) do
		seed = seed + 1
	end
	mt[seed]=true
	local event_code_single = (code ~ (seed << 16)) | EVENT_CUSTOM
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(event)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(0xff)
	e1:SetLabel(event_code_single)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
						local c=e:GetOwner()
						if rp==0 then
							g0:Merge(eg:Filter(function(c) return c:IsType(TYPE_MONSTER) end,nil))
						elseif rp==1 then
							g1:Merge(eg:Filter(function(c) return c:IsType(TYPE_MONSTER) end,nil))
						end
						if Duel.CheckEvent(EVENT_MOVE) then
							local _,meg=Duel.CheckEvent(EVENT_MOVE,true)
							if meg:IsContains(c) and (c:IsFaceup() or c:IsPublic()) then
								g0:Clear()
								g1:Clear()
							end
						end
						if Duel.GetCurrentChain()==0 and #g0>0 and not g0:IsExists(function(c) return c:GetEquipCount()>0 or c:GetOverlayCount()>0 end,1,nil) then
							local _eg=g0:Clone()
							Duel.RaiseEvent(_eg,e:GetLabel(),re,r,0,ep,ev)
							g0:Clear()
						end
						if Duel.GetCurrentChain()==0 and #g1>0 and not g1:IsExists(function(c) return c:GetEquipCount()>0 or c:GetOverlayCount()>0 end,1,nil) then
							local _eg1=g1:Clone()
							Duel.RaiseEvent(_eg1,e:GetLabel(),re,r,1,ep,ev)
							g1:Clear()
						end
					end)
	c:RegisterEffect(e1)
	--[[local _GetCode=Effect.GetCode
	function Effect.GetCode(e,...)
		return _GetCode(e,...)==event_code_single and event or _GetCode(e,...)
	end--]]
	local ec={
		EVENT_CHAIN_ACTIVATING,
		EVENT_CHAINING,
		EVENT_ATTACK_ANNOUNCE,
		EVENT_BREAK_EFFECT,
		EVENT_CHAIN_SOLVING,
		EVENT_CHAIN_SOLVED,
		EVENT_CHAIN_END,
		EVENT_SUMMON,
		EVENT_SPSUMMON,
		EVENT_MSET,
		EVENT_BATTLE_DESTROYED
	}
	for _,code in ipairs(ec) do
		local ce=e1:Clone()
		ce:SetCode(code)
		ce:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
							local c=e:GetOwner()
							if Duel.CheckEvent(EVENT_MOVE) then
								local _,meg=Duel.CheckEvent(EVENT_MOVE,true)
								if meg:IsContains(c) and (c:IsFaceup() or c:IsPublic()) then
									g0:Clear()
									g1:Clear()
								end
							end
							if #g0>0 then
								local _eg=g0:Clone()
								Duel.RaiseEvent(_eg,e:GetLabel(),re,r,0,ep,ev)
								g0:Clear()
							end
							if #g1>0 then
								local _eg1=g1:Clone()
								Duel.RaiseEvent(_eg1,e:GetLabel(),re,r,1,ep,ev)
								g1:Clear()
							end
						end)
		c:RegisterEffect(ce)
	end
	--listened to again
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e3:SetCode(EVENT_MOVE)
	e3:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
						local c=e:GetOwner()
						if c:IsFaceup() or c:IsPublic() then
							g0:Clear()
							g1:Clear()
						end
					end)
	c:RegisterEffect(e3)
	return event_code_single
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function cm.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_GRAVE)
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.spfilter2(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsRelateToEffect(e)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local num=#eg --eg:FilterCount(Card.IsType,nil,TYPE_MONSTER)
	local tg=eg:Filter(cm.tgfilter,nil)
	local spg=tg:Filter(cm.spfilter,nil,e,tp)
	if chk==0 then return (num>=2 or (Duel.IsPlayerAffectedByEffect(tp,11451481) and num>=1)) and not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and #spg>0 and c:GetFlagEffect(m)==0 and Duel.GetFlagEffect(tp,m+0xffffff)<2+(Duel.GetFlagEffect(tp,11451926)>0 and 1 or 0) end
	Duel.RegisterFlagEffect(tp,m+0xffffff,RESET_PHASE+PHASE_END,0,1)
	local op=0
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
	if Duel.IsPlayerAffectedByEffect(tp,11451481) then
		if num>=2 then
			local op=Duel.SelectOption(tp,aux.Stringid(11451483,2),aux.Stringid(11451483,3))
			Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(11451483,op+2))
			if op==1 then
				Duel.RegisterFlagEffect(tp,11451481,0,0,1)
				Duel.ResetFlagEffect(tp,11451482)
			end
		else
			op=1
			Duel.RegisterFlagEffect(tp,11451481,0,0,1)
			Duel.ResetFlagEffect(tp,11451482)
		end
	end
	if Duel.GetFlagEffect(tp,m)>2 or (op==1 and Duel.GetFlagEffect(tp,11451481)>1) then
		local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_FLAG_EFFECT+11451926)}
		local g=Group.CreateGroup()
		for _,te in pairs(eset) do g:AddCard(te:GetHandler()) end
		if #g>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			g=g:Select(tp,1,1,nil)
		end
		Duel.RaiseSingleEvent(g:GetFirst(),EVENT_CUSTOM+11451926,e,0,tp,tp,0)
	end
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsPlayerAffectedByEffect(tp,59822133) or Duel.GetLocationCount(tp,LOCATION_MZONE)<2 or not c:IsRelateToEffect(e) or not c:IsCanBeSpecialSummoned(e,0,tp,false,false) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:FilterSelect(tp,aux.NecroValleyFilter(cm.spfilter2),1,1,nil,e,tp)
	if #tg>0 then
		tg:AddCard(c)
		Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function cm.thfilter(c)
	return c:IsSetCard(0x97b) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return (#eg>=2 or Duel.IsPlayerAffectedByEffect(tp,11451481)) and c:IsAbleToHand() and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) and c:GetFlagEffect(m)==0 and Duel.GetFlagEffect(tp,m+0xffffff)<2+(Duel.GetFlagEffect(tp,11451926)>0 and 1 or 0) end
	Duel.RegisterFlagEffect(tp,m+0xffffff,RESET_PHASE+PHASE_END,0,1)
	local op=0
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
	if Duel.IsPlayerAffectedByEffect(tp,11451481) then
		if #eg>=2 then
			local op=Duel.SelectOption(tp,aux.Stringid(11451483,2),aux.Stringid(11451483,3))
			Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(11451483,op+2))
			if op==1 then
				Duel.RegisterFlagEffect(tp,11451481,0,0,1)
				Duel.ResetFlagEffect(tp,11451482)
			end
		else
			op=1
			Duel.RegisterFlagEffect(tp,11451481,0,0,1)
			Duel.ResetFlagEffect(tp,11451482)
		end
	end
	if Duel.GetFlagEffect(tp,m)>2 or (op==1 and Duel.GetFlagEffect(tp,11451481)>1) then
		local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_FLAG_EFFECT+11451926)}
		local g=Group.CreateGroup()
		for _,te in pairs(eset) do g:AddCard(te:GetHandler()) end
		if #g>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			g=g:Select(tp,1,1,nil)
		end
		Duel.RaiseSingleEvent(g:GetFirst(),EVENT_CUSTOM+11451926,e,0,tp,tp,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_ONFIELD+LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		g:AddCard(c)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end