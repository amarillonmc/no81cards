--白 骨 魔 召  血 星 主
local m=22348305
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c22348305.lcheck)
	c:EnableReviveLimit()
	--extra material
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(22348305,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c22348305.linkcon)
	e0:SetOperation(c22348305.linkop)
	e0:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e0)
	--summon success
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e10:SetCode(EVENT_SPSUMMON_SUCCESS)
	e10:SetCondition(c22348305.regcon)
	e10:SetOperation(c22348305.regop)
	c:RegisterEffect(e10)
	local e20=Effect.CreateEffect(c)
	e20:SetType(EFFECT_TYPE_SINGLE)
	e20:SetCode(EFFECT_MATERIAL_CHECK)
	e20:SetValue(c22348305.valcheck)
	e20:SetLabelObject(e10)
	c:RegisterEffect(e20)
	--normal monster
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c22348305.nmcon)
	e1:SetValue(TYPE_NORMAL)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_REMOVE_TYPE)
	e2:SetValue(TYPE_EFFECT)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,22348305)
	e3:SetCondition(c22348305.efcon)
	e3:SetTarget(c22348305.sptg1)
	e3:SetOperation(c22348305.spop1)
	c:RegisterEffect(e3)
	
end
function c22348305.lmfilter(c,lc,tp,og,lmat)
	return c:IsFaceup() and c:IsCanBeLinkMaterial(lc) and c:IsLinkCode(22348305)
		and c:IsLinkType(TYPE_LINK) and c:IsLinkType(TYPE_NORMAL)
		and Duel.GetLocationCountFromEx(tp,tp,c,lc)>0 and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_LMATERIAL)
		and (not og or og:IsContains(c)) and (not lmat or lmat==c)
end
function c22348305.linkcon(e,c,og,lmat,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c22348305.lmfilter,tp,LOCATION_MZONE,0,1,nil,c,tp,og,lmat)
end
function c22348305.linkop(e,tp,eg,ep,ev,re,r,rp,c,og,lmat,min,max)
	local mg=Duel.SelectMatchingCard(tp,c22348305.lmfilter,tp,LOCATION_MZONE,0,1,1,nil,c,tp,og,lmat)
	c:SetMaterial(mg)
	Duel.SendtoGrave(mg,REASON_MATERIAL+REASON_LINK)
end
function c22348305.lcheck(g,lc)
	return g:IsExists(Card.IsLinkType,1,nil,TYPE_NORMAL)
end
function c22348305.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetLabel()==1
end
function c22348305.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(22348305,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(22348305,1))
end
function c22348305.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsLinkCode,1,nil,22348305) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c22348305.nmcon(e)
	return e:GetHandler():GetFlagEffect(22348305)<1
end
function c22348305.efcon(e)
	return e:GetHandler():GetFlagEffect(22348305)>0
end
function c22348305.spfilter1(c,e,tp)
	return c:IsType(TYPE_NORMAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22348305.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c22348305.spfilter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c22348305.spfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c22348305.spfilter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c22348305.smfilter(c)
	return c:IsType(TYPE_NORMAL) and c:IsSummonable(true,nil)
end
function c22348305.spop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 and Duel.IsExistingMatchingCard(c22348305.smfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(22348305,2)) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			Duel.BreakEffect()
	local g=Duel.SelectMatchingCard(tp,c22348305.smfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
	end
end
