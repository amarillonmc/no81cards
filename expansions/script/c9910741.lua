--远古造物 喜马拉雅鱼龙
Duel.LoadScript("c9910700.lua")
function c9910741.initial_effect(c)
	--special summon
	QutryYgzw.AddSpProcedure(c,3)
	c:EnableReviveLimit()
	--flag
	QutryYgzw.AddTgFlag(c)
	--spsummon / negate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetCountLimit(1,9910741)
	e1:SetCondition(c9910741.spcon)
	e1:SetCost(c9910741.spcost)
	e1:SetTarget(c9910741.sptg)
	e1:SetOperation(c9910741.spop)
	c:RegisterEffect(e1)
end
function c9910741.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return re:IsActiveType(TYPE_MONSTER)
		and (c:IsLocation(LOCATION_HAND) or (not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainDisablable(ev)))
end
function c9910741.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c9910741.cfilter(c,b1,b2,tp,rc)
	local res=b1 and (Duel.GetMZoneCount(tp,c)>0 or Duel.GetMZoneCount(tp,rc)>0)
	return c:IsSetCard(0xc950) and bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0 and c:IsAbleToRemoveAsCost() and (res or b2)
end
function c9910741.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	local g=Group.FromCards(c,rc)
	local b0=rc:IsRelateToEffect(re) and rc:IsAbleToRemoveAsCost() and not rc:IsLocation(LOCATION_REMOVED)
	local b1=c:IsLocation(LOCATION_HAND) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
	local b2=c:IsLocation(LOCATION_ONFIELD)
	local b3=Duel.IsExistingMatchingCard(c9910741.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,g,b1,b2,tp,rc)
	if chk==0 then
		if e:GetLabel()~=0 then
			e:SetLabel(0)
			return b0 and b3
		else
			return b0 and (b1 or b2)
		end
	end
	if e:GetLabel()~=0 then
		e:SetLabel(0)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=Duel.SelectMatchingCard(tp,c9910741.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,g,b1,b2,tp,rc)
		rg:AddCard(rc)
		Duel.Remove(rg,POS_FACEUP,REASON_COST)
	end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(9910741,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(9910741,1)
		opval[off-1]=2
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	e:SetLabel(opval[op])
	if opval[op]==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	else
		e:SetCategory(CATEGORY_DISABLE)
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	end
end
function c9910741.spop(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	if sel==1 then
		if e:GetHandler():IsRelateToEffect(e) then
			Duel.SpecialSummon(e:GetHandler(),0,tp,tp,true,false,POS_FACEUP)
		end
	else
		Duel.NegateEffect(ev)
	end
end
