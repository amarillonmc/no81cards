--诡异降临
local s,id,o=GetID()
function s.initial_effect(c)
	--发动
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SSET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_STANDBY_PHASE,TIMING_STANDBY_PHASE)
	e1:SetTarget(s.settg)
	e1:SetOperation(s.setop)
	c:RegisterEffect(e1)
	--从手卡发动
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(s.handcon)
	c:RegisterEffect(e2)
end
s.has_text_type=TYPE_DUAL
function s.setfilter(c,tp)
	local b1=c:IsType(TYPE_SPELL) and c:IsSSetable()
    local b2=c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
	return aux.IsTypeInText(c,TYPE_DUAL) and (b1 or b2)
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
    if e:IsHasType(EFFECT_TYPE_ACTIVATE) and not e:GetHandler():IsLocation(LOCATION_SZONE) then ft=ft-1 end
	if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil,tp) and ft>0 end
    if e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) then
		e:SetLabel(100)
	end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then 
    	if tc:IsType(TYPE_SPELL) then
    		if Duel.SSet(tp,tc)~=0 and tc:IsType(TYPE_QUICKPLAY) then
            	local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetDescription(aux.Stringid(id,1))
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)            
            end
        else
        	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
        end
    end
    if e:GetLabel()==100 then
    	local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetTarget(s.splimit)
		if Duel.GetTurnPlayer()==tp then
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
		else
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
		end
		Duel.RegisterEffect(e1,tp)
    end
end
function s.splimit(e,c)
	return not c:IsType(TYPE_NORMAL+TYPE_DUAL) and not c:IsLocation(LOCATION_EXTRA)
end
function s.handcon(e)
	return Duel.GetCurrentPhase()==PHASE_STANDBY
end