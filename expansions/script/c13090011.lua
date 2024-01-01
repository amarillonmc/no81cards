--少时侠胆
local m=13090011
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,m+m)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.activate)
	c:RegisterEffect(e3)
c13090011.star_knight_spsummon_effect=e3
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
	--c:RegisterEffect(e0)
	--set rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1,23090011)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.setcon)
	e1:SetOperation(cm.setop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SUMMON+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.discon)
	e2:SetCost(cm.discost)
	e2:SetTarget(cm.distg)
	e2:SetOperation(cm.disop)
	c:RegisterEffect(e2)
end
--
function cm.setfilter(c,tp)
	return (c:IsLocation(LOCATION_ONFIELD) or not c:IsForbidden()) 
		and (c:IsType(TYPE_MONSTER) or c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS)
		and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
		and c:CheckUniqueOnField(tp)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		
		return Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil,tp) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	end
end
function cm.f2(c)
return c:IsType(TYPE_MONSTER) end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 or Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g1=Duel.GetDecktopGroup(tp,1)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CONFIRM)
	local g2=Duel.GetDecktopGroup(1-tp,1)
	local atpsl=g1:GetFirst()
	local ntpsl=g2:GetFirst()
	Duel.ConfirmCards(1-tp,atpsl)
	Duel.ConfirmCards(tp,atpsl)
	Duel.ConfirmCards(tp,ntpsl)
	Duel.ConfirmCards(1-tp,ntpsl)
	local atplv=atpsl:IsType(TYPE_MONSTER) and atpsl:GetAttack() or 0
	local ntplv=ntpsl:IsType(TYPE_MONSTER) and ntpsl:GetAttack() or 0
	if atplv<=ntplv then
		local g=Duel.GetMatchingGroup(cm.setfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,nil,tp)
		if #g<1 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		local tc=sg:GetFirst()
		if not tc:IsImmuneToEffect(e) and Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
			if tc:IsType(TYPE_MONSTER) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetCode(EFFECT_CHANGE_TYPE)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
				e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
				tc:RegisterEffect(e1)
			end
		end
	end
	Duel.ShuffleHand(tp)
	Duel.ShuffleHand(1-tp)
end
--set rule
function cm.costfilter(c)
	return c:IsReleasable()
end
function cm.cfilter1(c,g)
	return c:IsSetCard(0xe08) and g:IsExists(Card.IsType,1,c,TYPE_SPELL)
end
function cm.fselect(g)
	return g:IsExists(cm.cfilter1,1,nil,g) and g:IsExists(Card.IsType,1,nil,TYPE_SPELL)
end
function cm.setcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(cm.costfilter,tp,LOCATION_ONFIELD,0,nil)
	return g:CheckSubGroup(cm.fselect,2,2) and c:IsFacedown() and c:IsLocation(LOCATION_EXTRA) and Duel.GetTurnPlayer()==tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.costfilter,tp,LOCATION_ONFIELD,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
	local sg=g:SelectSubGroup(tp,cm.fselect,true,2,2)
	Duel.Release(sg,REASON_RULE)
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
  end
end
--
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and e:GetHandler():IsFaceup()
end
function cm.sumfilter(c)
	return c:IsSummonable(true,nil)
end
function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsOnField() end
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,0,1,nil,tp)
	end
	--cost
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,0,1,1,nil)
	e:SetLabel(0)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsType(TYPE_SPELL) or tc:IsType(TYPE_TRAP) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		
		local e1=Effect.CreateEffect(e:GetHandler())
		--e1:SetDescription(aux.Stringid(m,1))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SKIP_BP)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		Duel.RegisterEffect(e1,tp)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_PHASE+PHASE_DRAW)
		e3:SetCountLimit(1)
		e3:SetLabel(Duel.GetTurnCount())
		e3:SetCondition(cm.stcon)
		e3:SetOperation(cm.stop)
		if Duel.GetCurrentPhase()<=PHASE_DRAW then
			e3:SetReset(RESET_PHASE+PHASE_DRAW,2)
		else
			e3:SetReset(RESET_PHASE+PHASE_DRAW)
		end
		Duel.RegisterEffect(e3,tp)
	else
		Duel.Release(tc,REASON_EFFECT)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e3:SetCountLimit(1)
		e3:SetLabel(Duel.GetTurnCount())
		e3:SetCondition(cm.stcon)
		e3:SetOperation(cm.stop2)
		if Duel.GetCurrentPhase()<=PHASE_STANDBY then
			e3:SetReset(RESET_PHASE+PHASE_STANDBY,2)
		else
			e3:SetReset(RESET_PHASE+PHASE_STANDBY)
		end
		Duel.RegisterEffect(e3,tp)
		local e1=Effect.CreateEffect(e:GetHandler())
		--e1:SetDescription(aux.Stringid(m,2))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetTargetRange(1,0)
		e1:SetTarget(cm.splimit)
		--e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)   
	end
end
function cm.stcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function cm.stop(e,tp,eg,ep,ev,re,r,rp)
if Duel.IsPlayerCanDraw(tp,1) then
Duel.Draw(tp,1,REASON_EFFECT)
end
end
function cm.stop2(e,tp,eg,ep,ev,re,r,rp)
local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
Duel.SendtoHand(tc,nil,REASON_EFFECT)
end
function cm.splimit(e,c)
	return c:IsLocation(LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end












