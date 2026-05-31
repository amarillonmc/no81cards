--空创魔兽 戈尔贡

local s,id=GetID()
s.named_with_HighEvo=1

function s.HighEvo(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_HighEvo
end

function s.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.thcost)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_TODECK+CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end

function s.costfilter(c)
	return s.HighEvo(c) and c:IsDiscardable()
end

function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable()
		and Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_HAND,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_HAND,0,1,1,c)
	g:AddCard(c)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end

function s.type_val(c)
	if c:IsType(TYPE_MONSTER) then return 1
	elseif c:IsType(TYPE_SPELL) then return 2
	elseif c:IsType(TYPE_TRAP) then return 3 end
	return 0
end
function s.thcheck(g)
	return g:GetClassCount(s.type_val)==#g
end

function s.thfilter(c)
	return s.HighEvo(c) and not c:IsCode(id) and c:IsAbleToHand()
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
		return g:CheckSubGroup(s.thcheck,2,2)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	if #g>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:SelectSubGroup(tp,s.thcheck,false,2,2)
		if sg and #sg==2 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end

function s.cfilter(c,tp)

	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD)
		and s.HighEvo(c) and c:GetReasonPlayer()==1-tp
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end

function s.tgfilter_normal(c,e,tp)
	return c:IsFaceup() and c:IsCanBeEffectTarget(e)
end

function s.tgfilter_ignore(c)
	return c:IsFaceup()
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local trap_ct=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_TRAP)
	local ignore=(trap_ct>=8)
	
	if chkc then
		if ignore then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
		return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and s.tgfilter_normal(chkc,e,tp)
	end
	if chk==0 then
		if ignore then return Duel.IsExistingMatchingCard(s.tgfilter_ignore,tp,0,LOCATION_MZONE,1,nil) end
		return Duel.IsExistingTarget(s.tgfilter_normal,tp,0,LOCATION_MZONE,1,nil,e,tp)
	end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=nil
	if ignore then
		g=Duel.SelectMatchingCard(tp,s.tgfilter_ignore,tp,0,LOCATION_MZONE,1,1,nil)
		Duel.SetTargetCard(g)
	else
		g=Duel.SelectTarget(tp,s.tgfilter_normal,tp,0,LOCATION_MZONE,1,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	local trap_ct=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_TRAP)
	local ignore=(trap_ct>=8)
	local success=false 
	
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local pre_atk=tc:GetAttack()
		
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-5000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)

		if ignore then
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		end
		tc:RegisterEffect(e1)
		
		local cur_atk=tc:GetAttack()

		if pre_atk>0 and cur_atk==0 then
			success=true
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RESOLVECARD)
			local op=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3)) 
			if op==0 then
				Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			else
				Duel.Destroy(tc,REASON_EFFECT)
			end
		elseif cur_atk<pre_atk then
			success=true
		end
	end
	
	if success and c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		if Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
			Duel.BreakEffect()
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
