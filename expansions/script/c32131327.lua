--无睱的真我 爱莉希雅
function c32131327.initial_effect(c)
	aux.AddCodeList(c,32131326)
	aux.AddMaterialCodeList(c,32131326)
	--code
	local e0=Effect.CreateEffect(c)  
	e0:SetType(EFFECT_TYPE_SINGLE)  
	e0:SetCode(EFFECT_ADD_CODE) 
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE) 
	e0:SetRange(0xff) 
	e0:SetValue(32131326) 
	c:RegisterEffect(e0)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,32131326,c32131327.mfilter,1,true,true) 
	aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_MZONE,0,Duel.Release,REASON_COST+REASON_MATERIAL)   
	--SpecialSummon 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(32131327,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,32131327) 
	e1:SetCondition(c32131327.spcon)
	e1:SetTarget(c32131327.sptg)
	e1:SetOperation(c32131327.spop)
	c:RegisterEffect(e1) 
	--SpecialSummon 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_TO_GRAVE) 
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP) 
	e2:SetCountLimit(1,23131327) 
	e2:SetTarget(c32131327.gsptg) 
	e2:SetOperation(c32131327.gspop) 
	c:RegisterEffect(e2) 
end
c32131327.SetCard_HR_flame13=true 
c32131327.HR_Flame_CodeList=32131326 
function c32131327.mfilter(c) 
	return c.SetCard_HR_flame13 
end  
function c32131327.ckfil(c) 
	return c:IsFaceup() and c.SetCard_HR_flame13   
end 
function c32131327.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c32131327.ckfil,tp,LOCATION_MZONE,0,1,e:GetHandler()) 
end 
function c32131327.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>4 end
end
function c32131327.spfilter(c,e,tp)
	return c.SetCard_HR_flame13 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c32131327.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=4 then return end
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5)
	local ct=g:GetCount()
	if ct>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:FilterCount(c32131327.spfilter,nil,e,tp)>0
		and Duel.SelectYesNo(tp,aux.Stringid(32131327,2)) then
		Duel.DisableShuffleCheck()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:FilterSelect(tp,c32131327.spfilter,1,1,nil,e,tp)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		ct=g:GetCount()-sg:GetCount()
	end
	if ct>0 then
		Duel.SortDecktop(tp,tp,ct)
		for i=1,ct do
			local mg=Duel.GetDecktopGroup(tp,1)
			Duel.MoveSequence(mg:GetFirst(),SEQ_DECKBOTTOM)
		end
	end
end 
function c32131327.gspfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c.SetCard_HR_flame13   
end 
function c32131327.gsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c32131327.gspfil,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE) 
end 
function c32131327.gspop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c32131327.gspfil,tp,LOCATION_GRAVE,0,e:GetHandler(),e,tp)
	if g:GetCount()>0 then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
	end 
end 












