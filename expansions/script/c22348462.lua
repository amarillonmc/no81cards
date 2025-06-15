--灵魂吉他手
local m=22348462
local cm=_G["c"..m]
function cm.initial_effect(c)
	--deck SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22348462,0))
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,22348462)
	e1:SetTarget(c22348462.dstg)
	e1:SetOperation(c22348462.dsop)
	c:RegisterEffect(e1)
	--attset
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22348462,1))
	e2:SetCategory(CATEGORY_POSITION+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_F)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(2,EFFECT_COUNT_CODE_CHAIN)
	e2:SetCost(c22348462.ascost)
	e2:SetCondition(c22348462.ascon)
	e2:SetTarget(c22348462.astg)
	e2:SetOperation(c22348462.asop)
	c:RegisterEffect(e2)
	
end
function c22348462.dstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,1)
end
function c22348462.dsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.DiscardDeck(tp,1,REASON_EFFECT)~=0 and Duel.GetOperatedGroup():GetFirst():IsRace(RACE_ZOMBIE) then
		local dc=Duel.GetOperatedGroup():GetFirst()
		if dc:IsRace(RACE_ZOMBIE) and dc:IsType(TYPE_MONSTER) and c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
			Duel.BreakEffect()
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c22348462.ascost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,1) end
	Duel.DiscardDeck(tp,1,REASON_COST)
	local cc=Duel.GetOperatedGroup()
	e:SetLabelObject(cc)
end
function c22348462.ascon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsOnField() and re:GetHandler():IsRelateToEffect(re) and re:IsActiveType(TYPE_MONSTER)
end
function c22348462.astg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,300)
end
function c22348462.asop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	local cc=e:GetLabelObject():GetFirst()
	if  Duel.Recover(tp,300,REASON_EFFECT)~=0 and cc:IsType(TYPE_MONSTER) and rc:IsFaceup() and rc:IsRelateToEffect(re) and rc:IsCanTurnSet() and rc:IsLocation(LOCATION_MZONE) then
		Duel.BreakEffect()
		Duel.ChangePosition(rc,POS_FACEDOWN_DEFENSE)
	end
end







