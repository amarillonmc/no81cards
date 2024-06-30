--[[
花花变身·动物朋友 稻荷神
H-Anifriends Oinari-Sama
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,aux.Tuner(nil),nil,nil,nil,1,99,s.matcheck)
	c:EnableReviveLimit()
	--This card's name becomes "Anifriends Oinari-Sama" while on the field or in the GY.
	aux.EnableChangeCode(c,33700105,LOCATION_MZONE|LOCATION_GRAVE)
	--[[During the End Phase, if the only card effects you activated this turn were the effects of 3 or more "Anifriends" cards with different names, or the effects of 3 or more cards with the same name: Place a number of counters on this card, equal to the number of those effects you activated this turn.]]
	c:EnableCounterPermit(COUNTER_H_ANIFRIENDS_OINARI_SAMA)
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE|PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:OPT()
	e1:SetFunctions(s.ctcon,nil,s.cttg,s.ctop)
	c:RegisterEffect(e1)
	aux.RegisterTriggeringArchetypeCheck(c,ARCHE_ANIFRIENDS)
	--If a card(s) you control would be destroyed by battle or by your opponent's card effect, you can remove 1 counter from this card for each monster that would be destroyed, instead (you must protect all your cards that would be destroyed, if you use this effect).
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.reptg)
	e2:SetValue(s.repval)
	c:RegisterEffect(e2)
	if not s.ActivatedCodes then
		s.ActivatedAnifriendsCount={0,0}
		s.ActivatedCodesCount={0,0}
		s.ActivatedAnifriends={{},{}}
		s.ActivatedCodes={{},{}}
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_CONTINUOUS|EFFECT_TYPE_FIELD)
		ge1:SetCode(EVENT_CHAIN_SOLVING)
		ge1:SetOperation(s.regop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.GlobalEffect()
		ge2:SetType(EFFECT_TYPE_CONTINUOUS|EFFECT_TYPE_FIELD)
		ge2:SetCode(EVENT_TURN_END)
		ge2:OPT()
		ge2:SetOperation(s.resetop)
		Duel.RegisterEffect(ge2,0)
	end
end

function s.matcheck(mg)
	local syncard=self_reference_effect:GetHandler()
	if #mg==2 then
		local mc1,mc2=mg:GetFirst(),mg:GetNext()
		local res=aux.Tuner(nil)(mc1,syncard) and mc2:IsSetCard(ARCHE_ANIFRIENDS)
		if not res then
			res=aux.Tuner(nil)(mc2,syncard) and mc1:IsSetCard(ARCHE_ANIFRIENDS)
		end
		return res
	else
		local tuners=mg:Filter(aux.Tuner(nil),nil,syncard)
		for tuner in aux.Next(tuners) do
			local other_mats=mg:Filter(aux.TRUE,tuner)
			if other_mats:GetClassCount(Card.GetCode)==1 then
				return true
			end
		end
		return false
	end
end

function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local p=ep+1
	local count=s.ActivatedCodesCount[p]
	if count<0 and s.ActivatedAnifriendsCount[p]==0 then return end
	local code1,code2=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CODE,CHAININFO_TRIGGERING_CODE2)
	if count==0 then
		if aux.CheckArchetypeReasonEffect(s,re,ARCHE_ANIFRIENDS) then
			table.insert(s.ActivatedAnifriends[p],code1)
			if code2 and code2~=0 then
				table.insert(s.ActivatedAnifriends[p],code2)
			end
			s.ActivatedAnifriendsCount[p]=1
		end
		table.insert(s.ActivatedCodes[p],code1)
		if code2 and code2~=0 then
			table.insert(s.ActivatedCodes[p],code2)
		end
		s.ActivatedCodesCount[p]=1
	else
		if s.ActivatedAnifriendsCount[p]~=0 and aux.CheckArchetypeReasonEffect(s,re,ARCHE_ANIFRIENDS) then
			if aux.FindInTable(s.ActivatedAnifriends[p],code1) and (not code2 or code2==0 or aux.FindInTable(s.ActivatedAnifriends[p],code2)) then
				s.ActivatedAnifriendsCount[p]=0
			else
				table.insert(s.ActivatedAnifriends[p],code1)
				if code2 and code2~=0 then
					table.insert(s.ActivatedAnifriends[p],code2)
				end
				s.ActivatedAnifriendsCount[p]=s.ActivatedAnifriendsCount[p]+1
			end
		end
		if not aux.FindInTable(s.ActivatedCodes[p],code1) and (not code2 or code2==0 or not aux.FindInTable(s.ActivatedCodes[p],code2)) then
			s.ActivatedCodesCount[p]=-1
		else
			s.ActivatedCodesCount[p]=s.ActivatedCodesCount[p]+1
		end
	end
end
function s.resetop(e,tp,eg,ep,ev,re,r,rp)
	for i=1,2 do
		s.ActivatedAnifriendsCount[i]=0
		s.ActivatedCodesCount[i]=0
		for j=1,2 do
			aux.ClearTable(s.ActivatedAnifriends[j])
			aux.ClearTable(s.ActivatedCodes[j])
		end
	end
end

--E1
function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return s.ActivatedAnifriendsCount[tp+1]>=3 or s.ActivatedCodesCount[tp+1]>=3
end
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local val=math.max(s.ActivatedAnifriendsCount[tp+1],s.ActivatedCodesCount[tp+1])
	Duel.SetTargetParam(val)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,e:GetHandler(),val,tp,COUNTER_H_ANIFRIENDS_OINARI_SAMA)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local val=Duel.GetTargetParam()
	if val and c:IsRelateToChain() and c:IsCanAddCounter(COUNTER_H_ANIFRIENDS_OINARI_SAMA,val) then
		c:AddCounter(COUNTER_H_ANIFRIENDS_OINARI_SAMA,val)
	end
end

--E2
function s.repfilter(c,tp)
	return c:IsControler(tp) and c:IsOnField() and not c:IsReason(REASON_REPLACE)
		and (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp))
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=eg:FilterCount(s.repfilter,nil,tp)
	if chk==0 then return ct>0 and c:IsCanRemoveCounter(tp,COUNTER_H_ANIFRIENDS_OINARI_SAMA,ct,REASON_EFFECT|REASON_REPLACE) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		c:RemoveCounter(tp,COUNTER_H_ANIFRIENDS_OINARI_SAMA,ct,REASON_EFFECT|REASON_REPLACE)
		return true
	else
		return false
	end
end
function s.repval(e,c)
	return s.repfilter(c,e:GetHandlerPlayer())
end