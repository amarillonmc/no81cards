--乌萨斯·据点-秘密营地
function c79029185.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c79029185.target)
	e1:SetOperation(c79029185.operation)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(1000)
	c:RegisterEffect(e2)
	--equip limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EQUIP_LIMIT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(c79029185.eqlimit)
	c:RegisterEffect(e3)  
	--SpecialSummon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetTarget(c79029185.sptg)
	e4:SetOperation(c79029185.spop)
	c:RegisterEffect(e4)  
	--xyz
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(c79029185.xtg)
	e5:SetOperation(c79029185.xop)
	e5:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e5)
end
function c79029185.eqlimit(e,c)
	return c:IsSetCard(0xa900)
end
function c79029185.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xa900)
end
function c79029185.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c79029185.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c79029185.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c79029185.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c79029185.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c79029185.spfilter(c,lv,e,tp)
	return c:IsLevelBelow(lv) and c:IsSetCard(0xa900) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c79029185.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and eg:GetFirst()==e:GetHandler():GetEquipTarget() end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE)
end
function c79029185.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetEquipTarget()
	local lv=tc:GetRank()
	if not Duel.IsExistingMatchingCard(c79029185.spfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,lv,e,tp) then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local slv=tc:GetRank()
	local sg=Duel.GetMatchingGroup(c79029185.spfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,nil,slv,e,tp)
	if sg:GetCount()==0 then return end
	repeat
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=sg:Select(tp,1,1,nil):GetFirst()
		sg:RemoveCard(tc)
		slv=slv-tc:GetLevel()
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		sg:Remove(Card.IsLevelAbove,nil,slv+1)
		ft=ft-1
	until ft<=0 or sg:GetCount()==0 or not Duel.SelectYesNo(tp,aux.Stringid(28577986,1))
	Duel.SpecialSummonComplete()
end
function c79029185.xfil(c)
	 return c:IsSetCard(0xa900) and c:IsType(TYPE_XYZ)
end
function c79029185.xtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	 if chk==0 then return e:GetHandler():IsType(TYPE_CONTINUOUS) and Duel.IsExistingMatchingCard(c79029185.xfil,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_GRAVE,1,nil) end
	 local g=Duel.SelectMatchingCard(tp,c79029185.xfil,tp,LOCATION_MZONE,0,1,1,nil)
	 Duel.SetTargetCard(g)
end
function c79029185.xop(e,tp,eg,ep,ev,re,r,rp)
	 local tc=Duel.GetFirstTarget()
	 local a1=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_GRAVE,0,1,1,nil)
	 local a2=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_GRAVE,1,1,nil)
	 a1:Merge(a2)
	 if tc:IsRelateToEffect(e) then
	 Duel.Overlay(tc,a1)
end
end





