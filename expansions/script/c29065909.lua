--逆转的机壳·火剑之路
local m=29065909
local cm=_G["c"..m]
function c29065909.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,3,3,c29065909.lcheck)
	--extra material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c29065909.linkcon)
	e1:SetOperation(c29065909.linkop)
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetCondition(c29065909.immcon)
	e2:SetValue(c29065909.efilter)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SUMMON+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetHintTiming(0,TIMING_MAIN_END)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,29065909)
	e3:SetCondition(c29065909.con)
	e3:SetTarget(c29065909.tg)
	e3:SetOperation(c29065909.op)
	c:RegisterEffect(e3)
end
function c29065909.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xaa)
end
function c29065909.lmfilter(c,lc,tp,og,lmat)
	return c:IsFaceup() and c:IsCanBeLinkMaterial(lc) and (c:IsLinkCode(20447641) or c:IsSummonType(SUMMON_TYPE_ADVANCE)) and c:IsLinkSetCard(0xaa)
		and Duel.GetLocationCountFromEx(tp,tp,c,lc)>0 and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_LMATERIAL)
		and (not og or og:IsContains(c)) and (not lmat or lmat==c)
end
function c29065909.linkcon(e,c,og,lmat,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c29065909.lmfilter,tp,LOCATION_MZONE,0,1,nil,c,tp,og,lmat)
end
function c29065909.linkop(e,tp,eg,ep,ev,re,r,rp,c,og,lmat,min,max)
	local mg=Duel.SelectMatchingCard(tp,c29065909.lmfilter,tp,LOCATION_MZONE,0,1,1,nil,c,tp,og,lmat)
	c:SetMaterial(mg)
	Duel.SendtoGrave(mg,REASON_MATERIAL+REASON_LINK)
end
function c29065909.immcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c29065909.efilter(e,te)
	if te:IsActiveType(TYPE_SPELL+TYPE_TRAP) then return true
	else return te:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL) and te:IsActiveType(TYPE_EFFECT) and te:IsActivated() and te:GetOwner()~=e:GetOwner() end
end
function c29065909.con(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c29065909.pfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xaa) and c:IsAbleToHand()
end
function c29065909.sumfilter(c)
	return c:IsSetCard(0xaa) and c:IsSummonable(true,nil)
end
function c29065909.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29065909.pfilter,tp,LOCATION_EXTRA,0,1,nil) or Duel.IsExistingMatchingCard(c29065909.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
end
function c29065909.op(e,tp,eg,ep,ev,re,r,rp)
	local off=1
	local ops={}
	local opval={}
	if Duel.IsExistingMatchingCard(c29065909.pfilter,tp,LOCATION_EXTRA,0,1,1,nil) then
		ops[off]=aux.Stringid(29065909,0)
		opval[off-1]=1
		off=off+1
	end
	if Duel.IsExistingMatchingCard(c29065909.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil) then
		ops[off]=aux.Stringid(29065909,1)
		opval[off-1]=2
		off=off+1
	end
	if off==1 then return end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		local g=Duel.SelectMatchingCard(tp,c29065909.pfilter,tp,LOCATION_EXTRA,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	elseif opval[op]==2 then
		local g=Duel.SelectMatchingCard(tp,c29065909.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.Summon(tp,tc,true,nil)
		end
	end
end
