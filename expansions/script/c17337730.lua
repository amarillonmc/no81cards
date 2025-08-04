--·丝碧卡·
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,17337400)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_ANNOUNCE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCost(s.e1cost)
	e1:SetOperation(s.e1op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetTarget(s.e2tg)
	e2:SetOperation(s.e2op)
	c:RegisterEffect(e2)
end
function s.e1cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
	Duel.ConfirmCards(1-tp,e:GetHandler())
	Duel.ShuffleHand(tp)
end
function s.is_include(value,tab)
	if tab==nil then return false end
	for k,v in ipairs(tab) do
	  if v:GetDescription() == value then
		  return true
	  end
	end
	return false
end
function s.e1op(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetHandler():GetCode()
	local c=e:GetHandler()
	local de=e:Clone()
	de:SetOperation(aux.TRUE)
	de:SetReset(RESET_CHAIN+RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(de)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={0x3f50,OPCODE_ISSETCARD,TYPE_MONSTER,OPCODE_ISTYPE,OPCODE_AND,code,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,17337400,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND} 
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	local ge1=Effect.CreateEffect(e:GetHandler())
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetCode(EVENT_ADJUST)
	ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	ge1:SetLabel(ac)
	ge1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
	end)
	ge1:SetOperation(s.adop)
	ge1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(ge1,tp)
	local catcheffect={}
	local catchoperation={}
	local catch=Card.RegisterEffect
	local flag_catch=false
	local temp=Duel.IsPlayerCanSummon
	function Duel.IsPlayerCanSummon(tep,stp,stc)
		if stc:IsAbleToExtraAsCost() then
			return false
		else
			return temp(tep,stp,stc)
		end
	end
	function Card.RegisterEffect(rc,te,...)
		if (te:IsHasType(EFFECT_TYPE_IGNITION) or te:GetCode()==EVENT_FREE_CHAIN) and not te:IsHasType(EFFECT_TYPE_ACTIVATE) then
			local target=te:GetTarget()
			local operation=te:GetOperation()
			if (not target or target(de,tp,eg,ep,ev,re,r,rp,0)) and not s.is_include(te:GetDescription(),catcheffect) then
				table.insert(catcheffect,te)
				flag_catch=true
			end
		end
		return catch(rc,te,...)
	end
	local token=Duel.CreateToken(tp,ac) 
	if flag_catch and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
		Duel.BreakEffect()
		local option={}
		for k,v in ipairs(catcheffect) do
			table.insert(option,v:GetDescription())
		end
		local op=Duel.SelectOption(tp,table.unpack(option))+1
		local te=catcheffect[op]
		Duel.Hint(HINT_OPSELECTED,0,te:GetDescription())
		local target=te:GetTarget()
		Duel.ClearTargetCard()
		de:SetProperty(te:GetProperty())
		if target then target(de,tp,eg,ep,ev,re,r,rp,1) end
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		if g and g:GetCount()>0 then
			local ac=g:GetFirst()
			while ac do
				ac:CreateEffectRelation(de)
				ac=g:GetNext()
			end
		end
		local operation=te:GetOperation()
		if operation then 
			operation(de,tp,eg,ep,ev,re,r,rp)
		elseif de:GetOperation() then
				de:GetOperation()(de,tp,eg,ep,ev,re,r,rp)
		end
		if g and g:GetCount()>0 then
			local sc=g:GetFirst()
			while sc do
				sc:ReleaseEffectRelation(de)
				sc=g:GetNext()
			end
		end
	end
	Card.RegisterEffect=catch
end
function s.subarufilter(c)
	return c:IsSetCard(0x5f50) and c:IsFaceup()
end
function s.cfilter(c)
	return c:GetFlagEffect(id)==0 and c:IsCode(id) and c:IsFaceupEx() and c:IsType(TYPE_MONSTER)
end
function s.adop(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	local g1=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(g1) do
		local ct=1
		if Duel.IsExistingMatchingCard(s.subarufilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) then
			if Duel.GetTurnPlayer()==tp then ct=ct+1 end
			tc:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_SELF_TURN,ct)
			tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,ct)
		else
			tc:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,ct)
			tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		end
	end
end
function s.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local code=Duel.AnnounceCard(tp)
	e:SetLabel(code)
end
function s.e2op(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(function(e,re,tp) return re:GetHandler():IsOriginalCodeRule(code) end)
	if Duel.IsExistingMatchingCard(s.subarufilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) then
		if Duel.GetTurnPlayer()==tp then
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
		else
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
		end
	else
		e1:SetReset(RESET_PHASE+PHASE_END,1)
	end
	Duel.RegisterEffect(e1,tp)
end