--键★断片 - 「羁绊」的真琴 / Frammenti K.E.Y - Makoto dei Legami
--Scripted by: XGlitchy30
local s,id=GetID()

function s.initial_effect(c)
	--excavate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
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
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
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
	return c:IsAbleToDeck() and (not inc or type(c.water_aqua_key_monsters)=="boolean" and c.water_aqua_key_monsters==true)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ct=0
		for i=1,2 do
			if Duel.IsPlayerCanDraw(tp,i) then
				ct=i
				break
			end
		end
		return ct>0 and Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_HAND,0,ct,nil,true)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.hcheck(c,loc,p)
	return c:IsLocation(loc) and (not p or c:IsControler(p))
end
function s.incfilter(c)
	return type(c.water_aqua_key_monsters)=="boolean" and c.water_aqua_key_monsters==true
end
function s.spcheck(g)
	return g:IsExists(s.incfilter,1,nil)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDraw(tp) then return end
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if ct==0 then ct=1 end
	if ct>2 then ct=2 end
	local g=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_HAND,0,nil)
	if #g<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:SelectSubGroup(tp,s.spcheck,false,1,ct)
	if #sg>0 then
		Duel.ConfirmCards(1-tp,sg)
		if Duel.SendtoDeck(sg,nil,SEQ_DECKTOP,REASON_EFFECT)>0 and sg:IsExists(s.hcheck,#sg,nil,LOCATION_DECK+LOCATION_EXTRA) then
			local dg=sg:Filter(s.hcheck,nil,LOCATION_DECK,tp)
			Duel.SortDecktop(tp,tp,#dg)
			for i=1,#dg do
				local mg=Duel.GetDecktopGroup(tp,1)
				Duel.MoveSequence(mg:GetFirst(),1)
			end
			Duel.Draw(tp,#sg,REASON_EFFECT)
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
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1)
	e1:SetLabel(Duel.GetTurnCount()+7-e:GetLabel())
	e1:SetCondition(s.thcon)
	e1:SetOperation(s.thop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,rct)
	e:GetHandler():RegisterEffect(e1)
end

function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()==e:GetLabel() and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,33730032,0,TYPES_TOKEN_MONSTER,3000,1500,8,RACE_AQUA,ATTRIBUTE_WATER)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or Duel.IsPlayerAffectedByEffect(tp,59822133) or not Duel.SelectYesNo(tp,aux.Stringid(id,3)) then return end
	local c=e:GetHandler()
	if Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,33730032,0,TYPES_TOKEN_MONSTER,3000,1500,8,RACE_AQUA,ATTRIBUTE_WATER) then
			local token=Duel.CreateToken(tp,33730032)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	Duel.SpecialSummonComplete()
end