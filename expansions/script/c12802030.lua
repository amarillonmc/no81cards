--梦中之吉丁虫
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(s.poscon1)
	e1:SetCost(s.poscost1)
	e1:SetOperation(s.posop1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(s.tgtg)
	e2:SetOperation(s.tgop)
	c:RegisterEffect(e2)
end
function s.poscon1(e,tp,eg,ep,ev,re,r,rp)
	if eg:GetCount()>1 then return false end
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	return tc:IsControler(1-tp) and tc:IsPosition(POS_FACEUP) and c:IsCanChangePosition()
end
function s.poscost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return c:IsAttackPos() end
	Duel.ChangePosition(e:GetHandler(),POS_FACEUP_DEFENSE)
end
function s.posop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.HintSelection(eg)
	local tc=eg:GetFirst()
	if tc then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
end
function s.tgfilter(c)
	return c:IsFaceup() and not c:IsRace(RACE_INSECT)
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
	and (Duel.GetFlagEffect(tp,id)==0 or not e:IsCostChecked())
	local b2=Duel.IsExistingMatchingCard(s.tgfilter,tp,0,LOCATION_MZONE,1,nil) 
	and (Duel.GetFlagEffect(tp,id+o)==0 or not e:IsCostChecked())
	if chk==0 then return b1 or b2 end
	if b1 and not b2 then
		Duel.Hint(HINT_OPSELECTED,1-tp,1118)
		op=1
	end
	if b2 and not b1 then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,2))
		op=2
	end
	if b1 and b2 then
		op=aux.SelectFromOptions(tp,{b1,1118},{b2,aux.Stringid(id,2)})
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
			Duel.RegisterFlagEffect(tp,id+o,RESET_PHASE+PHASE_END,0,1)
		end
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
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,0,LOCATION_MZONE,1,1,nil)
		Duel.HintSelection(g)
		local tc=g:GetFirst()
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_RACE)
		e2:SetValue(RACE_INSECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		tc:RegisterFlagEffect(id+o*2,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,3))
	end
end