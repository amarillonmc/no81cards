--尘星之机影 赫波
local m=29065833
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,m+100)
	e3:SetTarget(cm.rettg)
	e3:SetOperation(cm.retop)
	c:RegisterEffect(e3)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.spcheck(c,e,tp)
	return c:IsSetCard(0x87ab) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.operation(e,tp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)==0 then return end
	if c:IsRelateToEffect(e) and c:IsFaceup() and c:IsLocation(LOCATION_MZONE) then
		if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
			local e1=Effect.CreateEffect(c)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			c:RegisterEffect(e1)
			if Duel.IsExistingMatchingCard(cm.spcheck,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg=Duel.SelectMatchingCard(tp,cm.spcheck,tp,LOCATION_HAND,0,1,1,nil,e,tp)
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
function cm.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0) 
end
function cm.tgfil1(c,seq,tc)
	local loc=tc:GetLocation()
	if seq>=5 and seq<=7 then return false end
	local cseq=c:GetSequence()
	local cloc=c:GetLocation()
	if cloc==LOCATION_SZONE and cseq>=5 then return false end
	if cloc==LOCATION_MZONE and cseq>=5 and loc==LOCATION_MZONE
		and (seq==1 and cseq==5 or seq==3 and cseq==6) then return true end
	return cseq==seq or (cloc==loc and math.abs(cseq-seq)==1)
end

function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()<=0 then return end
	local tg=g:Select(tp,1,1,nil)
	Duel.HintSelection(tg)
	local tc=tg:GetFirst()
	local seq=tc:GetSequence()
	local g1=Duel.GetMatchingGroup(cm.tgfil1,tp,0,LOCATION_ONFIELD,nil,seq,tc)
	g1:AddCard(tc)
	Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
end