--愤怒之云
local m=11621105
local cm=_G["c"..m]
function c11621105.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.condition)
	c:RegisterEffect(e1)	
	--act limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetValue(cm.aclimit)
	c:RegisterEffect(e2)
 --   local e3=e2:Clone()
 --   e3:SetTargetRange(1,0)
 --   e3:SetValue(cm.aclimit2)
 --   c:RegisterEffect(e3)
 --   if not cm.global_check then
   --   cm.global_check=true
	 --   cm.code={}
	  --  cm.code[0]=0
	   -- local ge1=Effect.CreateEffect(c)
--	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  --	  ge1:SetCode(EVENT_CHAINING)
	--  ge1:SetOperation(cm.regop)
	  --  Duel.RegisterEffect(ge1,0)
--	local ge2=Effect.CreateEffect(c)
  --	  ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	--  ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	  --  ge2:SetOperation(cm.clear)
	   -- Duel.RegisterEffect(ge2,0)
  --  end
	if not cm.global_check then
		cm.global_check=true
		cm.code={}
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(cm.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
--
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	if not eg then return end
	local sg=eg:Filter(cm.cfilter,nil)
	local tc=sg:GetFirst() 
	while tc do
		local p=tc:GetControler()--tc:GetOwnerPlayer()		  
		Duel.RegisterFlagEffect(p,m,RESET_PHASE+PHASE_END,0,1,tc:GetCode())
		tc=sg:GetNext()
	end
end

function cm.cfilter(c,tp)
	local te=Duel.GetChainInfo(c,CHAININFO_TRIGGERING_EFFECT)
	return not te:IsHasCategory(CATEGORY_FUSION_SUMMON) and not ( c:IsType(TYPE_RITUAL) and c:IsType(TYPE_SPELL) ) and c:IsLocation(LOCATION_ONFIELD)-- Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)==LOCATION_ONFIELD
end
--function cm.regop(e,tp,eg,ep,ev,re,r,rp)
  --  if not eg then return end
  --  local sg=eg:Filter(cm.cfilter,nil,1-tp)
  --  local tc=sg:GetFirst()
  --  while tc do
  --	  cm.code[#cm.code+1]=tc:GetCode()
   --   tc=sg:GetNext()
   -- end
--end
function cm.clear(e,tp,eg,ep,ev,re,r,rp)
	--Duel.SetFlagEffectLabel(tp,m,0,0,0)
	--cm.code={0,0}
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1,0)
	Duel.RegisterFlagEffect(1-tp,m,RESET_PHASE+PHASE_END,0,1,0)
end
--
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and not Duel.CheckPhaseActivity()
end
--
function cm.aclimit(e,re,tp)
	local rc=re:GetHandler()
	local p=rc:GetControler()
	cm.code={Duel.GetFlagEffectLabel(p,m)}
	if cm.code~=nil then
		--for i=1,#ac do
		return cm.code and rc:IsCode(table.unpack(cm.code))
	else
		return false
	end
end