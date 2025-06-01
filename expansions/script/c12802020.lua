--梦中之钩蛱蝶
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(s.tgtg)
	e2:SetOperation(s.tgop)
	c:RegisterEffect(e2)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAttackPos() end
	Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
end
function s.filter(c)
	return c:IsFaceup() and c:IsLevelAbove(1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,0,LOCATION_MZONE,1,nil) end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local sg=Duel.SelectMatchingCard(tp,s.filter,tp,0,LOCATION_MZONE,1,1,nil)
	if #sg>0 then
		Duel.HintSelection(sg)
		local tc=sg:GetFirst()
		local ct={1,2,3}
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,5))
		local ac=Duel.AnnounceNumber(tp,table.unpack(ct))
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(ac)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(id+o*2,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,3))
		if tc:IsFaceup() and not tc:IsRace(RACE_INSECT) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.BreakEffect()
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CHANGE_RACE)
			e2:SetValue(RACE_INSECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
		end
	end
end
function s.tgfilter(c)
	return c:IsSetCard(0x6a7d) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
	and (Duel.GetFlagEffect(tp,id)==0 or not e:IsCostChecked())
	local b2=Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil) 
	and (Duel.GetFlagEffect(tp,id+o)==0 or not e:IsCostChecked())
	if chk==0 then return b1 or b2 end
	if b1 and not b2 then
		Duel.Hint(HINT_OPSELECTED,1-tp,1118)
		op=1
	end
	if b2 and not b1 then
		Duel.Hint(HINT_OPSELECTED,1-tp,1190)
		op=2
	end
	if b1 and b2 then
		op=aux.SelectFromOptions(tp,{b1,1118},{b2,1190})
	end
	e:SetLabel(op)
	if op==1 then
		if e:IsCostChecked() then
			Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
			e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	elseif op==2 then
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
			Duel.RegisterFlagEffect(tp,id+o,RESET_PHASE+PHASE_END,0,1)
		end
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=e:GetLabel()
	if op==1 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsRelateToEffect(e) then
			if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
				e1:SetValue(LOCATION_REMOVED)
				c:RegisterEffect(e1,true)
			end
		end
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end