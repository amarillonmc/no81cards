--赫默·瑟谣浮收藏-主治医师
function c79029471.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xa900),7,2)
	--add code
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_ADD_CODE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(79029028)
	c:RegisterEffect(e0)	
	--pset
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,79029471)
	e1:SetTarget(c79029471.pstg)
	e1:SetOperation(c79029471.psop)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,19029471)
	e2:SetCost(c79029471.spcost)
	e2:SetTarget(c79029471.sptg)
	e2:SetOperation(c79029471.spop)
	c:RegisterEffect(e2)
	--xyz
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,29029471)
	e3:SetTarget(c79029471.xytg)
	e3:SetOperation(c79029471.xyop)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetTarget(c79029471.pentg)
	e4:SetOperation(c79029471.penop)
	c:RegisterEffect(e4)  
end
c79029471.pendulum_level=7
function c79029471.pcfilter(c)
	return c:IsSetCard(0x1907) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c79029471.pstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and Duel.IsExistingMatchingCard(c79029471.pcfilter,tp,LOCATION_DECK,0,1,nil) and e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) end
end   
function c79029471.psop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c79029471.pcfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
	Debug.Message("帮助大家。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029471,3))
	Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c79029471.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c79029471.spfil(c,e,tp)
	return (c:IsCanBeSpecialSummoned(e,0,tp,false,false) and ((Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and not c:IsLocation(LOCATION_EXTRA)) or (c:IsLocation(LOCATION_EXTRA) and c:IsFaceup() and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0))) and c:IsSetCard(0x1907)
end
function c79029471.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029471.spfil,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA)
end
function c79029471.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c79029471.spfil,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA,0,nil,e,tp)
	if g:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,1,1,nil)
	Debug.Message("队员们，全力以赴地战斗吧。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029471,1))
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end
function c79029471.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c79029471.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	Debug.Message("明白，我会做好支援工作。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029471,0))
	end
end
function c79029471.xmfil1(c,e,tp)
	return c:IsSetCard(0xa900) and c:IsCanOverlay() and Duel.IsExistingMatchingCard(c79029471.xmfil2,tp,LOCATION_MZONE,0,1,nil,c) and Duel.GetMZoneCount()
end
function c79029471.xmfil2(c,tc)
	local lv1=c:GetLevel()
	return c:IsSetCard(0xa900) and c:IsCanOverlay() and lv1==tc:GetLevel()
end
function c79029471.xytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c79029471.xmfil1,tp,LOCATION_MZONE,0,1,nil,e,tp) and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) end
	local tc1=Duel.SelectTarget(tp,c79029471.xmfil1,tp,LOCATION_MZONE,0,1,nil,e,tp):GetFirst()
	local tc2=Duel.SelectTarget(tp,c79029471.xmfil1,tp,LOCATION_MZONE,0,1,nil,tc1):GetFirst()
	Duel.SetTargetCard(Group.FromCards(tc1,tc2))
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_PZONE)
end
function c79029471.xyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc1=g:GetFirst()
	local tc2=g:GetNext()
	if c:IsRelateToEffect(e) and tc1:IsRelateToEffect(e) and tc2:IsRelateToEffect(e) then 
	Debug.Message("博士，让我去吧。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029471,2))
	Duel.Overlay(c,g)
	Duel.SpecialSummon(c,SUMMON_TYPE_XYZ,tp,tp,false,false)
	c:CompleteProcedure()
	end
end






