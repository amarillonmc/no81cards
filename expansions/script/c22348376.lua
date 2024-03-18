--浮 世 柩 的 峰 主
local m=22348376
local cm=_G["c"..m]
function cm.initial_effect(c)
	--adjust
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c22348376.adjustop)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c22348376.settg)
	e2:SetOperation(c22348376.setop)
	c:RegisterEffect(e2)
	if not c22348376.global_check then
		c22348376.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(c22348376.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c22348376.setfilter(c)
	return c:IsSetCard(0x370b) and c:IsType(TYPE_TRAP+TYPE_SPELL) and c:IsSSetable()
end
function c22348376.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c22348376.setfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
end
function c22348376.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c22348376.setfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then Duel.SSet(tp,tc) end end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCountLimit(1)
	e1:SetOperation(c22348376.seqop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c22348376.seqfilter(c)
	return c:GetSequence()<5 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE,PLAYER_NONE,0)>0
end
function c22348376.seqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingTarget(c22348376.seqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
		local g1=Duel.SelectMatchingCard(tp,c22348376.seqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		local tc=g1:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	if tc:IsImmuneToEffect(e) then return end
		if tp==tc:GetControler() then 
			local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
			local nseq=math.log(s,2)
			Duel.MoveSequence(tc,nseq)
		else
			local s=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,0)
			local nseq=math.log(s,2)-16
			Duel.MoveSequence(tc,nseq)
		end
	end
end

function c22348376.filter1(c)
	return c:IsOriginalCodeRule(22348376) and c:IsFacedown() and c:GetColumnGroup():IsExists(Card.IsControler,1,nil,1-c:GetControler())
end
function c22348376.checkop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local g1=Duel.GetMatchingGroup(c22348376.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		Duel.ChangePosition(g1,POS_FACEUP_ATTACK)
end
function c22348376.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local c=e:GetHandler()
	if not c:GetColumnGroup():IsExists(Card.IsControler,1,nil,1-tp) and c:IsFaceup() then
		Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)
	end
end


