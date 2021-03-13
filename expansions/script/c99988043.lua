--亡语巫师 恶灵巫术士
function c99988043.initial_effect(c)
	--trol
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99988043,0))
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,99988043)
	e1:SetTarget(c99988043.cttg)
	e1:SetOperation(c99988043.ctop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99988043,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,199988043)
	e3:SetCost(c99988043.setcost)
	e3:SetOperation(c99988043.setop)
	c:RegisterEffect(e3)
end
function c99988043.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,0,0)
end	
function c99988043.ctop(e,tp,eg,ep,ev,re,r,rp,chk)   
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectMatchingCard(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.GetControl(g:GetFirst(),tp,PHASE_END,1)
	end
end
function c99988043.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,nil,1,e:GetHandler()) end
	local g=Duel.SelectReleaseGroup(tp,nil,1,1,e:GetHandler())
	Duel.Release(g,REASON_COST)
end
function c99988043.setfilter(c)
	return c:IsSetCard(0x20df) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c99988043.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c99988043.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SSet(tp,tc)~=0 then
		if tc:IsType(TYPE_QUICKPLAY) or tc:GetType()==TYPE_TRAP then
			local e1=Effect.CreateEffect(e:GetHandler())
    		e1:SetType(EFFECT_TYPE_SINGLE)
    		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
    		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
    		tc:RegisterEffect(e1)
    		local e2=e1:Clone()
    		e2:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
    		tc:RegisterEffect(e2)
		end
	end
end
	