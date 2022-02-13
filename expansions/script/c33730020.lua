--键★断片 - 「约定」的亚由 / Frammenti K.E.Y - Ayu della Promessa
--Scripted by: XGlitchy30
local s,id=GetID()

function s.initial_effect(c)
	--place on bottom
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK)
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
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
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
function s.filter(c)
	return c:IsSetCard(0x460) and (c:IsLocation(LOCATION_DECK) or c:IsAbleToDeck())
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		local tc=g:GetFirst()
		if tc:IsLocation(LOCATION_DECK) then
			Duel.DisableShuffleCheck()
			Duel.MoveSequence(tc,1)
		else
			Duel.HintSelection(g)
			Duel.SendtoDeck(g,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
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
	e1:SetReset(RESET_PHASE+PHASE_STANDBY,rct)
	Duel.RegisterEffect(e1,tp)
end

function s.thfilter(c)
	return c:IsSetCard(0x460) and c:IsAbleToHand()
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()==e:GetLabel() and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
end
function s.spcheck(g)
	return #g==1 or not g:IsExists(s.excfilter,1,nil)
end
function s.excfilter(c)
	return not (c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_AQUA) or type(c.water_aqua_key_monsters)=="boolean" and c.water_aqua_key_monsters==true)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.SelectYesNo(tp,aux.Stringid(id,3)) then return end
	Duel.Hint(HINT_CARD,0,id)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	if #g>0 then
		local ft=math.min(3,#g)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local hg=g:SelectSubGroup(tp,s.spcheck,false,1,ft)
		if #hg>0 then
			Duel.SendtoHand(hg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,hg)
		end
	end
end