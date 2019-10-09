--终焉邪魂 暗魂
function c30000029.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c30000029.lcheck)
	c:EnableReviveLimit()
	--link module
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(30000029,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,30000029)
	e1:SetTarget(c30000029.thtg)
	e1:SetOperation(c30000029.thop)
	c:RegisterEffect(e1)
	--link module
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(30000029,1))
	e7:SetCategory(CATEGORY_DRAW+CATEGORY_REMOVE)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e7:SetCode(EVENT_REMOVE)
	e7:SetCountLimit(1,30000030)
	e7:SetCondition(c30000029.con0)
	e7:SetTarget(c30000029.target0)
	e7:SetOperation(c30000029.activate)
	c:RegisterEffect(e7)
end

function c30000029.con0(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end

function c30000029.target0(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) and Duel.IsPlayerCanRemove(tp) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	if Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)==0 then e:SetLabel(1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,2)
end
function c30000029.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)==2 and Duel.IsPlayerCanRemove(p) then
		Duel.ShuffleHand(p)
		Duel.BreakEffect()
		local reg=Duel.SelectMatchingCard(p,Card.IsAbleToRemove,tp,LOCATION_HAND,0,2,2,nil)
		Duel.Remove(reg,POS_FACEUP,REASON_EFFECT)
		if e:GetLabel()==1 and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(30000027,1)) then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end

function c30000029.lcheck(g)
	return g:IsExists(Card.IsLinkAttribute,1,nil,ATTRIBUTE_DARK)
end

function c30000029.thfilter(c)
	return c:IsSetCard(0x3920) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c30000029.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c30000029.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_REMOVED)
end
function c30000029.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c30000029.thfilter),tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end