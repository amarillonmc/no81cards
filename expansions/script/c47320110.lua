--玉露湿凝雾锁窗
local s,id=GetID()
function s.tofield(c)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.tffilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x6c12) and not c:IsForbidden()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tffilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(s.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)

	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,s.tffilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
	if #g>0 then
		local tc=g:GetFirst()
		local istf=Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetCode(EFFECT_CHANGE_TYPE)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
        e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
        tc:RegisterEffect(e1)
        local zone=tc:GetColumnZone(LOCATION_MZONE,tp)
        if istf and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,47320100,0,TYPES_TOKEN_MONSTER,0,1500,3,RACE_ILLUSION,ATTRIBUTE_WATER,POS_FACEUP_DEFENSE)
        and Duel.SelectEffectYesNo(tp,tc,aux.Stringid(id,2)) then
            Duel.BreakEffect()
            local token=Duel.CreateToken(tp,47320100)
	        Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE,zone)
        end
	end
end
function s.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_WATER) and not c:IsLocation(LOCATION_EXTRA)
end
function s.select(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,id)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end
function s.tdfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9c12) and c:IsType(TYPE_PENDULUM) and c:IsAbleToDeck()
end
function s.tdfilter2(c)
	return c:IsSetCard(0x6c12) and c:IsAbleToDeck()
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_EXTRA,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(s.tdfilter2,tp,LOCATION_GRAVE,0,1,e:GetHandler()) and Duel.IsPlayerCanDraw(tp,1)
	if chk==0 then return b1 or b2 end
	local off=1
	local ops,opval={},{}
	if b1 then
		ops[off]=aux.Stringid(id,1)
		opval[off]=0
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(id,3)
		opval[off]=1
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))+1
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==0 then
		e:SetCategory(CATEGORY_TODECK)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_GRAVE)
	else
		e:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_GRAVE)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	if sel==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,s.tdfilter,tp,LOCATION_EXTRA,0,1,1,nil)
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			Duel.HintSelection(g)
			Duel.SendtoDeck(tc,tp,SEQ_DECKTOP,REASON_EFFECT)
			if tc:IsLocation(LOCATION_DECK) then
				tc:ReverseInDeck()
			end
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,s.tdfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 and Duel.SendtoDeck(g,tp,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 then
			Duel.ShuffleDeck(tp)
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
function s.initial_effect(c)
	s.tofield(c)
	s.select(c)
end
