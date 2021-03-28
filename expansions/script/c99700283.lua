--龙界魂 净之白龙
function c99700283.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c99700283.amcost)
	e1:SetTarget(c99700283.target)
	e1:SetOperation(c99700283.activate)
	c:RegisterEffect(e1)
	--lv change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99700283,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,99700283)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c99700283.amcost)
	e2:SetTarget(c99700283.lvtg)
	e2:SetOperation(c99700283.lvop)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99700283,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,99700284)
	e3:SetCost(c99700283.amcost)
	e3:SetTarget(c99700283.thtg)
	e3:SetOperation(c99700283.thop)
	c:RegisterEffect(e3)
end
function c99700283.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and
		Duel.IsPlayerCanSpecialSummonMonster(tp,99700283,0xfd04,0x21,2400,2400,8,RACE_DRAGON,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c99700283.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,99700283,0xfd04,0x21,2400,2400,8,RACE_DRAGON,ATTRIBUTE_LIGHT) then return end
	c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TUNER)
	Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP)
end
function c99700283.amcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(99700283,tp,ACTIVITY_CHAIN+ACTIVITY_SUMMON+ACTIVITY_SPSUMMON+ACTIVITY_FLIPSUMMON+ACTIVITY_NORMALSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c99700283.splimit)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	Duel.RegisterEffect(e4,tp)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetTargetRange(1,0)
	e3:SetValue(c99700283.aclimit)
	Duel.RegisterEffect(e3,tp)
end
function c99700283.splimit(e,c)
	return not (c:IsSetCard(0xfd00) or c:IsSetCard(0xfd01) or c:IsSetCard(0xfd02) or c:IsSetCard(0xfd03) or c:IsSetCard(0xfd04))
end
function c99700283.aclimit(e,re,tp)
	return not (re:GetHandler():IsSetCard(0xfd00) or re:GetHandler():IsSetCard(0xfd01) or re:GetHandler():IsSetCard(0xfd02) or re:GetHandler():IsSetCard(0xfd03) or re:GetHandler():IsSetCard(0xfd04))
end
function c99700283.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local lv=e:GetHandler():GetLevel()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99700283,1))
	e:SetLabel(Duel.AnnounceLevel(tp,4,8,lv))
end
function c99700283.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c99700283.thfilter(c)
	return c:IsType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0xfd04) and c:IsAbleToHand()
end
function c99700283.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99700283.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99700283.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c99700283.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end