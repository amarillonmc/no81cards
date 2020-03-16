--康诺特女王·梅芙
function c9951092.initial_effect(c)
	 c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,9951011,aux.FilterBoolFunction(Card.IsFusionSetCard,0xba5),1,true,true)
	aux.AddContactFusionProcedure(c,c9951092.cfilter,LOCATION_MZONE,0,aux.tdcfop(c)):SetValue(1)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c9951092.splimit)
	c:RegisterEffect(e1)
 --extra summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9951092,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c9951092.espcon)
	e3:SetTarget(c9951092.esptg)
	e3:SetOperation(c9951092.espop)
	c:RegisterEffect(e3)
--material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9951092,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,59208944)
	e2:SetTarget(c9951092.mattg)
	e2:SetOperation(c9951092.matop)
	c:RegisterEffect(e2)
	 --spsummon bgm
	 local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9951092.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9951092.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951092,0))
 Duel.Hint(HINT_SOUND,0,aux.Stringid(9951092,2))
end
function c9951092.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c9951092.espcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c9951092.espfilter(c,e,tp)
	return c:IsSetCard(0xba5) and c:IsType(TYPE_XYZ) and c:IsAttackBelow(4000)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c9951092.esptg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_XMATERIAL)
		and Duel.IsExistingMatchingCard(c50588353.espfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9951092.espop(e,tp,eg,ep,ev,re,r,rp)
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c50588353.espfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,nil):GetFirst()
	if tc then
		Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
 Duel.Hint(HINT_SOUND,0,aux.Stringid(9951092,3))
end
function c9951092.tgfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c9951092.matfilter(c)
	return c:IsSetCard(0xba5) and c:IsCanOverlay()
end
function c9951092.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c9951092.tgfilter(chkc) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(c9951092.tgfilter,tp,LOCATION_MZONE,0,1,c)
		and Duel.IsExistingMatchingCard(c9951092.matfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c9951092.tgfilter,tp,LOCATION_MZONE,0,1,1,c)
end
function c9951092.matop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,c9951092.matfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.Overlay(tc,g)
		end
	end
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951092,0))
 Duel.Hint(HINT_SOUND,0,aux.Stringid(9951092,3))
end