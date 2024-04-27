--炼击帝-死河
if not require and loadfile then
	function require(str)
		require_list=require_list or {}
		if not require_list[str] then
			if string.find(str,"%.") then
				require_list[str]=loadfile(str)
			else
				require_list[str]=loadfile(str..".lua")
			end
			pcall(require_list[str])
			return require_list[str]
		end
		return require_list[str]
	end
end
if not pcall(function() require("expansions/script/c130001000") end) then require("script/c130001000") end
local s,id = Scl.SetID(130006037, "LordOfChain")
function s.initial_effect(c)
	local e1 = Scl.CreateSingleBuffEffect(c, "Reveal", 1, "Hand")
	local e2 = Scl.CreateQuickMandatoryEffect(c, "ActivateEffect", nil, nil, nil, nil, "Hand,MonsterZone", nil, nil, s.mixtg,s.mixop)
	if not s.chain_id_scl then
		s.chain_id_scl = {}
		
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_SSET_COST)
		e3:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
		e3:SetOperation(s.costop)
		Duel.RegisterEffect(e3,0)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_SSET)
		e4:SetOperation(s.costop2)
		Duel.RegisterEffect(e4,0)
	end
end
function s.costop(e,tp,eg,ep,ev,re,r,rp)
	s.adjusting=true
end
function s.costop2(e,tp,eg,ep,ev,re,r,rp)
	s.adjusting=false
	Duel.RaiseEvent(eg,EVENT_ADJUST,nil,0,PLAYER_NONE,PLAYER_NONE,0)
end
function s.get_count(zone)
	local ct = Duel.GetFieldGroupCount(0, zone, 0) - Duel.GetFieldGroupCount(0, 0, zone)
	return math.abs(ct)
end
function s.mixtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c = e:GetHandler()
	local cct = Duel.GetCurrentChain()
	local b1 = (c:IsOnField() or c:IsPublic()) and c:GetFlagEffect(id) < s.get_count(LOCATION_GRAVE)
	local b2 = c:IsLocation(LOCATION_HAND) and c:GetFlagEffect(id + 100) == 0 and cct > 1
	if chk == 0 then
		local res=(b1 or b2) and c:GetFlagEffect(id + 200)==0
		if res then c:RegisterFlagEffect(id + 200, RESET_CHAIN, 0, 1) end
		return res
	end
	c:ResetFlagEffect(id + 200)
	b2 =  c:IsLocation(LOCATION_HAND) and c:GetFlagEffect(id + 100) == 0  and cct > 2
	--local op = b1 and 1 or 2
	--if b1 and b2 then 
		--op = Scl.SelectOption(tp, true, "Damage", true, {id, 0})
	--end
	local op = b2 and 2 or 1
	if op == 1 then
		e:SetProperty(0)
		e:SetCategory(CATEGORY_ATKCHANGE)
		c:RegisterFlagEffect(id, RESET_CHAIN, 0, 1)
	else
		c:RegisterFlagEffect(id + 100, RESET_CHAIN, 0, 1)
		local ctgy = 0
		if cct >= 3 then
			ctgy = ctgy + CATEGORY_SPECIAL_SUMMON + CATEGORY_REMOVE + CATEGORY_GRAVE_ACTION 
		end
		if cct >= 5 then

		end
		if cct >= 13 then
			ctgy = ctgy + CATEGORY_DISABLE 
		end
		e:SetCategory(ctgy)
		Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(id,1))
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,1))
		c:RegisterFlagEffect(0, RESET_CHAIN, EFFECT_FLAG_CLIENT_HINT, 1,0,aux.Stringid(id,1))
	end
	s.chain_id_scl[cct] = op
end
function s.mixop(e,tp,eg,ep,ev,re,r,rp)
	local cct = Duel.GetCurrentChain()
	local op = s.chain_id_scl[cct]
	if op == 1 then
		local g = Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		for tc in aux.Next(g) do
			Scl.AddSingleBuff({e:GetHandler(),tc},"+ATK", 400)
		end
	else
		local c = e:GetHandler()
		if cct >= 3 then 
			if c:IsRelateToChain(0) and Duel.GetLocationCount(tp,LOCATION_MZONE) > 0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and
				Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) > 0 then
				Scl.SelectAndOperateCards("Banish", tp, Card.IsAbleToRemove, tp, "GY", "GY", 1, 1, nil)()
			end
		end
		if cct >= 5 then
			Scl.SelectAndOperateCards("SpecialSummon", tp, aux.NecroValleyFilter(Scl.IsCanBeSpecialSummonedNormaly2), tp, "GY", "GY", 1, 1, nil, e, tp)()
		end
		if cct >= 13 then
			local f = function(te,tc)
				return not Scl.IsSeries(tc, "LordOfChain")
			end
			--local e1 = Scl.CreateFieldBuffEffect({c, tp}, "NegateEffect", 1, f, {"OnField", "OnField"}, nil, nil, RESET_EP_SCL)
			--local e2 = Scl.CreateFieldBuffEffect({c, tp}, "=Name", 32274490, f, {"OnField", "OnField"}, nil, nil, RESET_EP_SCL)
			--s.backop(e,tp,eg,ep,ev,re,r,rp)
			local ex=Effect.CreateEffect(c)
			ex:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			ex:SetCode(EVENT_ADJUST)
			ex:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			ex:SetCondition(function() return not s.adjusting end)
			ex:SetOperation(s.backop)
			ex:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(ex,tp)
			local ex2=Effect.CreateEffect(c)
			ex2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			ex2:SetCode(EVENT_CHAIN_SOLVING)
			ex2:SetOperation(s.ngop)
			ex2:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(ex2,tp)
		end
	end
end
function s.ngop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:GetOriginalCode()==32274490 then
		local op=re:GetOperation()
		re:SetOperation(function(e,...) e:SetOperation(op) end)
		local ex2=Effect.CreateEffect(e:GetHandler())
		ex2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ex2:SetCode(EVENT_CHAIN_SOLVED)
		ex2:SetCountLimit(1)
		ex2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) re:SetOperation(op) e:Reset() end)
		ex2:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(ex2,tp)
		--Duel.ChangeChainOperation(ev,function() end)
	end
end
function s.nfilter(c,e)
	return (c:GetFlagEffect(id)==0 and c:GetFlagEffect(id+1)==0) and not Scl.IsSeries(c, "LordOfChain") and c:GetOriginalCode()~=32274490 and not c:IsImmuneToEffect(e) --and not c:IsStatus(STATUS_LEAVE_CONFIRMED) --and not (c:IsFacedown()) --and not c:IsImmuneToEffect(e)
end
function s.backop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	local c=e:GetHandler()
	if s.adjusting or (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL or c:IsStatus(STATUS_BATTLE_DESTROYED) then return end
	s.adjusting=true
	local g=Duel.GetMatchingGroup(s.nfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e)
	if g and #g>0 then
		for tc in aux.Next(g) do
			tc:RegisterFlagEffect(id,0,EFFECT_FLAG_SET_AVAILABLE,1)
		end
	end
	if g and #g>0 then
		Duel.Hint(HINT_CARD,0,id)
		for tc in aux.Next(g) do
			getmetatable(tc).true_code=tc:GetOriginalCode()
			tc:SetEntityCode(32274490)
			tc:RegisterFlagEffect(id,0,EFFECT_FLAG_SET_AVAILABLE,1)
			if tc:IsFacedown() then
				Duel.ConfirmCards(1-tc:GetControler(),Group.FromCards(tc))
			end
			local ini=s.initial_effect
			s.initial_effect=function() end
			tc:ReplaceEffect(id,0)
			s.initial_effect=ini
			tc:RegisterFlagEffect(id,0,0,0)
			Duel.Hint(HINT_CARD,0,32274490)
			if tc:IsLocation(LOCATION_HAND) then Duel.ShuffleHand(tc:GetControler()) end
			--Duel.RaiseEvent(tc,EVENT_ADJUST,nil,0,PLAYER_NONE,PLAYER_NONE,0)
			
			local ex=Effect.CreateEffect(tc)
			ex:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			ex:SetCode(EVENT_LEAVE_FIELD_P)
			ex:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			ex:SetOperation(s.backop2)
			tc:RegisterEffect(ex,true)
			--this will cause xmaterial sent to the GY turn back to TOKEN.
			--[[local ex2=Effect.CreateEffect(tc)
			ex2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			ex2:SetCode(EVENT_ADJUST)
			ex2:SetRange(0xff)
			ex2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			ex2:SetCondition(function() return not s.adjusting and not tc:IsOnField() end)
			ex2:SetOperation(s.backop2)
			tc:RegisterEffect(ex2,true)--]]
		end
	end
	s.adjusting=false
end
function s.backop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetOriginalCode()~=32274490 then return end
	s.adjusting=true
	local tcode=c.true_code
	c:SetEntityCode(tcode)
	if c:IsFacedown() then
		Duel.ConfirmCards(tp,Group.FromCards(c))
		Duel.ConfirmCards(1-tp,Group.FromCards(c))
	end
	c:ReplaceEffect(tcode,0,0)
	c:ResetFlagEffect(id)
	c:RegisterFlagEffect(id+1,RESETS_STANDARD+RESET_EVENT,EFFECT_FLAG_SET_AVAILABLE,1)
	Duel.Hint(HINT_CARD,0,tcode)
	if c:IsLocation(LOCATION_HAND) then Duel.ShuffleHand(c:GetControler()) end
	Duel.RaiseEvent(e:GetHandler(),EVENT_ADJUST,nil,0,PLAYER_NONE,PLAYER_NONE,0)
	s.adjusting=false
end