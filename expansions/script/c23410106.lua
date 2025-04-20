--磐石架势
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,23410101)
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,cm.mfilter1,cm.mfilter2,true)
	--code
	aux.EnableChangeCode(c,23410101,LOCATION_MZONE)
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(1)
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.thcon1)
	e1:SetTarget(cm.thtg1)
	e1:SetOperation(cm.thop1)
	c:RegisterEffect(e1)

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(cm.indtg)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m+10000000)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
end
function cm.mfilter1(c)
	return c:IsRace(RACE_ILLUSION) and c:IsAttribute(ATTRIBUTE_FIRE)
end
function cm.mfilter2(c)
	return c:IsRace(RACE_ILLUSION) and not c:IsAttribute(ATTRIBUTE_FIRE)
end
function cm.mfilter3(c)
	return c:IsFacedown()
end
function cm.mfilter4(c)
	return c:IsOriginalCodeRule(23410101) and c:IsReleasable() and c:IsCanBeFusionMaterial()
end
function cm.spcon(e,c)
	local tp=e:GetHandlerPlayer()
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(cm.mfilter3,tp,LOCATION_ONFIELD,0,1,nil)
	and Duel.IsExistingMatchingCard(cm.mfilter4,tp,LOCATION_MZONE,0,1,nil)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(cm.mfilter4,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=g:Select(tp,1,1,nil)
	if not Duel.Release(sg,REASON_COST) then return end
	c:SetMaterial(sg)  
end

function cm.thcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function cm.thfilter1(c)
	return aux.IsCodeListed(c,23410101) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_QUICKPLAY) and c:IsAbleToHand()
end
function cm.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.indtg(e,c)
	local tc=e:GetHandler()
	return c==tc or c==tc:GetBattleTarget()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	if Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT,nil) and c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(2000)
		c:RegisterEffect(e1)
		if Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_ONFIELD,0,2,nil) and Duel.IsExistingMatchingCard(cm.fil5,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local g=Duel.SelectMatchingCard(tp,cm.fil5,tp,LOCATION_GRAVE,0,1,1,nil)
			if Duel.SSet(tp,g)~=0 then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				g:GetFirst():RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
				g:GetFirst():RegisterEffect(e2)
			end
		end
	end
end
function cm.fil5(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable() and aux.IsCodeListed(c,23410101)
end













