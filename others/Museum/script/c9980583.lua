--未确认4号处决！
function c9980583.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCondition(c9980583.condition)
	e1:SetTarget(c9980583.target)
	e1:SetOperation(c9980583.activate)
	c:RegisterEffect(e1)
	if not c9980583.global_check then
		c9980583.global_check=true
		c9980583[0]=false
		c9980583[1]=false
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BATTLE_DESTROYED)
		ge1:SetOperation(c9980583.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c9980583.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
c9980583.card_code_list={9980400}
function c9980583.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		local pos=tc:GetPosition()
		if aux.IsCodeListed(c,9980400) and tc:IsType(TYPE_MONSTER) and tc:IsLocation(LOCATION_GRAVE) and tc:IsReason(REASON_BATTLE+REASON_EFFECT)
			and tc:GetControler()==tc:GetPreviousControler() then
			c9980583[tc:GetControler()]=true
		end
		tc=eg:GetNext()
	end
end
function c9980583.clear(e,tp,eg,ep,ev,re,r,rp)
	c9980583[0]=false
	c9980583[1]=false
end
function c9980583.filter(c,id,e,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:GetTurnID()==id and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c9980583.condition(e,tp,eg,ep,ev,re,r,rp)
	return c9980583[tp] and Duel.GetFlagEffect(tp,9980583)==0
end
function c9980583.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c9980583.filter,tp,LOCATION_GRAVE,0,1,nil,Duel.GetTurnCount(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	Duel.RegisterFlagEffect(tp,9980583,RESET_PHASE+PHASE_END,0,1)
end
function c9980583.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9980583.filter,tp,LOCATION_GRAVE,0,ft,ft,nil,Duel.GetTurnCount(),e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		Duel.BreakEffect()
		Duel.Damage(1-tp,g:GetCount()*500,REASON_EFFECT)
	end
end
