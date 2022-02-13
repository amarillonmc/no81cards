--键★断片 - 「决意」的舞 / Frammenti K.E.Y - Mai della Determinazione
--Scripted by: XGlitchy30
local s,id=GetID()

function s.initial_effect(c)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.con)
	e1:SetCost(s.cost)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--start countdown
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetLabel(0)
	e4:SetCost(s.regcost)
	e4:SetOperation(s.regop)
	c:RegisterEffect(e4)
end
s.water_aqua_key_monsters = true

function s.con(e,tp,eg)
	return eg:IsContains(e:GetHandler())
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(id)==0 end
	c:RegisterFlagEffect(id,RESET_CHAIN,0,1)
end
function s.tdfilter(c,inc)
	return not c:IsPublic() and (not inc or type(c.water_aqua_key_monsters)=="boolean" and c.water_aqua_key_monsters==true)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_HAND,0,1,nil,true) and Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,PLAYER_ALL,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,PLAYER_ALL,LOCATION_ONFIELD)
end
function s.incfilter(c)
	return type(c.water_aqua_key_monsters)=="boolean" and c.water_aqua_key_monsters==true
end
function s.spcheck(g)
	return g:IsExists(s.incfilter,1,nil)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local ct=math.min(2,Duel.GetMatchingGroupCount(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil))
	if ct==0 then return end
	local g=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_HAND,0,nil)
	if #g<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=g:SelectSubGroup(tp,s.spcheck,false,1,ct)
	if #sg>0 then
		Duel.ConfirmCards(1-tp,sg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
		local dg=Duel.SelectMatchingCard(tp,aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,#sg,#sg,nil)
		for tc in aux.Next(dg) do
			if not tc:IsDisabled() then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				Duel.AdjustInstantly()
				Duel.NegateRelatedChain(tc,RESET_TURN_SET)
				if tc:IsDisabled() then
					Duel.Destroy(tc,REASON_EFFECT)
				end
			end
		end
	end
end

function s.rvfilter(c)
	return c:IsSetCard(0x460) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_AQUA) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function s.regcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return true end
	if Duel.IsExistingMatchingCard(s.rvfilter,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=Duel.SelectMatchingCard(tp,s.rvfilter,tp,LOCATION_HAND,0,1,6,nil)
		if #g>0 then
			Duel.ConfirmCards(1-tp,g)
			e:SetLabel(math.min(#g,6))
		end
	else
		e:SetLabel(0)
	end
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if e:GetLabel()>6 then
		e:SetLabel(6)
	end
	local rct=(Duel.GetCurrentPhase()<=PHASE_STANDBY) and 8-e:GetLabel() or 7-e:GetLabel()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetLabel(Duel.GetTurnCount()+7-e:GetLabel())
	e1:SetCondition(s.thcon)
	e1:SetOperation(s.thop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,rct)
	Duel.RegisterEffect(e1,tp)
end

function s.freezone(c,p,tp)
	return Duel.GetMZoneCount(p,c,tp)>0
end
function s.freezone_check(c,tp,g)
	return Duel.GetMZoneCount(tp,c,tp)>0 and g:IsExists(s.freezone,1,c,1-tp,tp) 
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)
	return Duel.GetTurnCount()==e:GetLabel() and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and (ft1>0 or Duel.IsExistingMatchingCard(s.freezone,tp,LOCATION_MZONE,0,1,nil,tp,tp)) and (ft2>0 or Duel.IsExistingMatchingCard(s.freezone,tp,0,LOCATION_MZONE,1,nil,1-tp,tp))
		and Duel.IsPlayerCanSpecialSummonMonster(tp,33700032,0x6440,TYPES_TOKEN_MONSTER,-2,-2,1,RACE_FIEND,ATTRIBUTE_DARK,POS_FACEUP,tp)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,33700032,0x6440,TYPES_TOKEN_MONSTER,-2,-2,1,RACE_FIEND,ATTRIBUTE_DARK,POS_FACEUP,1-tp)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
end
function s.dcheck(g,tp)
	return g:IsExists(s.freezone_check,1,nil,tp,g) 
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if #g<=0 or not Duel.SelectYesNo(tp,aux.Stringid(id,3)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg=g:SelectSubGroup(tp,s.dcheck,false,1,#g,tp)
	if #sg>0 then
		Duel.HintSelection(sg)
		if Duel.Destroy(sg,REASON_EFFECT)>0 then
			local ct1=Duel.GetOperatedGroup():FilterCount(aux.FilterEqualFunction(Card.GetPreviousControler,tp),nil)
			local ct2=Duel.GetOperatedGroup():FilterCount(aux.FilterEqualFunction(Card.GetPreviousControler,1-tp),nil)
			local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
			local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)
			if ft1>0 and ft2>0 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
				and Duel.IsPlayerCanSpecialSummonMonster(tp,33700032,0x6440,TYPES_TOKEN_MONSTER,-2,-2,1,RACE_FIEND,ATTRIBUTE_DARK,POS_FACEUP,tp)
				and Duel.IsPlayerCanSpecialSummonMonster(tp,33700032,0x6440,TYPES_TOKEN_MONSTER,-2,-2,1,RACE_FIEND,ATTRIBUTE_DARK,POS_FACEUP,1-tp) then
				local token=Duel.CreateToken(tp,33700032)
				Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_SET_ATTACK)
				e1:SetValue(ct1*1000)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				token:RegisterEffect(e1)
				local token=Duel.CreateToken(tp,33700032)
				Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_SET_ATTACK)
				e1:SetValue(ct2*1000)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				token:RegisterEffect(e1)
				Duel.SpecialSummonComplete()
			end
		end
	end
end