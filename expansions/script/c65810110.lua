--盛夏回忆·飞蝗
function c65810110.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DETACH_EVENT)
	--xyz summon
	aux.AddXyzProcedure(c,nil,2,3,c65810110.ovfilter,aux.Stringid(65810110,0),99,c65810110.xyzop)
	c:EnableReviveLimit()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,65810110)
	e1:SetCondition(c65810110.thcon)
	e1:SetCost(c65810110.thcost)
	e1:SetTarget(c65810110.thtg)
	e1:SetOperation(c65810110.thop)
	e1:SetLabel(2)
	c:RegisterEffect(e1)
	--战破抗性
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end


function c65810110.ovfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_INSECT) and c:IsType(TYPE_XYZ)
end
function c65810110.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,65810110)==0 end
	Duel.RegisterFlagEffect(tp,65810110,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end


function c65810110.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c65810110.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,ct,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,ct,ct,REASON_COST)
end
function c65810110.thfilter(c,ct)
	if not c:IsAbleToHand() then return false end
	if ct==2 then return c:IsSetCard(0xa31) end
end
function c65810110.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65810110.thfilter,tp,LOCATION_DECK,0,1,nil,e:GetLabel()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c65810110.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c65810110.thfilter,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c65810110.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c65810110.splimit(e,c)
	return not c:IsRace(RACE_INSECT)
end