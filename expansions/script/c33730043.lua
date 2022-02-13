--键★高潮 新生之风 / K.E.Y Climax - Nuovo Vento
--Scripted by: XGlitchy30
local s,id=GetID()

function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--search bottom
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PREDRAW)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(s.condition)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
	--replace draw
	local e2x=Effect.CreateEffect(c)
	e2x:SetDescription(aux.Stringid(id,1))
	e2x:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2x:SetCode(EVENT_PREDRAW)
	e2x:SetRange(LOCATION_FZONE)
	e2x:SetCondition(s.repcon)
	e2x:SetTarget(s.reptg)
	e2x:SetOperation(s.repop)
	c:RegisterEffect(e2x)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(id)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(1,1)
	c:RegisterEffect(e3)
	if not s.global_check then
		s.global_check=true
		--custom draw function
		_Draw = Duel.Draw
		function rvfilter(c)
			return not c:IsPublic() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x460) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_AQUA)
		end
		function Duel.Draw(tp,ct,r)
			if Duel.IsPlayerAffectedByEffect(tp,id) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and Duel.IsExistingMatchingCard(rvfilter,c:GetOwner(),LOCATION_HAND,0,1,nil)
				and Duel.SelectYesNo(c:GetOwner(),aux.Stringid(id,1)) then
				Duel.Hint(HINT_SELECTMSG,c:GetOwner(),HINTMSG_CONFIRM)
				local g=Duel.SelectMatchingCard(c:GetOwner(),rvfilter,c:GetOwner(),LOCATION_HAND,0,1,1,nil)
				if #g>0 then
					Duel.ConfirmCards(1-c:GetOwner(),g)
				end
				local tc=Duel.GetFirstMatchingCard(aux.FilterEqualFunction(Card.GetSequence,0),tp,LOCATION_DECK,0,nil)
				if tc then
					Duel.DisableShuffleCheck()
					tc:SetStatus(STATUS_TO_HAND_WITHOUT_CONFIRM,true)
					Duel.SendtoHand(tc,nil,REASON_EFFECT)
				end
				return 0
			else
				return _Draw(tp,ct,r)
			end
		end
	end
end
s.water_aqua_key_monsters = true

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
		and Duel.GetDrawCount(tp)>0
end
function s.thfilter(c)
	return c:IsSetCard(0x114) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=2 and Duel.IsPlayerCanSendtoHand(tp) end
	local dt=Duel.GetDrawCount(tp)
	if dt~=0 then
		aux.DrawReplaceCount=0
		aux.DrawReplaceMax=dt
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_DRAW)
		e1:SetValue(0)
		Duel.RegisterEffect(e1,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	aux.DrawReplaceCount=aux.DrawReplaceCount+1
	if aux.DrawReplaceCount>aux.DrawReplaceMax or not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<2 then return end
	local g=Duel.GetDecktopGroup(tp,2)
	if #g>0 then
		Duel.ConfirmCards(tp,g)
		local opt=Duel.SelectOption(tp,aux.Stringid(33730024,2),aux.Stringid(33730024,3))
		Duel.SortDecktop(tp,tp,#g)
		if opt~=0 then
			for i=1,#g do
				local mg=Duel.GetDecktopGroup(p,1)
				Duel.MoveSequence(mg:GetFirst(),1)
			end
		end
		local tc=Duel.GetFirstMatchingCard(aux.FilterEqualFunction(Card.GetSequence,0),tp,LOCATION_DECK,0,nil)
		if tc then
			Duel.BreakEffect()
			Duel.DisableShuffleCheck()
			tc:SetStatus(STATUS_TO_HAND_WITHOUT_CONFIRM,true)
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end

function s.rvfilter(c)
	return not c:IsPublic() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x460) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_AQUA)
end
function s.repcon(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetTurnPlayer()
	return Duel.GetFieldGroupCount(p,LOCATION_DECK,0)>0 and Duel.GetDrawCount(p)>0 and Duel.IsExistingMatchingCard(s.rvfilter,tp,LOCATION_HAND,0,1,nil)
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local p=Duel.GetTurnPlayer()
	if chk==0 then return Duel.IsPlayerCanSendtoHand(p) end
	local dt=Duel.GetDrawCount(p)
	if dt~=0 then
		aux.DrawReplaceCount=0
		aux.DrawReplaceMax=dt
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_DRAW)
		e1:SetValue(0)
		Duel.RegisterEffect(e1,p)
	end
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	aux.DrawReplaceCount=aux.DrawReplaceCount+1
	if aux.DrawReplaceCount>aux.DrawReplaceMax then return end
	if Duel.GetFieldGroupCount(p,LOCATION_DECK,0)>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=Duel.SelectMatchingCard(tp,s.rvfilter,tp,LOCATION_HAND,0,1,1,nil)
		if #g>0 then
			Duel.ConfirmCards(1-tp,g)
		end
		local tc=Duel.GetFirstMatchingCard(aux.FilterEqualFunction(Card.GetSequence,0),Duel.GetTurnPlayer(),LOCATION_DECK,0,nil)
		if tc then
			Duel.DisableShuffleCheck()
			tc:SetStatus(STATUS_TO_HAND_WITHOUT_CONFIRM,true)
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end