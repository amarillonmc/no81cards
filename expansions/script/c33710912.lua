--风所到达的场所 ～ 亚由
function c33710912.initial_effect(c)
   --xyz summon
	aux.AddXyzProcedure(c,nil,11,5,c33710912.ovfilter,aux.Stringid(33710912,0),5,nil)
	c:EnableReviveLimit()  
	--SpecialSummonLIMIT
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c33710912.sslimit)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33710912,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c33710912.cost1)
	e2:SetTarget(c33710912.tg1)
	e2:SetOperation(c33710912.op1)
	c:RegisterEffect(e2)
end
function c33710912.ovfilter(c)
	return c:IsFaceup() and (c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_XYZ) or c:IsType(TYPE_FUSION)) and (c:IsLevelAbove(9) or c:IsRankAbove(9))
end
function c33710912.sslimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA)
end
function c33710912.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local sum=e:GetHandler():GetOverlayGroup():GetCount()
	if chk==0 then return e:GetHandler():GetOverlayCount()>0
		and e:GetHandler():CheckRemoveOverlayCard(tp,e:GetHandler():GetOverlayCount(),REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,e:GetHandler():GetOverlayCount(),e:GetHandler():GetOverlayCount(),REASON_COST)
	local sum1=e:GetHandler():GetOverlayGroup():GetCount()
	e:SetLabel(sum-sum1)
end
function c33710912.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c33710912.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetCurrentPhase()==PHASE_MAIN2 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,nil,tp,LOCATION_GRAVE)
end
function c33710912.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local num=e:GetLabel()
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then num=1 end
	if not (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c33710912.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)) then return end
	num=math.min(num,Duel.GetLocationCount(tp,LOCATION_MZONE))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c33710912.spfilter,tp,LOCATION_GRAVE,0,1,num,nil,e,tp)
	c:RegisterFlagEffect(33710912,RESET_EVENT+RESETS_STANDARD,0,0)
	if sg:GetCount()>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		local tc=sg:GetFirst()
		while tc do
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
			e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e2:SetLabelObject(c)
			e2:SetCondition(c33710912.condition1)
			e2:SetValue(aux.tgoval)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2,true)
			tc=sg:GetNext()
		end
	end
end
function c33710912.condition1(e)
	local c=e:GetLabelObject()
	return c:IsLocation(LOCATION_MZONE) and c:GetFlagEffect(33710912)~=0
end