--安洁莉娅·艾柏蓉
local m=91300202
local cm=_G["c"..m]
function cm.initial_effect(c)
	--sp summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(cm.tgcost)
	e1:SetCondition(cm.tgcon)
	e1:SetTarget(cm.tgtg)
	e1:SetOperation(cm.tgop)
	c:RegisterEffect(e1)
	--attack target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_PATRICIAN_OF_DARKNESS)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0,1)
	e3:SetCondition(cm.ccon)
	c:RegisterEffect(e3)
	--tohand  
	local e4=Effect.CreateEffect(c)   
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCost(cm.thcost)
	e4:SetTarget(cm.thtg)  
	e4:SetOperation(cm.thop)  
	c:RegisterEffect(e4)  
	Duel.AddCustomActivityCounter(m,ACTIVITY_CHAIN,aux.FALSE)
	if not cm.skill then 
		cm.skill, cm.cal = {}, {}
		cm.skill[3406751] = { "OzhxV11dQUVdWV4SdllGVBU4MjIxODIx", "ajjajajdjpHRtZPXqqbXuYTeu7nUtZPeiLTajajcipvRo6zXobDUnrvenpPUpIjVjLLVqLXdv5DRo6zXuYjUuL/dv5PehL7Um4HUpIjdrovQgLgD1ISS1LmZ1ZKF3a++" }
		cm.skill[3797356] = { "NzHRtKPUp6bdvLfevbnXrLgxNDg0MjEx", "YTHch63WiZvdqqrdpLrUnoHXooHSqp7Uj4PSsr7UpLner6jdu6PUu5DZi78D1J2Q3IqR3Iy416aOHdGXjdSniN2tjtyMuNarvNe0ktG3jNS9md27nNWRhd2suzg0MjEx" }
		cm.skill[176476] = { "NTF8W1pYXRFiXFdAV18TNDg0", "ajHai6HRhJHXuZnRo6/XvIjSsbrXuZnbhL3Wj7bSsbrXuZnSsrvai6HQgJvXuZnRqLzWj53RnKfVrrwF3b6Y0rie3bSP07GN3p+40beY3aWW17i2" }
		cm.skill[3954837] = { "ITLUuKXXpKbTj6bUgL3XtokQNDI=", "BjLUm4vXpIjRrovWib4D1L2b0oCQ1K291Lu416G616yt0b2g17uc2o611q6217Kb0beM1ZGA16y9MTQy" }
		cm.skill[98254] = { "IzTbs5fbpp7asbTVq7DUqavXtL0y", "uzTajq3XjZTXvJXXqqrXuYTUuL/XvJXRsbbajq3WiZ7UpLzUr6jXvqXXu5zXobrdjbjajq3WiZ7XqqrXobzXno3Up43UnrsH15iT176416G616qu1Luj1L6a2Zqb2Yur1YyY1LmT1KS/1q6206WS1q6216G616qu1q621YmN1qCa15iT16GCGgXRsbYy" }
		cm.skill[7513023] = { "KTHftJ/VgrDVjJjfq7XdgYnWnrfViLPdjJM4OA==", "ADHQh6jUhJjUvJndqq/dsIHXsbPUvJnXjb3Qv5vUj4nUqqbdlbwKCAEB3aeL16SU1Lm+OA==" }
		cm.skill[8643346] = { "LjLRl4/SsYHSuZfSuIPQj5LRo7Lbjr7SkLfSrKUV", "RDLcjavRjpLRv5PRqazRuoLSu7nRv5Pbjr7RrprctZjRhYPRrojQirjSuLgF172e0bK41JCx1Kyj2pO51aar1bud0bK53Y6817eJ1KW78IXRt7v2hQrSqq32hdSgiR3RnLoHAgIE3Y691buN1Jy+172Y16aQ0bK2" }
		cm.skill[951803] = { "LzHUvabXp6bWlK/XuoLUlJTViLjzhteBhdSMgNSOshA=", "sjHZjqjUjZHUvJDZkJnVj5bZkJnVj5bUnKnUrZnXra7YpoXUvpvXrbgA152Q3o291L6e1YqU17u72LOS162u2KaF1qWA1J6I16eI1L6g1LuZ2Y621qu1ANWJm9exm9S0jNekudevrdWMrdWJi9mOqNSNkdS8kNartdekudevrdS+oNS7mTE=" }
		cm.chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
		cm.reslst = {
			98254, 147780, 176476, 415684, 951803, 991299, 1316582, 1493584, 2116118, 2125179, 2184833, 2356627, 3406751, 3797356, 3954837, 4283402, 4291711, 
			4444113, 4781291, 5259484, 5741745, 6569607, 6797883, 6957760, 7127743, 7161770, 7487633, 7513023, 7581718, 8643346, 9293568, 9327173, 9537408,
		}
		cm.cal[1] = function(n) return (n * 5 + 7) % 97 end
		cm.cal[2] = function(n) return (n * 3 - 4) % 89 end
		cm.cal[3] = function(n) return (n + 11) % 83 end
		cm.cal[4] = function(n) return (n * 2 + 19) % 91 end
		cm.cal[5] = function(n) return (n * 6 - 5) % 79 end
		cm.cal[6] = function(n) return (n + 23) % 67 end
		cm.cal[7] = function(n) return (n * 4 + 3) % 73 end
		cm.cal[8] = function(n) return (n * 7 - 2) % 61 end
	end
end
function cm.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,m)>=Duel.GetFlagEffect(tp,m+1) end
	Duel.RegisterFlagEffect(tp,m+1,RESET_PHASE+PHASE_END,0,1,1)
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and (re:GetActivateLocation()==LOCATION_MZONE or re:GetActivateLocation()==LOCATION_SZONE)
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)   
	end
end
function cm.ccon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)>1
end
-- 遇到錯誤立刻停止, 滿足條件不立刻停止, 支持大小招
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk == 0 then return true end
	local fid, pass, key = e:GetHandler():GetFieldID(), {7, 2, 5, 1, 8, 4, 6, 3}, 0
	e:SetLabel(fid)
	cm[fid] = {0, 0}
	for i = 1, 8 do
		pass[i] = Duel.SelectOption(tp, aux.Stringid(m, 0), aux.Stringid(m, 1), aux.Stringid(m, 2), aux.Stringid(m, 3))
		key = bit.bor(key, 1 << pass[i] << (i - 1) * 4)
		local res, match = 0
		for j = 1, 8 do pass[j] = cm.cal[j](pass[(j + pass[i]) % 8 + 1]) end
		for j = 1, 8 do res = (res * 31 + (pass[j] ~ j)) % 10000007 end
		for _, v in ipairs(cm.reslst) do
			if res == v then match, cm[fid] = 1, {res, string.format("%X", key)} end
		end
		if not match then break end
	end
	local res, key = table.unpack(cm[fid])
	for _, code in ipairs(cm.skill[res] or {}) do
		code = code:gsub('[^' .. cm.chars .. '=]', '')
		local binaryStr = code:gsub('.', function(code)
			if code == '=' then return '' end
			local res, ind = '', cm.chars:find(code) - 1
			for i = 5, 0, -1 do res = res .. ((ind >> i) & 1) end
			return res
		end)
		local decode = binaryStr:gsub('%d%d%d?%d?%d?%d?%d?%d?',
			function(binary) return string.char(tonumber(binary, 2)) end)
		decode = decode .. string.rep("\0", (#key - #decode % #key) % #key)
		local show = {}
		for i = 1, #decode do
			local ch, weight, x, y = 0, 1, decode:byte(i), key:byte(i % #key + 1)
			for i = 1, 8 do
				if (x + y) & 1 == 1 then ch = ch + weight end
				x, y, weight = x // 2, y // 2, 2 * weight
			end
			table.insert(show, string.char(ch))
		end
		show = table.concat(show)
		Debug.Message(show:sub(3, 2 + string.unpack("I2", show)))
	end
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ind = cm[e:GetLabel()][1]
	local g = Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	if ind == 3797356 then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	elseif ind == 176476 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	elseif ind == 3954837 then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	elseif ind == 7513023 then
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,2000)
	elseif ind == 8643346 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local ind = cm[e:GetLabel()][1]
	if ind == 3406751 then
		local tc=e:GetHandler()
		if tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		if not tc:IsLocation(LOCATION_HAND) then return end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1:SetCode(EVENT_TO_HAND)
		e1:SetProperty(EFFECT_FLAG_DELAY)
		e1:SetCondition(cm.damcon1)
		e1:SetOperation(cm.damop1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	elseif ind == 3797356 then
		local ecount = Duel.GetCustomActivityCount(m,1-tp,ACTIVITY_CHAIN)
		if ecount >= 7 then
			local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
			Duel.Destroy(g,REASON_EFFECT)
		end
	elseif ind == 176476 then
		local tc=e:GetHandler()
		if tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		if not tc:IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.cfilter2,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	elseif ind == 3954837 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,cm.cfilter3,tp,0,LOCATION_MZONE,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	elseif ind == 98254 then
		local tc=e:GetHandler()
		if tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		if not tc:IsLocation(LOCATION_HAND) and Duel.GetFlagEffect(m+5)~=0 then return end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetCondition(cm.ctcon)
		e1:SetOperation(cm.ctop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		Duel.RegisterFlagEffect(m+5,RESET_PHASE+PHASE_END,0,1,1)
	elseif ind == 7513023 then
		local tc=e:GetHandler()
		if tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		if not tc:IsLocation(LOCATION_HAND) then return end
		Duel.Recover(tp,2000,REASON_EFFECT)
	elseif ind == 8643346 then
		local tc=e:GetHandler()
		if tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		if not tc:IsLocation(LOCATION_HAND) and (Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,91300203,0,TYPES_TOKEN_MONSTER,3000,3000,8,RACE_BEAST,ATTRIBUTE_LIGHT))then return end
		local token=Duel.CreateToken(tp,91300203)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	elseif ind == 951803 then
		local tc=e:GetHandler()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCondition(cm.condition)
		e1:SetOperation(cm.operation)
		tc:RegisterEffect(e1)
	end
end
function cm.cfilter(c,tp)
	return  c:IsPreviousLocation(LOCATION_ONFIELD)
end
function cm.damcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.damop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function cm.cfilter2(c,e,tp)
	return not c:IsCode(m) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.cfilter3(c)
	return c:GetFlagEffect(m)==0
end
function cm.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,m+2)==0 then 
		Duel.RegisterFlagEffect(tp,m+2,RESET_PHASE+PHASE_END,0,1,1)
	else
		local label=Duel.GetFlagEffectLabel(tp,m+2)
		Duel.SetFlagEffectLabel(tp,m+2,label+1)
	end
	if Duel.GetFlagEffectLabel(tp,m+2)>3 then
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1,1)
		Duel.SetFlagEffectLabel(tp,m+2,0)
	end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and re:GetHandlerPlayer()==1-tp and e:GetHandler():GetFlagEffect(m+4)==0
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=re:GetOperation()
	if not op then return end
	Duel.Hint(HINT_CARD,tp,re:GetHandler():GetOriginalCode())
	if Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
		c:RegisterFlagEffect(m+4,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,0,0,aux.Stringid(m,5))
		e:GetHandler():SetHint(CHINT_CARD,re:GetHandler():GetOriginalCode())
		local ce=Effect.CreateEffect(c)
		local desc=re:GetDescription()
		local con=re:GetCondition()
		local cost=re:GetCost()
		local target=re:GetTarget()
		local operation=re:GetOperation()
		local code=re:GetCode()
		local pro1,pro2=re:GetProperty()
		ce:SetDescription(desc)
		ce:SetType(re:GetType())
		if con then 
			ce:SetCondition(con)
		end
		if cost then
			ce:SetCost(cost)
		end
		if target then
			ce:SetTarget(target)
		end
		if operation then
			ce:SetOperation(operation)
		end
		ce:SetReset(RESET_EVENT+RESETS_STANDARD)
		ce:SetRange(LOCATION_MZONE)
		if code then
			ce:SetCode(code)
		else
			ce:SetCode(EVENT_FREE_CHAIN)
		end
		if pro1 and pro2 then
			ce:SetProperty(pro1,pro2)
		end
		ce:SetCountLimit(1)
		c:RegisterEffect(ce,true)
	end
end