--煌·音律联觉收藏-爆裂菲林
function c79029483.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xa900),6,2)
	c:EnableReviveLimit() 
	--add code
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_ADD_CODE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(79029125)
	c:RegisterEffect(e0) 
	--cannot target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(aux.indoval)
	c:RegisterEffect(e2)	
	--ov
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c79029483.xyztg) 
	e3:SetOperation(c79029483.xyzop)
	c:RegisterEffect(e3)
	--xyz
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,79029483)
	e4:SetTarget(c79029483.sptg)
	e4:SetOperation(c79029483.spop)
	c:RegisterEffect(e4)
end
function c79029483.xyzfil(c)
	return c:IsCanOverlay() and c:IsSetCard(0xa900) and c:IsType(TYPE_MONSTER)
end
function c79029483.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and Duel.IsExistingMatchingCard(c79029483.xyzfil,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,nil) end
end
function c79029483.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsLocation(LOCATION_MZONE) then return end
	local g=Duel.GetMatchingGroup(c79029483.xyzfil,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,nil)
	if g:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local sg=g:Select(tp,1,1,nil)
	Debug.Message("哈，有没有感觉周围的空气变得燥热了？没有？咦，我再加加温试试，还想着这样能炒热气氛来着......")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029483,0))
	Duel.Overlay(c,sg)
end
function c79029483.filter2(c,e,tp,mc,rk,rc,code)
	return c:IsRank(rk+1,rk-1) and c:IsSetCard(0xa900) and mc:IsCanBeXyzMaterial(c) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c79029483.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c79029483.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,c:GetRank(),c:GetRace(),c:GetCode()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c79029483.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if c:IsFacedown() or not c:IsRelateToEffect(e) or c:IsControler(1-tp) or c:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c79029483.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c,c:GetRank(),c:GetRace(),c:GetCode())
	local sc=g:GetFirst()
	if sc then
	Debug.Message("虽然有点暴力，但我可是很喜欢切裂钢铁和掩体的！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029483,1))
		local mg=c:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(c))
		Duel.Overlay(sc,Group.FromCards(c))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end

