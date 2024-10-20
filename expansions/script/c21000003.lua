--骗术迷局
local s,id,o=GetID()
function s.initial_effect(c)
	
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.con)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.prop)
	c:RegisterEffect(e1)
	if not s.gf then
		s.gf=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge1:SetCode(EVENT_DRAW)
		ge1:SetOperation(s.regop)
		Duel.RegisterEffect(ge1,0)
	end
end

function s.regop(e,tp,eg,ep,ev,re,r,rp)
	if r==REASON_EFFECT then
		Duel.RegisterFlagEffect(ep,id,RESET_PHASE+PHASE_END,0,1)
	end
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)==0
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if e:GetLabel()~=100 then return false end
	e:SetLabel(0)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 and Duel.IsPlayerCanDraw(tp,2) and Duel.IsPlayerCanDraw(1-tp,2) and Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND,0,2,e:GetHandler(),e,tp) and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_HAND,2,e:GetHandler(),e,tp) end
end
function s.prop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerCanDraw(tp,2) and Duel.IsPlayerCanDraw(1-tp,2) and Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND,0,2,e:GetHandler(),e,tp) and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_HAND,2,e:GetHandler(),e,tp) then
		local tc = Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND,0,1,1,e:GetHandler()):GetFirst()
		
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
		local checktype01 = Duel.AnnounceType(tp)
		
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CARDTYPE)
		local checktype02 = Duel.AnnounceType(1-tp)
		
		if (checktype01==0 and tc:IsType(TYPE_MONSTER)) or (checktype01==1 and tc:IsType(TYPE_SPELL)) or (checktype01==2 and tc:IsType(TYPE_TRAP)) then
			Duel.Recover(tp,2000,REASON_EFFECT)
			Duel.Draw(tp,2,REASON_EFFECT)
		else
			Duel.SetLP(tp,Duel.GetLP(tp)-1000)
			local g21=Duel.GetFieldGroup(tp,LOCATION_HAND,0):RandomSelect(tp,2)
			Duel.SendtoDeck(g21,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
		end
		if (checktype02==0 and tc:IsType(TYPE_MONSTER)) or (checktype02==1 and tc:IsType(TYPE_SPELL)) or (checktype02==2 and tc:IsType(TYPE_TRAP)) then
			Duel.Recover(1-tp,2000,REASON_EFFECT)
			Duel.Draw(1-tp,2,REASON_EFFECT)
		else
			Duel.SetLP(1-tp,Duel.GetLP(1-tp)-1000)
			local g2=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(1-tp,2)
			Duel.SendtoDeck(g2,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
		end
	end
	
	if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_DRAW)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end