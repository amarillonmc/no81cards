--潜海的海龙神
local s,id=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,22702055)
	--code
	aux.EnableChangeCode(c,22702055,LOCATION_SZONE+LOCATION_GRAVE)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--diszone
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.discon)
	e1:SetTarget(s.distg)
	e1:SetOperation(s.disop)
	c:RegisterEffect(e1) 
	--dice
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=eg:GetFirst()
	if not (rc:IsFaceup() and rc:IsControler(tp) and (c:IsType(TYPE_NORMAL) and c:IsAttribute(ATTRIBUTE_WATER) or aux.IsCodeListed(rc,22702055))) then return end
	local bc=rc:GetBattleTarget()
	if not bc then return end
	local seq=bc:GetPreviousSequence()
	e:SetLabel(seq)
	return seq<5 and Duel.GetAttacker()==rc and rc:IsStatus(STATUS_OPPO_BATTLE)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local rc=eg:GetFirst()
	Duel.SetTargetCard(rc)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) and rc:IsFaceup() and rc:IsControler(tp) and rc:IsRelateToEffect(e) then return end
	local seq=e:GetLabel()
	local val=aux.SequenceToGlobal(1-tp,LOCATION_MZONE,seq)
	--disable field
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetReset(RESET_EVENT|RESETS_STANDARD)
	e1:SetCondition(s.condition)
	e1:SetLabel(tp)
	e1:SetValue(val)
	rc:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandlerPlayer()==e:GetLabel()
end
function s.cfilter(c,tp)
	return ((aux.IsCodeListed(c,22702055) and c:IsType(TYPE_MONSTER)) or (c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_NORMAL))) and c:IsControler(tp)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return eg and eg:IsExists(s.cfilter,1,nil,tp)
end
function s.thfilter(c)
	return c:IsSetCard(0x177,0x178) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(id) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end