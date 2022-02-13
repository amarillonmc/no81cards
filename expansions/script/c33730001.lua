--键★等 －奇迹的星象馆 / K.E.Y Etc. Planetario dei Miracoli
--Scripted by: XGlitchy30
local s,id=GetID()

function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,4))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PREDRAW)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(s.destg)
	e3:SetValue(s.value)
	e3:SetOperation(s.desop)
	c:RegisterEffect(e3)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function s.filter(c)
	return c:IsSetCard(0x460) and c:IsAbleToHand()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local cg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_DECK,0,nil)
	if cg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=cg:Select(tp,1,3,nil)
		if #sg>0 and Duel.SendtoHand(sg,nil,REASON_EFFECT)>0 and sg:Filter(Card.IsLocation,nil,LOCATION_HAND):IsExists(Card.IsControler,1,nil,tp) then
			local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_HAND):Filter(Card.IsControler,nil,tp)
			Duel.ConfirmCards(1-tp,og)
			if not Duel.SelectYesNo(1-tp,aux.Stringid(id,3)) then return end
			local dg=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,LOCATION_DECK,nil,1-tp)
			local opt
			if #dg>=#og then
				opt=Duel.SelectOption(1-tp,aux.Stringid(id,1),aux.Stringid(id,2))
			else
				opt=Duel.SelectOption(1-tp,aux.Stringid(id,2))+1
			end
			if not opt then return end
			if opt==0 then
				Duel.ConfirmCards(tp,Duel.GetFieldGroup(tp,0,LOCATION_DECK))
				local tg=dg:Select(tp,#og,#og,nil)
				if #tg>0 then
					Duel.SendtoHand(tg,1-tp,REASON_EFFECT)
				end
			else
				Duel.SetLP(1-tp,Duel.GetLP(1-tp)*#og)
			end
		end
	end
end

function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
		and Duel.GetDrawCount(tp)>0
end
function s.thfilter(c)
	return c:IsSetCard(0x460) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
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
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	aux.DrawReplaceCount=aux.DrawReplaceCount+1
	if aux.DrawReplaceCount>aux.DrawReplaceMax or not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function s.dfilter(c)
	return c:IsFaceup() and c:IsOnField() and c:IsSetCard(0x460) and not c:IsReason(REASON_REPLACE+REASON_RULE)
end
function s.repfilter(c)
	return c:IsSetCard(0x460) and not c:IsPublic()
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(s.dfilter,1,nil)
		and Duel.IsExistingMatchingCard(s.repfilter,tp,LOCATION_HAND,0,1,nil) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function s.value(e,c)
	return c:IsFaceup() and c:IsOnField() and c:IsSetCard(0x460)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.repfilter,tp,LOCATION_HAND,0,1,1,nil)
	if #g>0 then
		Duel.ConfirmCards(1-tp,g)
	end
end