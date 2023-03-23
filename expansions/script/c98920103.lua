--天启之圣像骑士
function c98920103.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,4,c98920103.lcheck)
	c:EnableReviveLimit()
--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c98920103.atkval)
	c:RegisterEffect(e1)
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c98920103.antg)
	c:RegisterEffect(e2)
--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920103,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c98920103.discon)
	e2:SetCost(c98920103.discost)
	e2:SetTarget(c98920103.distg)
	e2:SetOperation(c98920103.disop)
	c:RegisterEffect(e2)
end
function c98920103.lcheck(g,lc)
	return g:IsExists(c98920103.mzfilter,1,nil)
end
function c98920103.mzfilter(c)
	return c:IsLinkSetCard(0x116) and c:IsLinkType(TYPE_LINK)
end
function c98920103.atkval(e,c)
	local g=e:GetHandler():GetLinkedGroup():Filter(Card.IsFaceup,nil)
	return g:GetSum(Card.GetBaseAttack)
end
function c98920103.antg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end
function c98920103.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c98920103.cfilter(c,g)
	return g:IsContains(c) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c98920103.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup()
	if chk==0 then return Duel.CheckReleaseGroup(tp,c98920103.cfilter,1,nil,lg) end
	local g=Duel.SelectReleaseGroup(tp,c98920103.cfilter,1,1,nil,lg)
	Duel.Release(g,REASON_COST)
	e:SetLabelObject(g:GetFirst())
end
function c98920103.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c98920103.sfilter(c,e,tp)
	return c:IsSetCard(0x116) and c:IsType(TYPE_MONSTER)
		and (c:IsAbleToHand() or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c98920103.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		if Duel.Destroy(eg,REASON_EFFECT) then
		 if e:GetLabelObject():IsSetCard(0xfe,0x116) and Duel.SelectYesNo(tp,aux.Stringid(98920103,0)) then  
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
				local sc=Duel.SelectMatchingCard(tp,c98920103.sfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
				if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and sc:IsCanBeSpecialSummoned(e,0,tp,false,false)
					and (not sc:IsAbleToHand() or Duel.SelectOption(tp,1190,1152)==1) then
					Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
				else
					Duel.SendtoHand(sc,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,sc)
				end
		  end
		end   
	end
end