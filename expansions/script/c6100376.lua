--天壤梦弓的诏敕
local s,id,o=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	
	--from hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(s.flipop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

function s.filter(c)
	if not (c:IsFaceup() and c:IsCanTurnSet()) then return false end
	if c:IsSummonType(SUMMON_TYPE_SYNCHRO) or c:IsSummonType(SUMMON_TYPE_XYZ) 
		or c:IsSummonType(SUMMON_TYPE_LINK) or c:IsSummonType(SUMMON_TYPE_PENDULUM) then
		return false
	end
	local re=c:GetReasonEffect()
	if not re or re:GetHandler()~=c then return false end
	return true
end

function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.filter,nil)
	if #g>0 then
		Duel.Hint(HINT_CARD,0,id)
		if Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)>0 then
			local og=Duel.GetOperatedGroup():Filter(Card.IsPosition,nil,POS_FACEDOWN_DEFENSE)
			for tc in aux.Next(og) do
				tc:SetStatus(0x0100,false)
			end
		end
	end
end