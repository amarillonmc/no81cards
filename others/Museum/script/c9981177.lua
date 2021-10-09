--骑士时刻·Zamonas
function c9981177.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xbca),3)
	c:EnableReviveLimit()
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(c9981177.indval)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(c9981177.efilter)
	c:RegisterEffect(e3)
	--destroy1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9981177,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c9981177.con)
	e1:SetTarget(c9981177.destg1)
	e1:SetOperation(c9981177.desop1)
	c:RegisterEffect(e1)
	--destroy2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9981177,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c9981177.con)
	e2:SetCost(c9981177.descost2)
	e2:SetTarget(c9981177.destg2)
	e2:SetOperation(c9981177.desop2)
	c:RegisterEffect(e2)
	--handes
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9981177,2))
	e3:SetCategory(CATEGORY_HANDES+CATEGORY_TOGRAVE+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c9981177.con)
	e3:SetCost(c9981177.hdcost)
	e3:SetTarget(c9981177.hdtg)
	e3:SetOperation(c9981177.hdop)
	c:RegisterEffect(e3)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9981177.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9981177.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981177,3))
end
function c9981177.indval(e,c)
	return c:IsSetCard(0xbca)
end
function c9981177.efilter(e,te)
	return te:GetHandler():IsSetCard(0xbca)
end
function c9981177.confilter(c)
	return c:IsFaceup() and c:IsSetCard(0xbca)
end
function c9981177.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9981177.confilter,tp,0,LOCATION_MZONE,1,nil)
end
function c9981177.filter1(c)
	return c:IsFaceup()
end
function c9981177.destg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and c9981177.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9981177.filter1,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c9981177.filter1,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c9981177.desop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFacedown() then
		Duel.Destroy(tc,REASON_EFFECT)
		Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981177,3))
	end
end
function c9981177.descost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c9981177.filter2(c)
	return c:IsType(TYPE_MONSTER)
end
function c9981177.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9981177.filter2,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c9981177.filter2,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c9981177.desop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9981177.filter2,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981177,3))
end
function c9981177.hdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	Duel.SendtoGrave(g,REASON_COST)
end
function c9981177.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,1-tp,LOCATION_HAND)
end
function c9981177.hdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	Duel.ConfirmCards(tp,g)
	local sg=g:Filter(Card.IsSetCard,nil,0xbca)
	if sg:GetCount()>0 then
		local atk=0
		Duel.SendtoGrave(sg,REASON_EFFECT)
		local tc=sg:GetFirst()
		while tc do
			local tatk=tc:GetAttack()
			if tatk<0 then tatk=0 end
			atk=atk+tatk
			tc=sg:GetNext()
		end
		Duel.BreakEffect()
		Duel.Damage(1-tp,atk,REASON_EFFECT)
	end
	Duel.ShuffleHand(1-tp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981177,3))
end
