local m=11638011
local cm=_G["c"..m]
cm.name="末法之世·新琦玉"
function cm.initial_effect(c)
	aux.AddCodeList(c,11638001)
	--to deck
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--ninja all
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_ADD_SETCODE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetTargetRange(0,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_EXTRA)
	e3:SetTarget(cm.njfilter)
	e3:SetValue(0x2b)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	--e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCode(EVENT_CUSTOM+11638011)
	e4:SetCondition(cm.atkcon)
	--e4:SetTarget(cm.atktg)
	e4:SetOperation(cm.atkop)
	c:RegisterEffect(e4)
	if not cm.global_check then
		cm.global_check=true
		cm[0]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
		ge1:SetCondition(cm.regcon)
		ge1:SetOperation(cm.regop)
		Duel.RegisterEffect(ge1,0)
		_NinJaCalculateDamage=Duel.CalculateDamage
		function Duel.CalculateDamage(c1,c2,bool)
			if not bool then bool=false end
			_NinJaCalculateDamage(c1,c2,bool)
			Duel.RaiseEvent(Group.FromCards(c1,c2),EVENT_CUSTOM+11638011,nil,0,0,0,0)
		end
	end
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	local a,b=Duel.GetBattleMonster(tp)
	return ((a and a:IsCode(11638001)) or (b and b:IsCode(11638001)))
	--return cm[0]==1
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local a,b=Duel.GetBattleMonster(tp)
	Duel.RaiseEvent(Group.FromCards(a,b),EVENT_CUSTOM+11638011,e,0,0,0,0)
end
function cm.njfilter(e,c)
	return c:IsFaceup() or c:IsLocation(LOCATION_EXTRA)
end
function cm.thfilter(c)
	return aux.IsCodeListed(c,11638001) and c:IsAbleToHand()
end
function cm.spfilter(c,e,tp)
	return c:IsCode(11638001) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local b1=(Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp))
	local b2=(Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil))
	if not ((b1 or b2) and Duel.SelectYesNo(tp,aux.Stringid(m,2))) then return end
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(m,0))
	else op=Duel.SelectOption(tp,aux.Stringid(m,1))+1 end
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsCode,1,nil,11638001)
end
function cm.th2filter(c)
	return aux.IsCodeListed(c,11638001) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.th2filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetTargetCard(Duel.GetAttacker())
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,1-tp,11638011)
	local a,b=Duel.GetBattleMonster(tp)
	if a and a:IsCode(11638001) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(300)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		a:RegisterEffect(e1)
	end
	if b and b:IsCode(11638001) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(300)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		b:RegisterEffect(e1)
	end
	if Duel.GetFlagEffect(tp,11638011)<2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.th2filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
			Duel.RegisterFlagEffect(tp,11638011,RESET_PHASE+PHASE_END,0,1)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end