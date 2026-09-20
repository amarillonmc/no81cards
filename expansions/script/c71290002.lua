--阿哈时刻
DPEcho=DPEcho or {}
DPEcho.loaded_metatable_list={}

local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,71290002)
	
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_RECOVER+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CUSTOM+m)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.rettg)
	e2:SetOperation(cm.retop)
	c:RegisterEffect(e2)
	
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
	end
	
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if aux.IsCodeListed(tc,m) then 
			if Duel.GetFlagEffect(tp,m+50000000)==0 then
				Duel.RegisterFlagEffect(tp,m+50000000,RESET_PHASE+PHASE_END,0,1)
			else
				Duel.RaiseEvent(eg,m,re,r,rp,ep,ev)
			end
		end
	end
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.RegisterFlagEffect(e:GetHandlerPlayer(),m,RESET_CHAIN,0,1)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local rec,tgc,drc,atk=0
	rec=Duel.GetFlagEffect(tp,m+10000000)
	tgc=Duel.GetFlagEffect(tp,m+20000000)
	drc=Duel.GetFlagEffect(tp,m+30000000)
	atk=Duel.GetFlagEffect(tp,m+40000000)
	if rec~=0 then
		Duel.Recover(tp,500*rec,REASON_EFFECT)
	end
	if tgc~=0 then
		local g=Duel.GetDecktopGroup(tp,tgc)
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
	if drc~=0 then
		Duel.Draw(tp,drc,REASON_EFFECT)
	end
	if atk~=0 then
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(500*atk)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			tc:RegisterEffect(e2)
			tc=g:GetNext()
		end
	end
end
function cm.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end














DPEcho.actnum={}
DPEcho.eff={}
function DPEcho.Register(eff,num)
	effc=eff:GetHandler()
	if not DPEcho.actnum[effc] then DPEcho.actnum[effc]={} end
	if not DPEcho.actnum[effc][eff] then
		local neff=eff:Clone()
		neff:SetType(EFFECT_TYPE_QUICK_F)
		neff:SetCode(EVENT_CHAINING)
		neff:SetCountLimit(99)
		neff:SetRange(0x3ff)
		if eff:GetCondition()~=nil then
			DPEcho.neffcon=eff:GetCondition()
			neff:SetCondition(DPEcho.ncon1)
		else
			neff:SetCondition(DPEcho.ncon2)
		end
		if eff:GetCost()~=nil then
			DPEcho.neffcost=eff:GetCost()
			neff:SetCost(DPEcho.ncost1)
		else
			neff:SetCost(DPEcho.ncost2)
		end
		effc:RegisterEffect(neff)
		DPEcho.eff[neff]=eff

		if eff:GetCost()~=nil then
			DPEcho.effcost=eff:GetCost()
			eff:SetCost(DPEcho.cost1)
		else
			eff:SetCost(DPEcho.cost2)
		end
		effc:RegisterEffect(eff)
		DPEcho.actnum[effc][eff]=num-1
	else
		DPEcho.actnum[effc][eff]=num-1
	end
end
function DPEcho.ncon1(e,tp,eg,ep,ev,re,r,rp)
	return DPEcho.ncon2(e,tp,eg,ep,ev,re,r,rp) 
		and DPEcho.neffcon(e,tp,eg,ep,ev,re,r,rp)
end
function DPEcho.ncon2(e,tp,eg,ep,ev,re,r,rp)
	local eccode=m+e:GetHandler():GetOriginalCode()
	return e:GetHandler():GetFlagEffect(eccode)~=0
end
function DPEcho.ncost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return DPEcho.neffcost(e,tp,eg,ep,ev,re,r,rp,chk) end
	DPEcho.neffcost(e,tp,eg,ep,ev,re,r,rp,chk)
	DPEcho.ncost2(e,tp,eg,ep,ev,re,r,rp,chk)
end
function DPEcho.ncost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local eccode=m+e:GetHandler():GetOriginalCode()
	local eff=DPEcho.eff[e]
	local effc=eff:GetHandler()
	if chk==0 then return true end
	--Debug.Message(e:GetHandler():GetFlagEffect(eccode*2)+1)
	--Debug.Message(DPEcho.actnum[effc][eff])
	if e:GetHandler():GetFlagEffect(eccode*2)+1>=DPEcho.actnum[effc][eff] then
		e:GetHandler():ResetFlagEffect(eccode)
		e:GetHandler():ResetFlagEffect(eccode*2)
	else
		e:GetHandler():RegisterFlagEffect(eccode*2,0,0,1)
	end
end


function DPEcho.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return DPEcho.effcost(e,tp,eg,ep,ev,re,r,rp,chk) end
	DPEcho.effcost(e,tp,eg,ep,ev,re,r,rp,chk)
	DPEcho.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
end
function DPEcho.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local eccode=m+e:GetHandler():GetOriginalCode()
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(eccode,0,0,1)
end






