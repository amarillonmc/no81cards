--N Meta Field
function c9950716.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9950716+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c9950716.activate)
	c:RegisterEffect(e1)
 --atk & def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(300)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3bd3))
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
 --actlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetRange(LOCATION_FZONE)
	e1:SetValue(1)
	e1:SetCondition(c9950716.actcon)
	c:RegisterEffect(e1)
 --draw
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(c9950716.condition)
	e3:SetTarget(c9950716.target)
	c:RegisterEffect(e3)
--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9950716,3))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,99507160)
	e2:SetTarget(c9950716.drtg2)
	e2:SetOperation(c9950716.drop2)
	c:RegisterEffect(e2)
end
function c9950716.thfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x3bd3) and not c:IsCode(9950716) and c:IsAbleToHand()
end
function c9950716.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c9950716.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9950716,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c9950716.actfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3bd3)
end
function c9950716.actcon(e)
	local ph=Duel.GetCurrentPhase()
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c9950716.actfilter,tp,LOCATION_MZONE,0,1,nil) and ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c9950716.cfilter(c,tp)
	return c:IsLevelAbove(5) and c:IsSetCard(0x3bd3) and c:IsControler(tp) and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c9950716.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9950716.cfilter,1,nil,tp)
end
function c9950716.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsPlayerCanDraw(tp,1)
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	local b2=g:GetCount()>0
	if chk==0 then return b1 or b2 end
	local sel=0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	if b1 and b2 then
		sel=Duel.SelectOption(tp,aux.Stringid(9950716,1),aux.Stringid(9950716,2))
	elseif b1 then
		sel=Duel.SelectOption(tp,aux.Stringid(9950716,1))
	else
		sel=Duel.SelectOption(tp,aux.Stringid(9950716,2))+1
	end
	if sel==0 then
		e:SetCategory(CATEGORY_DRAW)
		e:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
		e:SetOperation(c9950716.drop)
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(1)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	else
		e:SetCategory(CATEGORY_DESTROY)
		e:SetOperation(c9950716.desop)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	end
end
function c9950716.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c9950716.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c9950716.drtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
   if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
function c9950716.drop2(e,tp,eg,ep,ev,re,r,rp,chk)
	 local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SSet(tp,c)
	end
end
