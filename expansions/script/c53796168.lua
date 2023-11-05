local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_BATTLE_START)
	e1:SetTarget(s.tg)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_CUSTOM+id)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCondition(s.damcon)
	e2:SetTarget(s.damtg)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.mtcon)
	e3:SetOperation(s.mtop)
	c:RegisterEffect(e3)
	if Master_and_Servant then return end
	Master_and_Servant=true
	local g=Group.CreateGroup()
	g:KeepAlive()
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetCode(EVENT_DESTROYED)
	ge1:SetLabelObject(g)
	ge1:SetOperation(s.MergedDelayEventCheck1)
	Duel.RegisterEffect(ge1,0)
	local ge2=ge1:Clone()
	ge2:SetCode(EVENT_CHAIN_END)
	ge2:SetOperation(s.MergedDelayEventCheck2)
	Duel.RegisterEffect(ge2,0)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(EVENT_CUSTOM+id,true)
	if res and s.damcon(e,tp,teg,tep,tev,tre,tr,trp) and s.damtg(e,tp,teg,tep,tev,tre,tr,trp,0) then
		s.damtg(e,tp,teg,tep,tev,tre,tr,trp,1)
		e:SetCategory(CATEGORY_DAMAGE)
		e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	else
		e:SetOperation(nil)
		e:SetCategory(0)
		e:SetProperty(0)
	end
end
function s.cfilter(c)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsReason(REASON_EFFECT)
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return eg:IsExists(s.cfilter,1,nil) and Duel.IsBattlePhase()
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(s.cfilter,nil)
	local dam1,dam2=0,0
	local p=0
	for tc in aux.Next(g) do
		if tc:IsPreviousControler(tp) then if p~=1 and p~=3 then p=p+1 end dam1=dam1+tc:GetBaseAttack() else if p~=2 and p~=3 then p=p+2 end dam2=dam2+tc:GetBaseAttack() end
	end
	e:SetOperation(nil)
	if e:GetHandler():IsStatus(STATUS_EFFECT_ENABLED) then
		local ev0=Duel.GetCurrentChain()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EVENT_CHAIN_SOLVING)
		e1:SetLabel(dam1,dam2)
		e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return ev==ev0 end)
		e1:SetOperation(s.op)
		e1:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e1,tp)
	else e:SetOperation(s.damop(dam1,dam2)) end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,p,math.min(dam1,dam2))
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local dam1,dam2=e:GetLabel()
	Duel.ChangeTargetCard(ev,Group.CreateGroup())
	Duel.ChangeChainOperation(ev,s.damop(dam1,dam2))
	e:GetOwner():CancelToGrave(true)
	e:Reset()
end
function s.damop(dam1,dam2)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				local res=(dam1>0 and dam2>0)
				if dam1>0 then Duel.Damage(tp,dam1,REASON_EFFECT,res) end
				if dam2>0 then Duel.Damage(1-tp,dam2,REASON_EFFECT,res) end
				if res then Duel.RDComplete() end
			end
end
function s.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.mtop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CheckLPCost(tp,1000) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then Duel.PayLPCost(tp,1000) else Duel.Destroy(e:GetHandler(),REASON_COST) end
end
function s.MergedDelayEventCheck1(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	g:Merge(eg:Filter(function(c,re)return re and re:IsActiveType(TYPE_MONSTER)end,nil,re))
	if Duel.GetCurrentChain()==0 and not Duel.CheckEvent(EVENT_CHAIN_END) then
		local _eg=g:Clone()
		Duel.RaiseEvent(_eg,EVENT_CUSTOM+id,re,r,rp,ep,ev)
		g:Clear()
	end
end
function s.MergedDelayEventCheck2(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if #g>0 then
		local _eg=g:Clone()
		Duel.RaiseEvent(_eg,EVENT_CUSTOM+id,re,r,rp,ep,ev)
		g:Clear()
	end
end
