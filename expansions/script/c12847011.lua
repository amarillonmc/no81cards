--再来一发？
local s,id,o=GetID()
function s.initial_effect(c)
	 --cannot set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SSET)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(0xff)
	e2:SetTargetRange(1,1)
	e2:SetTarget(s.atarget)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_NEGATED)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(s.discon)
	e3:SetOperation(s.disop)
	c:RegisterEffect(e3)
	if not s.global_check then
		s.global_check=true
		s.sumgroup=Group.CreateGroup()
		s.sumgroup:KeepAlive()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON)
		ge1:SetOperation(s.sumop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_FLIP_SUMMON)
		Duel.RegisterEffect(ge2,0)
		local ge3=ge1:Clone()
		ge3:SetCode(EVENT_SPSUMMON)
		Duel.RegisterEffect(ge3,0)

		s.sumsgroup=Group.CreateGroup()
		s.sumsgroup:KeepAlive()
		local ge4=Effect.CreateEffect(c)
		ge4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge4:SetCode(EVENT_SUMMON_SUCCESS)
		ge4:SetOperation(s.sumsop)
		Duel.RegisterEffect(ge1,0)
		local ge5=ge4:Clone()
		ge5:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
		Duel.RegisterEffect(ge5,0)
		local ge6=ge4:Clone()
		ge6:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge6,0)
	end
end
function s.atarget(e,c)
	return c==e:GetHandler()
end
function s.sumop(e,tp,eg,ep,ev,re,r,rp)
	if eg then s.sumgroup:Merge(eg) end
	local ge1=Effect.GlobalEffect()
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetCode(EVENT_CHAIN_END)
	ge1:SetLabelObject(s.sumgroup)
	ge1:SetOperation(s.resetop)
	Duel.RegisterEffect(ge1,0)
end
function s.sumsop(e,tp,eg,ep,ev,re,r,rp)
	if eg then s.sumsgroup:Merge(eg) end
	local ge1=Effect.GlobalEffect()
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetCode(EVENT_CHAIN_END)
	ge1:SetLabelObject(s.sumsgroup)
	ge1:SetOperation(s.resetop)
	Duel.RegisterEffect(ge1,0)
end
function s.resetop(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():Clear()
	e:Reset()
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	local p,dp,te=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_PLAYER,CHAININFO_DISABLE_PLAYER,CHAININFO_TRIGGERING_EFFECT)
	return dp==1-tp and e:GetHandler():IsPublic()
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,dp,te=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_PLAYER,CHAININFO_DISABLE_PLAYER,CHAININFO_TRIGGERING_EFFECT)
	local ec=te:GetHandler()
	if Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.ConfirmCards(tp,c)
		Duel.SendtoGrave(c,REASON_RULE)
		local res=Duel.TossCoin(tp,1)
		if res==1 then
			Duel.Hint(HINT_CARD,0,ec:GetOriginalCode())
			local erg=Group.CreateGroup()
			local fre=Effect.GlobalEffect()
			local feg=Group.CreateGroup()
			local code=te:GetCode()
			if code==EVENT_CHAINING then
				fre=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT)
				local fc=fre:GetHandler()
				feg:AddCard(fc)
			end
			if code==EVENT_SUMMON or code==EVENT_FLIP_SUMMON or code==EVENT_SPSUMMON then
				feg:Merge(s.sumgroup)
			end
			if code==EVENT_SUMMON_SUCCESS or code==EVENT_FLIP_SUMMON_SUCCESS or code==EVENT_SPSUMMON_SUCCESS then
				feg:Merge(s.sumsgroup)
			end
			ec:CreateEffectRelation(te)
			local operation=te:GetOperation()
			local ftgpy=Duel.GetChainInfo(ev,CHAININFO_TARGET_PLAYER)
			local ftgpr=Duel.GetChainInfo(ev,CHAININFO_TARGET_PARAM)
			local ftgc=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
			Duel.SetTargetPlayer(ftgpy)
			Duel.SetTargetParam(ftgpr)
			if ftgc then
				for tc in aux.Next(ftgc) do
					tc:CreateEffectRelation(te)
					erg:AddCard(tc)
				end
				Duel.SetTargetCard(ftgc)
			end
			if operation then operation(te,p,feg,ep,ev-1,fre,r,rp) end
			ec:ReleaseEffectRelation(te)
			if erg then
				for tc in aux.Next(erg) do
					tc:ReleaseEffectRelation(te)
				end
			end
		else
			Duel.SetLP(tp,math.floor(Duel.GetLP(tp)/2))
		end
	end
end
