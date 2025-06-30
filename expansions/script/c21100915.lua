--环球旅行家 D
local m=21100915
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetSPSummonOnce(m)
	aux.EnablePendulumAttribute(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_ADJUST)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(0xff)
	e0:SetCountLimit(1)
	e0:SetOperation(cm.op0)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_SEND_REPLACE)
	e1:SetRange(LOCATION_HAND+LOCATION_ONFIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.tg)
	e1:SetValue(cm.val)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,m+1)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_TOEXTRA)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,m+2)
	e3:SetCondition(cm.con3)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_REMOVED)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e4:SetCondition(cm.con4)
	e4:SetOperation(cm.op4)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetOperation(cm.op5)
	c:RegisterEffect(e5)
	if not _globetrot_ then
		_globetrot=true
		_globetrot_limit = {1,1}
		local ce1=Effect.CreateEffect(c)
		ce1:SetType(EFFECT_TYPE_FIELD)
		ce1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		ce1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		ce1:SetTargetRange(1,0)
		ce1:SetTarget(function(e,c,sump,sumtype,sumpos,targetp)
			return Duel.GetFlagEffect(c:GetControler(),0x3909) >= _globetrot_limit[c:GetControler()+1] and c:IsSetCard(0x3909)
		end)
		Duel.RegisterEffect(ce1,0)
		local ce2=Effect.CreateEffect(c)
		ce2:SetType(EFFECT_TYPE_FIELD)
		ce2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		ce2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		ce2:SetTargetRange(1,0)
		ce2:SetTarget(function(e,c,sump,sumtype,sumpos,targetp)
			return Duel.GetFlagEffect(c:GetControler(),0x3909) >= _globetrot_limit[c:GetControler()+1] and c:IsSetCard(0x3909)
		end)
		Duel.RegisterEffect(ce2,1)		
		local ce3=Effect.CreateEffect(c)
		ce3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ce3:SetCode(EVENT_PHASE+PHASE_END)
		ce3:SetCountLimit(1)
		ce3:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			_globetrot_limit[1] = _globetrot_limit[1] + 1
			_globetrot_limit[2] = _globetrot_limit[2] + 1		
		end)
		Duel.RegisterEffect(ce3,0)
	end
	if not _globetrot then
		_globetrot=true
		globetrot = {}
		globetrot.x = 5
		globetrot.g = 0
		globetrot.pair = {}
		for i = 1, globetrot.x do
			globetrot.pair[i] = {}
			globetrot.pair[i]["first"] = i
			globetrot.pair[i]["second"] = 0	
		end		
		function globetrot.quick_sort(start, last)
			local left, right = start, last
			if left < right then
				while left < right do
					while globetrot.pair[left]["second"] <= globetrot.pair[start]["second"] and left < last do
						left = left + 1
					end
					while globetrot.pair[right]["second"] >= globetrot.pair[start]["second"] and right > start do
						right = right - 1
					end
					if left < right then
						local _first = globetrot.pair[left]["first"]
						local _second = globetrot.pair[left]["second"]
						globetrot.pair[left]["first"] = globetrot.pair[right]["first"]
						globetrot.pair[left]["second"] = globetrot.pair[right]["second"]
						globetrot.pair[right]["first"] = _first
						globetrot.pair[right]["second"] = _second
					else
						break
					end
				end
				local _first = globetrot.pair[start]["first"]
				local _second = globetrot.pair[start]["second"]
				globetrot.pair[start]["first"] = globetrot.pair[right]["first"]
				globetrot.pair[start]["second"] = globetrot.pair[right]["second"]
				globetrot.pair[right]["first"] = _first
				globetrot.pair[right]["second"] = _second
				globetrot.quick_sort(start, right - 1)
				globetrot.quick_sort(right + 1, last)
			end
		end
		
		function globetrot.random(seed)
			seed = math.floor(math.abs(seed))
			seed = (seed * 16807) % 2147483647
			local n = seed % 5
			n = (n < 0) and (n + 5) or n
			local res = n + 1
			globetrot.quick_sort(1, globetrot.x)
			if res ~= globetrot.pair[1]["first"] and globetrot.pair[globetrot.x]["second"] - globetrot.pair[1]["second"] > 1 then
				res = globetrot.pair[1]["first"]
			end			
			return res
		end
	end
	if not cm._ then
	cm._ = true
		cm.A = {0,0}
		cm.A_status = {true,true}
		cm.A_hint = {{nil,nil,nil,nil,nil},{nil,nil,nil,nil,nil}}
		cm["1"] = function(_c) return _c:IsAbleToHand() and not _c:IsLocation(LOCATION_HAND) end
		cm["2"] = function(_c) return _c:IsAbleToDeck() end
		cm["3"] = function(_c) return _c:IsAbleToGrave() end
		cm["4"] = function(_c) return _c:IsAbleToRemove() end
		cm["5"] = function(_c) return _c:IsAbleToExtra() end
		cm._return = 
			function(_c, _s) 
				if _s == 1 then 
					Duel.SendtoHand(_c,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-_c:GetOwner(),_c)
					if cm.A[_c:GetOwner()+1]&LOCATION_HAND==0 then 
						cm.A_hint[_c:GetOwner()+1][_s]=Effect.CreateEffect(_c)
						cm.A_hint[_c:GetOwner()+1][_s]:SetDescription(aux.Stringid(m,2))
						cm.A_hint[_c:GetOwner()+1][_s]:SetType(EFFECT_TYPE_FIELD)
						cm.A_hint[_c:GetOwner()+1][_s]:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
						cm.A_hint[_c:GetOwner()+1][_s]:SetTargetRange(1,0)
						cm.A_hint[_c:GetOwner()+1][_s]:SetValue(1)
						Duel.RegisterEffect(cm.A_hint[_c:GetOwner()+1][_s],_c:GetOwner())					
					end
					cm.A[_c:GetOwner()+1] = cm.A[_c:GetOwner()+1] | LOCATION_HAND
				elseif _s == 2 then
					Duel.SendtoDeck(_c,_c:GetOwner(),2,REASON_EFFECT)
					Duel.ConfirmCards(1-_c:GetOwner(),_c)
					if cm.A[_c:GetOwner()+1]&LOCATION_DECK==0 then 
						cm.A_hint[_c:GetOwner()+1][_s]=Effect.CreateEffect(_c)
						cm.A_hint[_c:GetOwner()+1][_s]:SetDescription(aux.Stringid(m,3))
						cm.A_hint[_c:GetOwner()+1][_s]:SetType(EFFECT_TYPE_FIELD)
						cm.A_hint[_c:GetOwner()+1][_s]:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
						cm.A_hint[_c:GetOwner()+1][_s]:SetTargetRange(1,0)
						cm.A_hint[_c:GetOwner()+1][_s]:SetValue(1)
						Duel.RegisterEffect(cm.A_hint[_c:GetOwner()+1][_s],_c:GetOwner())					
					end
					cm.A[_c:GetOwner()+1] = cm.A[_c:GetOwner()+1] | LOCATION_DECK
				elseif _s == 3 then
					Duel.SendtoGrave(_c,REASON_EFFECT)
					if cm.A[_c:GetOwner()+1]&LOCATION_GRAVE==0 then 
						cm.A_hint[_c:GetOwner()+1][_s]=Effect.CreateEffect(_c)
						cm.A_hint[_c:GetOwner()+1][_s]:SetDescription(aux.Stringid(m,4))
						cm.A_hint[_c:GetOwner()+1][_s]:SetType(EFFECT_TYPE_FIELD)
						cm.A_hint[_c:GetOwner()+1][_s]:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
						cm.A_hint[_c:GetOwner()+1][_s]:SetTargetRange(1,0)
						cm.A_hint[_c:GetOwner()+1][_s]:SetValue(1)
						Duel.RegisterEffect(cm.A_hint[_c:GetOwner()+1][_s],_c:GetOwner())					
					end
					cm.A[_c:GetOwner()+1] = cm.A[_c:GetOwner()+1] | LOCATION_GRAVE
				elseif _s == 4 then	
					Duel.Remove(_c,POS_FACEUP,REASON_EFFECT)
					if cm.A[_c:GetOwner()+1]&LOCATION_REMOVED==0 then 
						cm.A_hint[_c:GetOwner()+1][_s]=Effect.CreateEffect(_c)
						cm.A_hint[_c:GetOwner()+1][_s]:SetDescription(aux.Stringid(m,5))
						cm.A_hint[_c:GetOwner()+1][_s]:SetType(EFFECT_TYPE_FIELD)
						cm.A_hint[_c:GetOwner()+1][_s]:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
						cm.A_hint[_c:GetOwner()+1][_s]:SetTargetRange(1,0)
						cm.A_hint[_c:GetOwner()+1][_s]:SetValue(1)
						Duel.RegisterEffect(cm.A_hint[_c:GetOwner()+1][_s],_c:GetOwner())					
					end
					cm.A[_c:GetOwner()+1] = cm.A[_c:GetOwner()+1] | LOCATION_REMOVED
				elseif _s == 5 then	
					Duel.SendtoExtraP(_c,_c:GetOwner(),REASON_EFFECT)
					if cm.A[_c:GetOwner()+1]&LOCATION_EXTRA==0 then 
						cm.A_hint[_c:GetOwner()+1][_s]=Effect.CreateEffect(_c)
						cm.A_hint[_c:GetOwner()+1][_s]:SetDescription(aux.Stringid(m,6))
						cm.A_hint[_c:GetOwner()+1][_s]:SetType(EFFECT_TYPE_FIELD)
						cm.A_hint[_c:GetOwner()+1][_s]:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
						cm.A_hint[_c:GetOwner()+1][_s]:SetTargetRange(1,0)
						cm.A_hint[_c:GetOwner()+1][_s]:SetValue(1)
						Duel.RegisterEffect(cm.A_hint[_c:GetOwner()+1][_s],_c:GetOwner())					
					end
					cm.A[_c:GetOwner()+1] = cm.A[_c:GetOwner()+1] | LOCATION_EXTRA
				end
				cm.A_status[_c:GetOwner()+1] = true
			end
	end	
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return cm.A_status[tp+1] and e:GetHandler():IsLocation(LOCATION_HAND+LOCATION_ONFIELD)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if not e or not eg then return end
	local c=e:GetHandler()
	if chk==0 then return cm["1"](c) or cm["2"](c) or cm["3"](c) or cm["4"](c) or cm["5"](c) end
	cm.A_status[tp+1] = false
	local x
	while true do
		globetrot.g = globetrot.g + 1
		x = Duel.GetRandomNumber(1,5)
		x = globetrot.random(x)
		if globetrot.g > 5 then
		globetrot.g = 0
			while true do
				x = Duel.GetRandomNumber(1,5)
				if cm[tostring(x)](c) then
					for i = 1, globetrot.x do
						if globetrot.pair[i]["first"] == x then
							globetrot.pair[i]["second"] = globetrot.pair[i]["second"] + 1
						end
					end
				goto A
				end
			end
		end			
		if cm[tostring(x)](c) then 
			for i = 1, globetrot.x do
				if globetrot.pair[i]["first"] == x then
					globetrot.pair[i]["second"] = globetrot.pair[i]["second"] + 1
				end
			end
		break 
		end
	end
	::A::
	cm._return(c,x)
	return false
end
function cm.val(e,c)
	return false
end
function cm.op0(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,m)==0 then
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.spcon)
	e1:SetValue(SUMMON_VALUE_SELF)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetTargetRange(LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,0)
	e2:SetTarget(cm.sptg)
	e2:SetLabelObject(e1)
	Duel.RegisterEffect(e2,tp)
	Duel.RegisterFlagEffect(tp,m,0,0,0)
	end
	e:Reset()
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return cm.A[tp+1]&c:GetLocation()>0 and (not c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCount(tp,4)>0 or c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0)
end
function cm.sptg(e,c)
	return c:IsSetCard(0x3909) and not c:IsCode(m)
end
function cm.q(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceupEx() and c:IsSetCard(0x3909) and (c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 or not c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCount(tp,4)>0) and not c:IsCode(m)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)>0 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.q),tp,cm.A[c:GetControler()+1],0,1,nil,e,tp) then
		if Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.BreakEffect()
		Duel.Hint(3,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.q),tp,cm.A[c:GetControler()+1],0,1,1,nil,e,tp)
			if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_VALUE_SELF)
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local hand = cm.A[c:GetControler()+1]&LOCATION_HAND>0 and Duel.GetMatchingGroupCount(aux.TRUE,tp,0,LOCATION_HAND,nil)>0
	local deck = cm.A[c:GetControler()+1]&LOCATION_DECK>0 and Duel.GetMatchingGroupCount(Card.IsAbleToHand,tp,0,LOCATION_DECK,nil)>0
	local grave = cm.A[c:GetControler()+1]&LOCATION_GRAVE>0 and Duel.GetMatchingGroupCount(Card.IsAbleToHand,tp,0,LOCATION_GRAVE,nil)>0
	local remove = cm.A[c:GetControler()+1]&LOCATION_REMOVED>0 and Duel.GetMatchingGroupCount(Card.IsAbleToHand,tp,0,LOCATION_REMOVED,nil)>0
	local extra = cm.A[c:GetControler()+1]&LOCATION_EXTRA>0 and Duel.GetMatchingGroupCount(aux.TRUE,tp,0,LOCATION_EXTRA,nil)>0
	if chk==0 then return hand or deck or grave or remove or extra end
	Duel.Hint(3,tp,aux.Stringid(m,7))
	local loc=aux.SelectFromOptions(tp,{hand,aux.Stringid(m,8),LOCATION_HAND},{deck,aux.Stringid(m,9),LOCATION_DECK},{grave,aux.Stringid(m,10),LOCATION_GRAVE},{remove,aux.Stringid(m,11),LOCATION_REMOVED},{extra,aux.Stringid(m,12),LOCATION_EXTRA})
	if loc == LOCATION_HAND then
		Debug.Message("宣言了手卡")
	elseif loc == LOCATION_DECK then
		e:SetCategory(e:GetCategory()+CATEGORY_SEARCH)
		Debug.Message("宣言了卡组")
	elseif loc == LOCATION_GRAVE then
		e:SetCategory(e:GetCategory()+CATEGORY_GRAVE_ACTION)
		Debug.Message("宣言了墓地")
	elseif loc == LOCATION_REMOVED then
		Debug.Message("宣言了除外区域")
	elseif loc == LOCATION_EXTRA then
		Debug.Message("宣言了额外卡组")
	end
	e:SetLabel(loc)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local loc=e:GetLabel()
	local c=e:GetHandler()
	if loc&(LOCATION_HAND|LOCATION_DECK|LOCATION_GRAVE|LOCATION_REMOVED|LOCATION_EXTRA) == 0 then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(aux.TRUE),tp,0,loc,nil)
	if #g>0 then
		local sg=g:RandomSelect(tp,1)
		if not sg:GetFirst():IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK) then
			Duel.SendtoHand(sg,tp,REASON_EFFECT)
		else
			Duel.SendtoDeck(sg,tp,2,REASON_EFFECT)
		end
		Duel.ConfirmCards(1-tp,sg)
		cm.A[c:GetControler()+1] = cm.A[c:GetControler()+1] - loc
		local _s = 0
		if loc == LOCATION_HAND then
			_s = 1
		elseif loc == LOCATION_DECK then
			_s = 2	
		else
			_s = math.log(loc/2,2)
		end	
		if aux.GetValueType(cm.A_hint[c:GetControler()+1][_s]) == "Effect" then
		cm.A_hint[c:GetControler()+1][_s]:Reset()
		cm.A_hint[c:GetControler()+1][_s] = nil
		end
	end
end
function cm.con4(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetCurrentChain()
	return e:GetHandler():IsSpecialSummonable(SUMMON_VALUE_SELF) and ct==0 and Duel.GetTurnPlayer()==tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	Duel.SpecialSummonRule(tp,e:GetHandler(),SUMMON_VALUE_SELF)
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(m,13))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,0x3909,RESET_PHASE+PHASE_END,0,1)
end