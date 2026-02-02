--棱镜世界的旋律-「诡计之泪」
local s,id,o=GetID()
function s.initial_effect(c)
	if not (yume and yume.prism) then
		yume=yume or {}
		yume.import_flag=true
		c:CopyEffect(71405000,0)
		yume.import_flag=false
	end
	yume.prism.addCounter()
	--same effect send this card to grave or banishment and summon another card check
	local e0=aux.AddThisCardInGraveAlreadyCheck(c)
	local e0a=yume.AddThisCardBanishedAlreadyCheck(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCountLimit(1,id)
	e1:SetCost(yume.prism.Cost)
	e1:SetTarget(s.tg1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
	--cannot be effect target
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,id+100000)
	e2:SetCondition(s.con2)
	e2:SetLabelObject(e0)
	e2:SetCost(s.cost2)
	e2:SetTarget(s.tg2)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
	local e2a=e1:Clone()
	e2a:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2a:SetRange(LOCATION_REMOVED)
	e2a:SetLabelObject(e0a)
	c:RegisterEffect(e2a)
end
function s.filter1(c,e,tp)
	return c:IsSetCard(0x716) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler(),0x716)
			and Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.filter1a(c,e,tp)
	return c:IsFaceup() and c:IsLocation(LOCATION_ONFIELD)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_REMOVED,0,aux.ExceptThisCard(e),0x716)
	local ct=g:GetCount()
	if ct==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local rg=g:Select(tp,1,ct,nil)
	ct=rg:GetCount()
	if ct>0 then
		local fg=rg:Filter(s.filter1a,nil)
		local og=rg-fg
		Duel.ConfirmCards(1-tp,og)
		Duel.HintSelection(fg)
		if og:Filter(Card.IsLocation,nil,LOCATION_HAND):GetCount()>=1 then
			Duel.ShuffleHand(tp)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
		if sc then
			Duel.BreakEffect()
			if Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_LEVEL)
				e1:SetValue(ct)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				sc:RegisterEffect(e1,true)
			end
			Duel.SpecialSummonComplete()
		end
	end
end
function s.filtercon2(c,se)
	return (se==nil or c:GetReasonEffect()~=se) and c:GetSummonLocation(LOCATION_EXTRA)
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	local se=e:GetLabelObject():GetLabelObject()
	return eg:IsExists(s.filtercon2,2,nil,se)
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return yume.prism.checkCounter(tp) and e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_COST)
	yume.prism.regCostLimit(e,tp)
end
function s.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 end
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(s.imlimit)
	e1:SetValue(aux.tgoval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
end
function s.imlimit(e,c)
	return c:IsFaceup() and c:IsSetCard(0x716)
end