--远古造物 塞文泰坦鱼龙
dofile("expansions/script/c9910700.lua")
function c9910741.initial_effect(c)
	--special summon
	QutryYgzw.AddSpProcedure(c,3)
	c:EnableReviveLimit()
	--flag
	QutryYgzw.AddTgFlag(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetCondition(c9910741.condition)
	e1:SetCost(c9910741.cost)
	e1:SetTarget(c9910741.sptg)
	e1:SetOperation(c9910741.spop)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c9910741.condition)
	e2:SetCost(c9910741.cost)
	e2:SetTarget(c9910741.atktg)
	e2:SetOperation(c9910741.atkop)
	c:RegisterEffect(e2)
end
function c9910741.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER)
end
function c9910741.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c9910741.cfilter1(c,tp,rc)
	return c:IsSetCard(0xc950) and c:IsAbleToRemoveAsCost() and (Duel.GetMZoneCount(tp,c)>0 or Duel.GetMZoneCount(tp,rc)>0)
end
function c9910741.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	local g=Group.FromCards(c,rc)
	if chk==0 then
		if e:GetLabel()==100 then
			e:SetLabel(0)
			return rc:IsRelateToEffect(re) and rc:IsAbleToRemoveAsCost() and not rc:IsLocation(LOCATION_REMOVED)
				and Duel.IsExistingMatchingCard(c9910741.cfilter1,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,g,tp,rc)
				and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
		else
			return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
		end
	end
	if e:GetLabel()~=0 then
		e:SetLabel(0)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=Duel.SelectMatchingCard(tp,c9910741.cfilter1,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,g,tp,rc)
		rg:AddCard(rc)
		local cg=rg:Filter(Card.IsFacedown,nil)
		Duel.ConfirmCards(1-tp,cg)
		Duel.Remove(rg,POS_FACEUP,REASON_COST)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c9910741.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,true,false,POS_FACEUP)
	end
end
function c9910741.cfilter2(c)
	return c:IsSetCard(0xc950) and c:IsAbleToRemoveAsCost()
end
function c9910741.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	local g=Group.FromCards(c,rc)
	if chk==0 then
		if e:GetLabel()==100 then
			e:SetLabel(0)
			return rc:IsRelateToEffect(re) and rc:IsAbleToRemoveAsCost() and not rc:IsLocation(LOCATION_REMOVED)
				and Duel.IsExistingMatchingCard(c9910741.cfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,g)
				and not c:IsAttack(4500)
		else
			return not c:IsAttack(4500)
		end
	end
	if e:GetLabel()~=0 then
		e:SetLabel(0)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=Duel.SelectMatchingCard(tp,c9910741.cfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,g)
		rg:AddCard(rc)
		local cg=rg:Filter(Card.IsFacedown,nil)
		Duel.ConfirmCards(1-tp,cg)
		Duel.Remove(rg,POS_FACEUP,REASON_COST)
	end
end
function c9910741.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(4500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
