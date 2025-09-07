--放出巨虫
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(0x50)
	c:SetCounterLimit(0x50,12)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,7449101+EFFECT_COUNT_CODE_DUEL+EFFECT_COUNT_CODE_OATH)
	e0:SetTarget(s.target)
	c:RegisterEffect(e0)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetValue(s.efilter)
	c:RegisterEffect(e1)
	--adjust
	--[[local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(s.adjustop)
	c:RegisterEffect(e2)]]
	--add counter
	local e3=Effect.CreateEffect(c)
	--e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_DAMAGE)
	e3:SetCondition(s.ctcon)
	e3:SetOperation(s.ctop)
	c:RegisterEffect(e3)

	--Quest--
	--shuffle count
	if not Initial_Hand_Shuffle_Count then
		Initial_Hand_Shuffle_Count=0
	end
	--to top
	if Duel.DisableActionCheck then
		--to top koishi
		local totop=(function()
			--The global variable "Initial_Hand_Shuffle_Count" is used to record the number of cards that appear in the initial hand. If it exceeds 5, a shuffle will be triggered in "ge0". Therefore, please keep "Initial_Hand_Shuffle_Count" unchanged when copying and modifying the code
			Initial_Hand_Shuffle_Count=Initial_Hand_Shuffle_Count+1
			Duel.MoveSequence(c,SEQ_DECKTOP)
		end)
		local _RegisterEffect=Card.RegisterEffect
		function Card.RegisterEffect(rc,eff,bool)
			local int=_RegisterEffect(rc,eff,bool)
			if not s[c] and Duel.GetFieldGroupCount(0,LOCATION_EXTRA,0)>0 and Duel.GetFieldGroupCount(0,0,LOCATION_EXTRA)>0 then
				Duel.DisableActionCheck(true)
				pcall(totop)
				Duel.DisableActionCheck(false)
				s[c]=true
			end
			return int
		end
	end
	--to hand
	local ge0=Effect.CreateEffect(c)
	ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE)
	ge0:SetCode(EVENT_DRAW)
	ge0:SetRange(0xff)
	ge0:SetOperation(s.quest)
	c:RegisterEffect(ge0)

end
function s.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
	e:GetHandler():SetTurnCounter(0)
end
function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and ev==200 and bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	--Debug.Message("0")
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	if ct==12 then
		s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	elseif ct<12 then
		c:SetTurnCounter(ct)
	end
	--Debug.Message("0")
	--if c:IsRelateToEffect(e) then
	--  Debug.Message("1")
	--  c:AddCounter(0x50,1)
	--end
end
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	--[[local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	if e:GetHandler():GetCounter(0x50)~=12 then return end]]
	local c=e:GetHandler()
	local g=Group.FromCards(c)
	local cid=c:GetOriginalCode()
	Duel.HintSelection(g)
	Duel.Hint(HINT_CARD,0,cid)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,7449102,0,TYPES_TOKEN_MONSTER,4000,4000,5,RACE_WYRM,ATTRIBUTE_WIND) then
		local token=Duel.CreateToken(tp,7449102)
		if cid==7449201 then token=Duel.CreateToken(tp,7449202) end
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
	Duel.SendtoGrave(c,REASON_EFFECT)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetLabel(cid)
	e3:SetCondition(s.damcon1)
	e3:SetOperation(s.damop)
	Duel.RegisterEffect(e3,tp)
	local e4=e3:Clone()
	e4:SetCode(EVENT_DAMAGE)
	e4:SetCondition(s.damcon2)
	Duel.RegisterEffect(e4,tp)
end
function s.damcon1(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.GetLP(1-tp)>0 and ev==200 and eg:GetFirst():IsLocation(LOCATION_ONFIELD)
end
function s.damcon2(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.GetLP(1-tp)>0 and ev==200 and bit.band(r,REASON_BATTLE)==0 and re
		and re:GetHandler():IsLocation(LOCATION_ONFIELD)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local cid=e:GetLabel()
	Duel.Hint(HINT_CARD,0,cid)
	Duel.Damage(1-tp,200,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
	Duel.HintSelection(g)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end

-----------------------------------Quest--------------------------------------
function s.questfilter(c,min_fid)
	return c:GetFieldID()==min_fid
end
function s.quest(e,tp,eg,ep,ev,re,r,rp)
	--
	--The global variable "Initial_Hand_Shuffle_Count" is used to record the number of cards that appear in the initial hand. If it exceeds 5, a shuffle will be triggered in "ge0". Therefore, please keep "Initial_Hand_Shuffle_Count" unchanged when copying and modifying the code
	if Initial_Hand_Shuffle_Count and Initial_Hand_Shuffle_Count>5 then e:Reset() Duel.ShuffleDeck(tp) end
	--
	local c=e:GetHandler()
	if not s[c] and Duel.GetFieldGroupCount(0,LOCATION_HAND,0)>0 and Duel.GetFieldGroupCount(0,0,LOCATION_HAND)>0 then
		s[c]=true
		e:Reset()
		if c:IsLocation(LOCATION_HAND) then return false end
		local tdg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		local min_fid=32768
		for tc in aux.Next(tdg) do
			local tc_fid=tc:GetFieldID()
			if tc_fid<min_fid then min_fid=tc_fid end
			--[[local g=Group.FromCards(tc)
			local code=tc:GetCode()
			Debug.Message(tc_cid)
			Debug.Message(code)
			Duel.HintSelection(g)]]
		end
		if min_fid~=32768 then
			local tdg=Duel.GetMatchingGroup(s.questfilter,tp,LOCATION_HAND,0,nil,min_fid)
			Duel.SendtoDeck(tdg,nil,2,REASON_RULE)
			Duel.MoveSequence(c,SEQ_DECKTOP)
			Duel.Draw(tp,1,REASON_RULE)
		end
	elseif Duel.GetFieldGroupCount(0,LOCATION_HAND,0)>0 and Duel.GetFieldGroupCount(0,0,LOCATION_HAND)>0 then
		e:Reset()
	end
end
