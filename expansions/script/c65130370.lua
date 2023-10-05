--无尽镜界
if not require and loadfile then
	function require(str)
		require_list=require_list or {}
		if not require_list[str] then
			if string.find(str,"%.") then
				require_list[str]=loadfile(str)
			else
				require_list[str]=loadfile(str..".lua")
			end
			require_list[str]()
			return require_list[str]
		end
		return require_list[str]
	end
end
if not pcall(require,"expansions/script/c65199999") then pcall(require,"script/c65199999") end
local s,id,o=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--contact fusion set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(s.actcon)
	e2:SetOperation(s.actop)
	c:RegisterEffect(e2)
	--Exile
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(s.excon)
	e3:SetOperation(s.exop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e5)
	--no draw
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_PREDRAW)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCondition(s.spcon)
	e6:SetTarget(s.sptg)
	e6:SetOperation(s.spop)
	c:RegisterEffect(e6)
	--Change
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_ADJUST)
	e7:SetRange(LOCATION_FZONE)
	e7:SetCondition(s.changecon)
	e7:SetOperation(s.changeop)
	c:RegisterEffect(e7)
	--damage
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetCode(EFFECT_CHANGE_DAMAGE)
	e12:SetRange(LOCATION_FZONE)
	e12:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e12:SetTargetRange(1,0)
	e12:SetValue(0)
	c:RegisterEffect(e12)
	if not s.global_check then
		s.global_check=true
		_SetLP=Duel.SetLP
		function Duel.SetLP(p,lp)
			local fc=Duel.GetFieldGroup(p,LOCATION_FZONE,0):GetFirst()
			if fc and fc:GetOriginalCode()==id then
				Duel.Hint(HINT_CARD,0,id)
				return
			end
			_SetLP(p,lp)
		end
		_CheckLPCost=Duel.CheckLPCost
		function Duel.CheckLPCost(p,cost)
			local fc=Duel.GetFieldGroup(p,LOCATION_FZONE,0):GetFirst()
			if fc and fc:GetOriginalCode()==id then return true end
			return _CheckLPCost(p,cost)
		end
		_PayLPCost=Duel.PayLPCost
		function Duel.PayLPCost(p,cost)
			local fc=Duel.GetFieldGroup(p,LOCATION_FZONE,0):GetFirst()
			if fc and fc:GetOriginalCode()==id then
				Duel.Hint(HINT_CARD,0,id)
				return
			end
			_PayLPCost(p,cost)
		end  
	end
end
Mirrors_World_Card={}
function s.actfilter(c,tp)
	return c:IsOriginalCodeRule(65130366) and c:IsAbleToGraveAsCost() and c:IsAttackAbove(100000) and c:IsControler(tp)
end
function s.actcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.actfilter,1,nil,tp)
end
function s.actop(e,tp,eg,ep,ev,re,r,rp)
	local cg=eg:Filter(s.actfilter,nil)
	if cg:GetCount()==0 then return end
	local tc=cg:Select(tp,1,1,nil):GetFirst()
	Duel.SendtoGrave(tc,REASON_COST)
	local c=e:GetHandler()
	local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
	if fc then
		Duel.SendtoGrave(fc,REASON_RULE)
		Duel.BreakEffect()
	end
	Duel.MoveToField(c,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	local g=Duel.GetFieldGroup(tp,0xff,0xff)
	local g2=Duel.GetOverlayGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	for tc in aux.Next(g2) do
		local ag=tc:GetOverlayGroup()
		if ag then g:AddCard(ag) end
	end
	Duel.Exile(g:Filter(function(c,tp) return c:GetOwner()==tp end,c,tp),REASON_EFFECT)
	--Duel.SSet(tp,c)
	--Duel.ChangePosition(c,POS_FACEUP)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SSET)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.setlimit)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1,true)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetValue(s.actlimit)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e2,true)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetValue(s.efilter)
	c:RegisterEffect(e4,true)
	--cannot
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_CANNOT_REMOVE)
	c:RegisterEffect(e5,true)
	local e6=e4:Clone()
	e6:SetCode(EFFECT_CANNOT_TO_DECK)
	c:RegisterEffect(e6,true)
	local e7=e4:Clone()
	e7:SetCode(EFFECT_CANNOT_TO_HAND)
	c:RegisterEffect(e7,true)
	local e8=e4:Clone()
	e8:SetCode(EFFECT_UNRELEASABLE_SUM)
	c:RegisterEffect(e8,true)
	local e9=e4:Clone()
	e9:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e9,true)
	local e10=e4:Clone()
	e10:SetCode(EFFECT_CANNOT_TO_GRAVE)
	c:RegisterEffect(e10,true)
	--send replace
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e11:SetCode(EFFECT_SEND_REPLACE)
	e11:SetRange(LOCATION_FZONE)
	e11:SetTarget(aux.TRUE)
	e11:SetValue(aux.FALSE)
	c:RegisterEffect(e11,true)
	
end
function s.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function s.setlimit(e,c,tp)
	return c:IsType(TYPE_FIELD)
end
function s.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function s.excon(e,tp,eg,ep,ev,re,r,rp)  
	return rp==1-tp and Duel.GetFieldGroup(rp,LOCATION_DECK,0)
end
function s.exop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dg=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
	if dg:GetCount()>0 then
		local tc=dg:RandomSelect(tp,1):GetFirst()
		table.insert(Mirrors_World_Card,tc:GetOriginalCode())
		Duel.Exile(tc,REASON_EFFECT)
		if #Mirrors_World_Card==1 then
			Debug.Message("接下来，在一步步前进的过程中，你的同伴将会一个接着一个的消失")
		end
	end
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local dt=Duel.GetDrawCount(tp)
	if dt~=0 then
		aux.DrawReplaceCount=0
		aux.DrawReplaceMax=dt
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_DRAW)
		e1:SetValue(0)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)   
	if ct>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,id+1,0,TYPES_TOKEN_MONSTER,5000,5000,1,RACE_SPELLCASTER,ATTRIBUTE_DARK,POS_FACEUP_ATTACK) then
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
		for i=1,ct do
			local token=Duel.CreateToken(tp,id+zsx_roll(1,4))
			zsx_RandomSpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_ATTACK)
		end
		Duel.SpecialSummonComplete()
	end
end
function s.changecon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_DECK)==0
end
function s.changeop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,65130375)
	c:SetEntityCode(65130379)
	c:SetEntityCode(65130375,true)
	c:ReplaceEffect(65130375,0,0)
	Duel.SetLP(c:GetControler(),100000)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil)
	Duel.Destroy(sg,REASON_RULE)
end