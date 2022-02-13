--键★断片 - 「追忆」的名雪 / Frammenti K.E.Y - Nayuki delle Memorie
--Scripted by: XGlitchy30
local s,id=GetID()

function s.initial_effect(c)
	--excavate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
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
	e4:SetCategory(CATEGORY_DRAW)
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
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=7 end
end
function s.hcheck(c,loc,p)
	return c:IsLocation(loc) and c:IsControler(p)
end
function s.seqcheck(c,seq)
	return c:GetSequence()==seq
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<7 then return end
	local g=Group.CreateGroup()
	for i=0,6 do
		local tc=Duel.GetMatchingGroup(s.seqcheck,tp,LOCATION_DECK,0,nil,i):GetFirst()
		if tc then
			g:AddCard(tc)
			Duel.RaiseSingleEvent(tc,id,e,REASON_EFFECT+REASON_REVEAL,tp,nil,SEQ_DECKBOTTOM)
		end
	end
	Duel.ConfirmCards(1-tp,g)
	Duel.RaiseEvent(g,EVENT_CUSTOM+33730024,e,REASON_EFFECT+REASON_REVEAL,tp,nil,SEQ_DECKBOTTOM)
	local ct=g:GetCount()
	if ct>0 and g:FilterCount(s.thfilter,nil,e,tp)>0 and Duel.GetFlagEffect(tp,id)<=0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
		local sg=g:FilterSelect(tp,s.thfilter,1,1,nil)
		Duel.DisableShuffleCheck()
		if #sg>0 then
			Duel.BreakEffect()
			if Duel.SendtoHand(sg,nil,REASON_EFFECT)>0 and sg:IsExists(s.hcheck,1,nil,LOCATION_HAND,tp) then
				Duel.ConfirmCards(1-tp,sg)
				Duel.ShuffleHand(tp)
				Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
			end
			local rg=sg:Filter(aux.NOT(s.hcheck),nil,LOCATION_DECK,tp)
			if #rg>0 then
				g:RemoveCard(rg:GetFirst())
			end
		end	
	end
	local dg=g:Filter(s.hcheck,nil,LOCATION_DECK,tp)
	if #dg>0 then
		Duel.BreakEffect()
		for tc in aux.Next(dg) do
			Duel.MoveSequence(tc,0)
		end
		Duel.SortDecktop(tp,tp,#dg)
		for i=1,#dg do
			local mg=Duel.GetDecktopGroup(tp,1)
			Duel.MoveSequence(mg:GetFirst(),1)
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
	return Duel.GetTurnCount()==e:GetLabel() and Duel.IsPlayerCanDraw(tp,2)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.SelectYesNo(tp,aux.Stringid(id,3)) then return end
	Duel.Hint(HINT_CARD,0,id)
	Duel.Draw(tp,2,REASON_EFFECT)
end