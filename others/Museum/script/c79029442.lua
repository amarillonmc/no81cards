--使徒·行动-黑白恶魔的庇护
function c79029442.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,79029442)
	e1:SetTarget(c79029442.actg)
	e1:SetOperation(c79029442.acop)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,19029442)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c79029442.sptg)
	e2:SetOperation(c79029442.spop)
	c:RegisterEffect(e2)
end
function c79029442.ckfil(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x4909)
end
function c79029442.emfil(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa900) and ((not c:IsCanBeSpecialSummoned(e,0,tp,true,false) and not Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_SPECIAL_SUMMON)) or (Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_SPECIAL_SUMMON) and not c:IsSummonableCard()))
end
function c79029442.tdfil(c)
	return c:IsAbleToDeck() 
end
function c79029442.ckfil2(c)
	return c:IsCode(79029034,79029088)
end
function c79029442.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	local x=Duel.GetMatchingGroupCount(c79029442.ckfil,tp,LOCATION_ONFIELD,0,nil)
	local b1=Duel.IsExistingMatchingCard(c79029442.emfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) and x>0 
	local b2=Duel.IsExistingMatchingCard(c79029442.tdfil,tp,0,LOCATION_GRAVE+LOCATION_REMOVED,1,nil) and x>0 
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
	if Duel.IsExistingMatchingCard(c79029442.ckfil2,tp,LOCATION_ONFIELD,0,1,nil) then
	op=Duel.SelectOption(tp,aux.Stringid(79029442,0),aux.Stringid(79029442,1),aux.Stringid(79029442,2))
	else
	op=Duel.SelectOption(tp,aux.Stringid(79029442,0),aux.Stringid(79029442,1))
	end
	elseif b1 then
	op=Duel.SelectOption(tp,aux.Stringid(79029442,0))
	else
	op=Duel.SelectOption(tp,aux.Stringid(79029442,1))+1
	end
	e:SetLabel(op)
	if op==1 then
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,LOCATION_GRAVE+LOCATION_REMOVED) 
	end
end
function c79029442.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=e:GetLabel()
	local x=Duel.GetMatchingGroupCount(c79029442.ckfil,tp,LOCATION_ONFIELD,0,nil)
	if x<=0 then return end
	if op~=1 then
	Debug.Message("您要选择谁呢？")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029442,4))
	g=Duel.GetMatchingGroup(c79029442.emfil,tp,LOCATION_GRAVE,0,nil,e,tp) 
	sg=g:Select(tp,1,x,nil)
	local tc=sg:GetFirst()
	while tc do
	tc:CompleteProcedure()
	tc=sg:GetNext() 
	end
	end
	if op~=0 then 
	if op==2 then Duel.BreakEffect() end
	Debug.Message("痛苦，我从未忘记。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029442,5))
	g=Duel.GetMatchingGroup(c79029442.tdfil,tp,0,LOCATION_GRAVE+LOCATION_REMOVED,nil)
	tg=g:Select(tp,1,x,nil)
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local tc=tg:GetFirst()
	while tc do
	--forbidden
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCode(EFFECT_FORBIDDEN)
	e2:SetTargetRange(0x7f,0x7f)
	e2:SetTarget(c79029442.bantg)
	e2:SetLabelObject(tc)
	Duel.RegisterEffect(e2,tp)
	tc=tg:GetNext()
	end 
	end
end
function c79029442.bantg(e,c)
	return c==e:GetLabelObject()
end
function c79029442.spfil(c,e,tp)
	return c:IsSetCard(0xa900) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function c79029442.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local x=Duel.GetMatchingGroupCount(c79029442.ckfil,tp,LOCATION_ONFIELD,0,nil)
	if chk==0 then return x>0 and Duel.IsExistingMatchingCard(c79029442.spfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_GRAVE)
end
function c79029442.spop(e,tp,eg,ep,ev,re,r,rp)
	local x=Duel.GetMatchingGroupCount(c79029442.ckfil,tp,LOCATION_ONFIELD,0,nil)
	local g=Duel.GetMatchingGroup(c79029442.spfil,tp,LOCATION_GRAVE,0,nil,e,tp)
	if x<=0 or g:GetCount()<=0 then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if x>ft then x=ft end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then x=1 end
	local sg=g:Select(tp,1,x,nil) 
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end








