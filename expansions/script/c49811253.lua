--XXX-剑士 加特姆士
function c49811253.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,12,2)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(49811253,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCountLimit(1,49811252)
	e0:SetCondition(aux.XyzLevelFreeCondition(c49811253.mfilter,c49811253.xyzcheck,1,99))
	e0:SetTarget(aux.XyzLevelFreeTarget(c49811253.mfilter,c49811253.xyzcheck,1,99))
	e0:SetOperation(aux.XyzLevelFreeOperation(c49811253.mfilter,c49811253.xyzcheck,1,99))
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c49811253.imecon)
	e1:SetValue(c49811253.efilter)
	c:RegisterEffect(e1)
	--xmaterial
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(49811253,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c49811253.xmcon)
	e2:SetTarget(c49811253.xmtg)
	e2:SetOperation(c49811253.xmop)
	c:RegisterEffect(e2)
	--xmaterial2
	--local e22=Effect.Clone(e2)
	--e22:SetCode(EVENT_BATTLE_DESTROYED)
	--c:RegisterEffect(e22)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,49811253)
	e3:SetTarget(c49811253.sptg)
	e3:SetOperation(c49811253.spop)
	c:RegisterEffect(e3)
end
function c49811253.mfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xd)
end
function c49811253.xyzcheck(g)
	local tp=g:GetFirst():GetControler()
	local xg=Duel.GetMatchingGroup(c49811253.mfilter,tp,0,LOCATION_MZONE,nil)
	--local xg=Duel.GetMatchingGroup(c49811253.mfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	--if xg:GetCount()==0 then return false end
	--local tg=xg:GetMaxGroup(Card.GetAttack)
	--return tg:IsExists(Card.IsControler,1,nil,1-tp)
	return #xg>0
end
function c49811253.imecon(e)
	return e:GetHandler():GetOverlayCount()>=5
end
function c49811253.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function c49811253.cfilter(c)
	return c:IsPreviousLocation(LOCATION_MZONE)
end
function c49811253.xmcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c49811253.cfilter,1,nil)
end
function c49811253.xmfilter(c,e)
	return c:IsSetCard(0xd) and c:IsCanBeXyzMaterial(e:GetHandler())
end
function c49811253.xmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c49811253.xmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c49811253.xmfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,e:GetHandler(),e)
	local cg=g:GetMinGroup(Card.GetAttack)
	if cg:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		cg=cg:Select(tp,1,1,nil)
	end
	Duel.Overlay(e:GetHandler(),cg)
end
function c49811253.spfilter(c,e,tp)
	return c:IsSetCard(0x100d) and c:IsType(TYPE_SYNCHRO) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function c49811253.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL)
		and Duel.IsExistingMatchingCard(c49811253.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c49811253.spop(e,tp,eg,ep,ev,re,r,rp)
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c49811253.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if tc then
		tc:SetMaterial(nil)
		if Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)>0 then
			Duel.SetLP(tp,Duel.GetLP(tp)-tc:GetLevel()*1000)
			--Duel.Damage(tp,tc:GetLevel()*1000,REASON_EFFECT)
			tc:CompleteProcedure()
		end
	end
end