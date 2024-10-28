--幻想山河 银瑛骑士
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddXyzProcedure(c,nil,3,2,nil,nil,99)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_XYZ_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(s.lvtg)
	e1:SetValue(s.lvval)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.econ)
	e2:SetValue(s.efilter)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e3:SetCost(s.rmcost)
	e3:SetTarget(s.rmtg)
	e3:SetOperation(s.rmop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTarget(s.thtg)
	e4:SetOperation(s.thop)
	c:RegisterEffect(e4)
end
s.fantasy_mountains_and_rivers=true
function s.lvtg(e,c)
	return c:IsLevelAbove(1) and c:IsType(TYPE_TUNER)
end
function s.lvval(e,c,rc)
	local lv=c:GetLevel()
	if rc==e:GetHandler() then return 3
	else return lv end
end
function s.econ(e)
	return e:GetHandler():GetOverlayCount()>2
end
function s.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function s.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_HAND,nil)>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_ONFIELD+LOCATION_HAND)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local hg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
	local fg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	local g
	if #hg>0 and (#fg==0 or Duel.SelectOption(tp,aux.Stringid(id,3),aux.Stringid(id,4))==0) then
		g=hg:RandomSelect(tp,1)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
	end
	if g:GetCount()~=0 then
		Duel.HintSelection(g)
		local tc=g:GetFirst()
		if tc and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_REMOVED) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
			e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
			e1:SetLabel(Duel.GetTurnCount())
			e1:SetLabelObject(tc)
			e1:SetCountLimit(1)
			e1:SetOperation(s.retop)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetLabelObject()
	if Duel.GetTurnCount()~=e:GetLabel() and ec:IsLocation(LOCATION_REMOVED) then
		Duel.Hint(HINT_CARD,0,id)
		if ec:IsType(TYPE_MONSTER) and ec:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,ec:GetOwner()) then
			Duel.SpecialSummon(ec,0,tp,ec:GetOwner(),false,false,POS_FACEUP)
		elseif ec:IsType(TYPE_SPELL+TYPE_TRAP) and ec:IsSSetable() then
			Duel.SSet(ec:GetOwner(),ec)
		end
	end
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_OVERLAY)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local g=c:GetOverlayGroup()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=g:FilterSelect(tp,Card.IsAbleToHand,1,1,nil)
		if tg:GetCount()>0 then
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
		end
	end
end