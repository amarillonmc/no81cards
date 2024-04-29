if QutryZyqw then return end
QutryZyqw = {}

if not QUTRY_SUMMONRULE_CHECK then
	QUTRY_SUMMONRULE_CHECK=true
	QUTRY_SUMMONING_GROUP=Group.CreateGroup()
	local summon_set={"Summon","MSet","SpecialSummonRule","SynchroSummon","XyzSummon","XyzSummonByRose","LinkSummon"}
	for i,fname in pairs(summon_set) do
		local temp_f=Duel[fname]
		Duel[fname]=function(p,c,...)
			temp_f(p,c,...)
			if Duel.GetCurrentChain()==1 then QUTRY_SUMMONING_GROUP:AddCard(c) end
		end
	end
end
function QutryZyqw.RegisterMergedDelayedEvent(c,code,event,g)
	local mt=getmetatable(c)
	if mt[event]==true then return end
	mt[event]=true
	if not g then g=Group.CreateGroup() end
	g:KeepAlive()
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetCode(event)
	ge1:SetLabel(code)
	ge1:SetLabelObject(g)
	ge1:SetOperation(QutryZyqw.MergedDelayEventCheck1)
	Duel.RegisterEffect(ge1,0)
	local ge2=ge1:Clone()
	ge2:SetCode(EVENT_CHAIN_SOLVED)
	ge2:SetOperation(QutryZyqw.MergedDelayEventCheck2)
	Duel.RegisterEffect(ge2,0)
	local ge3=ge2:Clone()
	ge3:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(ge3,0)
	local ge4=ge1:Clone()
	ge4:SetCode(EVENT_SPSUMMON_NEGATED)
	ge4:SetOperation(QutryZyqw.MergedDelayEventCheck3)
	Duel.RegisterEffect(ge4,0)
end
function QutryZyqw.MergedDelayEventCheck1(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	g:Merge(eg)
	if Duel.GetCurrentChain()==0 then
		if #Group.__band(QUTRY_SUMMONING_GROUP,eg)==0 then
			local _eg=g:Clone()
			Duel.RaiseEvent(_eg,EVENT_CUSTOM+e:GetLabel(),re,r,rp,ep,ev)
		else
			eg:ForEach(Card.RegisterFlagEffect,9911550,RESET_CHAIN,0,1)
			QUTRY_SUMMONING_GROUP:Clear()
		end
		g:Clear()
	end
end
function QutryZyqw.MergedDelayEventCheck2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()~=1 then return end
	local g=e:GetLabelObject()
	if #g>0 then
		local _eg=g:Clone()
		Duel.RaiseEvent(_eg,EVENT_CUSTOM+e:GetLabel(),re,r,rp,ep,ev)
		if #QUTRY_SUMMONING_GROUP>0 then Duel.RaiseEvent(_eg+QUTRY_SUMMONING_GROUP,EVENT_CUSTOM+e:GetLabel()+1,re,r,rp,ep,ev) end
		g:Clear()
	end
end
function QutryZyqw.MergedDelayEventCheck3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()==0 and #Group.__band(QUTRY_SUMMONING_GROUP,eg)>0 then
		eg:ForEach(Card.RegisterFlagEffect,9911551,RESET_CHAIN,0,1)
		QUTRY_SUMMONING_GROUP:Clear()
	end
end
