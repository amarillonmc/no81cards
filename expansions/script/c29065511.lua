--方舟骑士深层归还
c29065511.named_with_Arknight=1
function c29065511.initial_effect(c)
	aux.AddCodeList(c,29065500)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,29065511) 
	e1:SetTarget(c29065511.actg) 
	e1:SetOperation(c29065511.acop) 
	c:RegisterEffect(e1)
end 
function c29065511.spfil1(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight))  
end 
function c29065511.spfil2(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCode(29065502)  
end 
function c29065511.ckfil(c) 
	return c:IsFaceup() and c:IsCode(29065500) 
end 
function c29065511.actg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local b1=Duel.IsExistingMatchingCard(c29065511.spfil1,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
	local b2=Duel.IsExistingMatchingCard(c29065511.spfil2,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(c29065511.ckfil,tp,LOCATION_ONFIELD,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
	if chk==0 then return b1 or b2 end  
	local op=0 
	if b1 and b2 then 
	op=Duel.SelectOption(tp,aux.Stringid(29065511,0),aux.Stringid(29065511,1)) 
	elseif b1 then 
	op=Duel.SelectOption(tp,aux.Stringid(29065511,0))
	elseif b2 then 
	op=Duel.SelectOption(tp,aux.Stringid(29065511,1))+1
	end 
	e:SetLabel(op) 
	if op==0 then 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	elseif op==1 then 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK)
	end 
end 
function c29065511.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=e:GetLabel()
	local g1=Duel.GetMatchingGroup(c29065511.spfil1,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	local g2=Duel.GetMatchingGroup(c29065511.spfil2,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,nil,e,tp)
	if op==0 then 
	if g1:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	local sg=g1:Select(tp,1,1,nil) 
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
	end 
	elseif op==1 then 
	if g2:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	local sg=g2:Select(tp,1,1,nil) 
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
	end 
	end 
end 










