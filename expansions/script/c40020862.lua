--皇兽的雷火山
local s,id=GetID()
s.named_with_EmperorBeast=1

function s.EmperorBeast(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_EmperorBeast
end

function s.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_TO_HAND)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(s.indtg)
	e2:SetValue(s.indval)
	c:RegisterEffect(e2)
	local e2a=e2:Clone()
	e2a:SetCode(EFFECT_CANNOT_TO_DECK)
	c:RegisterEffect(e2a)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,id+1)
	e3:SetCondition(s.descon)
	e3:SetTarget(s.destg)
	e3:SetOperation(s.desop)
	c:RegisterEffect(e3)
	
	if not s.global_check then
		s.global_check=true
		s.turn_count={}
		s.turn_count[0]=0
		s.turn_count[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TURN_END)
		ge1:SetOperation(s.turnop)
		Duel.RegisterEffect(ge1,0)
	end
end

function s.turnop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetTurnPlayer()
	s.turn_count[p]=s.turn_count[p]+1
end

function s.is_second_player_first_turn(tp)
	if Duel.GetTurnPlayer()~=tp then return false end
	if Duel.GetTurnCount()==1 then return false end
	return s.turn_count[tp]==0
end

function s.thfilter(c)
	return s.EmperorBeast(c) and c:IsType(TYPE_RITUAL) and c:IsAbleToHand()
end

function s.fselect(g)
	return #g==3 and g:GetClassCount(Card.GetLevel)==3
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
		return g:CheckSubGroup(s.fselect,3,3)
	end
	local ct = s.is_second_player_first_turn(tp) and 3 or 1
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,ct,tp,LOCATION_DECK)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	if not g:CheckSubGroup(s.fselect,3,3) then return end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=g:SelectSubGroup(tp,s.fselect,false,3,3)
	if sg and #sg==3 then
		Duel.ConfirmCards(1-tp,sg)
		if s.is_second_player_first_turn(tp) then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		else
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
			local tg=sg:Select(1-tp,1,1,nil)
			if #tg>0 then
				Duel.SendtoHand(tg,tp,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tg)
			end
			Duel.ShuffleDeck(tp)
		end
	end
end

function s.indtg(e,c)
	return s.EmperorBeast(c) and not c:IsLocation(LOCATION_EXTRA)
end

function s.indval(e,re,rp)
	return rp==1-e:GetHandlerPlayer()
end

function s.ritfilter(c,tp)
	return c:IsSummonType(SUMMON_TYPE_RITUAL) and s.EmperorBeast(c) and c:IsControler(tp)
end

function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.ritfilter,1,nil,tp)
end

function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end

function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
