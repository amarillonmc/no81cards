--皓月之祀
function c98921067.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,98921067+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c98921067.spcost)
	e1:SetOperation(c98921067.activate)
	c:RegisterEffect(e1)	
	Duel.AddCustomActivityCounter(98921067,ACTIVITY_SPSUMMON,c98921067.counterfilter)
	--direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c98921067.datg)
	c:RegisterEffect(e2)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_DISEFFECT)
	e5:SetRange(LOCATION_FZONE)
	e5:SetValue(c98921067.effectfilter)
	c:RegisterEffect(e5)
end
function c98921067.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(98921067,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c98921067.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c98921067.counterfilter(c)
	return c:IsType(TYPE_XYZ)
end
function c98921067.thfilter1(c)
	return c:IsLevel(3) and c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c98921067.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsType(TYPE_XYZ)
end
function c98921067.thfilter2(c)
	return c:IsCode(98921068) or c:IsCode(14005031) and c:IsAbleToHand()
end
function c98921067.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(c98921067.thfilter1,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(c98921067.thfilter2,tp,LOCATION_DECK,0,nil)
	if g1:GetCount()>0 and g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(98921067,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg2=g2:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		Duel.SendtoHand(sg1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg1)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98921067,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1,98921067)
	e1:SetCondition(c98921067.descon)
	e1:SetOperation(c98921067.matop)
	e1:SetLabel(Duel.GetTurnCount())
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
	c:RegisterEffect(e1)
end
function c98921067.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()==e:GetLabel()+1
end
function c98921067.datg(e,c)
	return c:IsType(TYPE_XYZ) and c:GetOverlayCount()==0
end
function c98921067.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	return p==tp and te:GetHandler():GetOverlayCount()==0 and te:GetHandler():IsType(TYPE_XYZ) and bit.band(loc,LOCATION_ONFIELD)~=0
end
function c98921067.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(c98921067.tgfilter,tp,LOCATION_MZONE,0,1,nil) and c:IsCanOverlay() and Duel.SelectYesNo(tp,aux.Stringid(98921067,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local tg=Duel.SelectMatchingCard(tp,c98921067.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.HintSelection(tg)
		local tc=tg:GetFirst()
		Duel.Overlay(tc,Group.FromCards(c))
	else 
		Duel.Destroy(c,REASON_EFFECT)
	end
end
function c98921067.tgfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end