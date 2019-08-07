--dr
function c10150050.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c10150050.cost)
	e1:SetTarget(c10150050.target)
	e1:SetOperation(c10150050.activate)
	c:RegisterEffect(e1)	
end
function c10150050.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or not tc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION+0x10,tp,false,false) then return end
	local lv=tc:GetLevel()
	local sg=aux.GetMustMaterialGroup(tp,EFFECT_MUST_BE_FMATERIAL)
	if sg:GetCount()>0 then
	   if sg:IsExists(c10150050.mustfilter,1,nil,sg,lv) then return false end
	   if sg:IsExists(aux.NOT(c10150050.rfilter0),1,nil,c) then return false end
	   if sg:IsExists(Card.IsImmuneToEffect,1,nil,e) then return false end
	end
	local mg=Duel.GetMatchingGroup(c10150050.rfilter0,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE,0,nil):Filter(aux.NOT(Card.IsImmuneToEffect),nil,e)
	local fusm=Group.CreateGroup()
	--type 1 , must material group contains all material
	local tlv=sg:GetSum(Card.GetLevel)
	if sg:IsExists(Card.IsSetCard,1,nil,0x8) and tlv>=lv and Duel.GetLocationCountFromEx(tp,tp,sg)>0 then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)   
	   sg:Select(tp,sg:GetCount(),sg:GetCount(),nil) 
	   fusm:Merge(sg)
	else
	--type 2 , first check 1 HERO monster 
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	   local mc1=mg:FilterSelect(tp,c10150050.cfilter1,1,1,nil,tp,sg,mg,lv):GetFirst()
	   if not mc1 then return end
	   fusm:AddCard(mc1)
	   if sg:GetCount()>0 then
		  local sg2=sg:Clone()
		  if sg2:IsContains(mc1) then sg2:RemoveCard(mc1) end
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)   
		  sg2:Select(tp,sg2:GetCount(),sg2:GetCount(),nil)   
		  fusm:Merge(sg)	
	   end
	   if Duel.GetLocationCountFromEx(tp,tp,fusm)>0 then
		  Duel.SetSelectedCard(fusm)
		  local mat=mg:SelectWithSumGreater(tp,Card.GetLevel,lv,0,99)
		  fusm:Merge(mat)
	   else
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		  local mc2=mg:FilterSelect(tp,c10150050.cfilter2,1,1,nil,tp,fusm,mg,lv):GetFirst()
		  fusm:AddCard(mc2)
		  Duel.SetSelectedCard(fusm)
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		  local mat2=mg:SelectWithSumGreater(tp,Card.GetLevel,lv,0,99)
		  fusm:Merge(mat2)
	   end
	end
	if fusm:GetCount()<=0 then return end
	if Duel.Remove(fusm,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)~=0 then
	   tc:SetMaterial(fusm)
	   Duel.BreakEffect()
	   Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION+0x10,tp,tp,false,false,POS_FACEUP)
	   tc:CompleteProcedure()
	end
end
function c10150050.rfilter0(c,fc)
	return c:IsLevelAbove(1) and c:IsAbleToRemove() and c:IsCanBeFusionMaterial(fc) and (not c:IsOnField() or c:IsFaceup())
end
function c10150050.mustfilter(c,sg,lv)
	local sg2=sg:Clone()
	local tlv=sg2:GetSum(Card.GetLevel)
	sg2:RemoveCard(c)
	return sg2:CheckWithSumGreater(Card.GetLevel,lv) or (tlv>=lv and not sg:IsExists(Card.IsSetCard,1,nil,0x8))
end
function c10150050.costfilter(c,e,tp,sg)
	local lv=c:GetLevel()
	if not (c:IsLevelAbove(0) and c:IsRace(RACE_FIEND) and c:IsType(TYPE_FUSION) and c:IsSetCard(0x8) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION+0x10,tp,false,false)) then return false end
	if sg:GetCount()>0 then
	   if sg:IsExists(c10150050.mustfilter,1,nil,sg,lv) then return false end
	   if sg:IsExists(aux.NOT(c10150050.rfilter0),1,nil,c) then return false end
	end
	local mg=Duel.GetMatchingGroup(c10150050.rfilter0,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE,0,nil)
	--type 1 , must material group contains all material
	local tlv=sg:GetSum(Card.GetLevel)
	if sg:IsExists(Card.IsSetCard,1,nil,0x8) and tlv>=lv then return Duel.GetLocationCountFromEx(tp,tp,sg)>0 end
	--type 2 , first check 1 HERO monster 
	return mg:IsExists(c10150050.cfilter1,1,nil,tp,sg,mg,lv)
end
function c10150050.cfilter1(c,tp,sg,mg,lv)
	if not c:IsSetCard(0x8) then return false end
	local sg2=sg:Clone()
	sg2:AddCard(c)
	local tlv=sg2:GetSum(Card.GetLevel)
	if tlv>=lv then return Duel.GetLocationCountFromEx(tp,tp,sg2)>0
	else
	   return mg:IsExists(c10150050.cfilter2,1,nil,tp,sg2,mg,lv)
	end
end
function c10150050.cfilter2(c,tp,sg,mg,lv)
	local sg2=sg:Clone()
	sg2:AddCard(c)
	if Duel.GetLocationCountFromEx(tp,tp,sg2)<=0 then return false end
	Duel.SetSelectedCard(sg2)
	return mg:CheckWithSumGreater(Card.GetLevel,lv)
end
function c10150050.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg=aux.GetMustMaterialGroup(tp,EFFECT_MUST_BE_FMATERIAL)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c10150050.costfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,sg)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc=Duel.SelectMatchingCard(tp,c10150050.costfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,sg):GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,tp,LOCATION_EXTRA)
end
function c10150050.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
