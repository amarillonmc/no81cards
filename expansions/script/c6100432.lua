--刻律之尤多拉
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(0x1)

	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.tncon)
	e1:SetOperation(s.tnop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(s.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0)) 
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id)
	e3:SetCondition(s.ctcon)
	e3:SetTarget(s.cttg)
	e3:SetOperation(s.ctop)
	c:RegisterEffect(e3)

	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(s.negcon)
	e4:SetOperation(s.negop)
	c:RegisterEffect(e4)

	if not s.global_check then
		s.global_check=true
		s.chain_list = {}
		s.chain_players = {[0]=false, [1]=false}
		
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			s.chain_list[ev] = re
			s.chain_players[rp] = true
		end)
		Duel.RegisterEffect(ge1,0)
		
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAIN_END)
		ge2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			s.chain_list = {}
			s.chain_players[0] = false
			s.chain_players[1] = false
		end)
		Duel.RegisterEffect(ge2,0)
	end

end

function s.valcheck(e,c)
	local g=c:GetMaterial()
	local ct=g:FilterCount(Card.IsType, nil, TYPE_SYNCHRO+TYPE_FUSION)
	e:GetLabelObject():SetLabel(ct)
end
function s.tncon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetLabel() > 0
end
function s.tnop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x1, e:GetLabel())
end

function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	if rp == tp or ev == 1 then return false end
	return not s.chain_players[tp]
end
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanAddCounter(0x1, 1) end
	Duel.SetOperationInfo(0, CATEGORY_COUNTER, e:GetHandler(), 1, 0, 0)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		c:AddCounter(0x1, 1)
	end
end

function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	if rp == tp then return false end
	if Duel.GetFlagEffect(tp, id+1) > 0 then return false end
	if c:GetCounter(0x1) == 0 then return false end
	if not Duel.IsChainDisablable(ev) then return false end

	local r_type = re:GetActiveType() & 0x7 
	local same_type = false
	
	for i, te in pairs(s.chain_list) do
		if i ~= ev then 
			if (te:GetActiveType() & 0x7) == r_type then
				same_type = true
				break
			end
		end
	end
	
	return same_type
end

function s.negop(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	if Duel.GetFlagEffect(tp, id+1) > 0 then return end
	if c:GetCounter(0x1) == 0 then return end
	
	if Duel.SelectYesNo(tp, aux.Stringid(id, 1)) then
		Duel.Hint(HINT_CARD, 0, id)
		Duel.RegisterFlagEffect(tp, id+1, RESET_PHASE+PHASE_END, 0, 1)
		c:RemoveCounter(tp, 0x1, 1, REASON_EFFECT)
		
		local rc = re:GetHandler()
		local same_name = false
		
		for i, te in pairs(s.chain_list) do
			if i ~= ev then
				local tc = te:GetHandler()
				if tc:IsCode(rc:GetCode()) then
					same_name = true
					break
				end
			end
		end
		
		if Duel.NegateEffect(ev) and same_name and rc:IsRelateToEffect(re) then
			if Duel.SelectYesNo(tp, aux.Stringid(id, 2)) then
				Duel.Destroy(rc, REASON_EFFECT)
			end
		end
	end
end